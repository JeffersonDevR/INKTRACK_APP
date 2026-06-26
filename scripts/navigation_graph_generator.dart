import 'dart:convert';
import 'dart:io';
import 'dart:math';

/// Navigation graph generator for InkTrack.
///
/// Scans lib/**/*_page.dart for page classes and Navigator.push calls,
/// merges manual overrides, and emits a self-contained navigation_map.html
/// with an embedded JSON graph data block (D3.js rendering deferred to PR-2).
void main() {
  final stopwatch = Stopwatch()..start();

  // ---- 1. Resolve paths ----
  final projectRoot = Directory.current;
  final libDir = Directory('${projectRoot.path}/lib');
  if (!libDir.existsSync()) {
    stderr.writeln('ERROR: lib/ directory not found at ${libDir.path}');
    exit(1);
  }

  final overridesPath =
      '${projectRoot.path}/scripts/navigation_graph_overrides.json';
  final outputPath = '${projectRoot.path}/navigation_map.html';

  // ---- 2. Scan for _page.dart files ----
  final pageFiles = _findPageFiles(libDir);
  if (pageFiles.isEmpty) {
    stderr.writeln('ERROR: no *_page.dart files found under lib/');
    exit(1);
  }

  // ---- 3. Parse nodes and edges from each file ----
  final nodes = <String, _NavNode>{};
  final edges = <_NavEdge>[];
  final edgesSet = <String>{};

  void addEdge(_NavEdge edge) {
    final key = '${edge.source}|${edge.target}|${edge.kind}';
    if (edgesSet.contains(key)) return;
    edgesSet.add(key);
    edges.add(edge);
  }

  for (final file in pageFiles) {
    final source = file.readAsStringSync();
    final relativePath = file.path.replaceFirst('${projectRoot.path}/', '');
    final classes = _extractClasses(source);

    for (final className in classes) {
      if (!nodes.containsKey(className)) {
        nodes[className] = _NavNode(
          id: className,
          className: className,
          file: relativePath,
          group: _inferGroup(relativePath),
        );
      }
    }

    // For each class in this file, find push targets
    for (final className in classes) {
      final pushEdges = _extractPushTargets(source, className);
      for (final edge in pushEdges) {
        addEdge(edge);
        _ensureNode(nodes, edge.target);
      }

      final helperEdges = _extractHelperCalls(source, className);
      for (final edge in helperEdges) {
        addEdge(edge);
        _ensureNode(nodes, edge.target);
      }
    }
  }

  // ---- 4. Read and apply overrides ----
  Map<String, dynamic> overrides;
  try {
    final overrideFile = File(overridesPath);
    if (!overrideFile.existsSync()) {
      stderr.writeln('ERROR: overrides file not found at $overridesPath');
      exit(1);
    }
    overrides = jsonDecode(overrideFile.readAsStringSync())
        as Map<String, dynamic>;
  } catch (e) {
    stderr.writeln('ERROR: malformed overrides file: $e');
    exit(1);
  }

  _applyOverrides(nodes, edges, edgesSet, overrides);

  // ---- 5. Compute in-degree ----
  for (final node in nodes.values) {
    node.inDegree = edges.where((e) => e.target == node.id).length;
  }

  // ---- 6. Warn about edges referencing unknown nodes ----
  for (final edge in edges) {
    if (!nodes.containsKey(edge.source)) {
      stderr.writeln(
          'WARNING: edge references unknown source "${edge.source}" — '
          'adding placeholder node');
      nodes[edge.source] = _NavNode(
        id: edge.source,
        className: edge.source,
        file: '',
        group: 'unknown',
        notes: 'synthetic',
      );
    }
    if (!nodes.containsKey(edge.target)) {
      stderr.writeln(
          'WARNING: edge references unknown target "${edge.target}" — '
          'adding placeholder node');
      nodes[edge.target] = _NavNode(
        id: edge.target,
        className: edge.target,
        file: '',
        group: 'unknown',
        notes: 'synthetic',
      );
    }
  }

  // ---- 7. Build JSON data block ----
  final nodeList = nodes.values.map((n) => n.toJson()).toList();
  final edgeList = edges.map((e) => e.toJson()).toList();

  final navData = {
    'nodes': nodeList,
    'edges': edgeList,
  };

  final jsonStr = const JsonEncoder.withIndent('  ').convert(navData);

  // ---- 8. Generate HTML ----
  final html = _generateHtml(jsonStr, nodeList.length, edgeList.length);

  // ---- 9. Write output ----
  File(outputPath).writeAsStringSync(html);
  stopwatch.stop();

  print('Navigation map generated: $outputPath');
  print('  Nodes: ${nodeList.length}');
  print('  Edges: ${edgeList.length}');
  print('  Time: ${stopwatch.elapsedMilliseconds}ms');
}

// ---------------------------------------------------------------------------
// File finding
// ---------------------------------------------------------------------------

List<File> _findPageFiles(Directory dir) {
  final result = <File>[];
  final entries = dir.listSync(recursive: true, followLinks: false);
  for (final entry in entries) {
    if (entry is File &&
        entry.path.endsWith('_page.dart') &&
        !entry.path.contains('/.dart_tool/') &&
        !entry.path.contains('/build/')) {
      result.add(entry);
    }
  }
  result.sort((a, b) => a.path.compareTo(b.path));
  return result;
}

// ---------------------------------------------------------------------------
// Parsing
// ---------------------------------------------------------------------------

List<String> _extractClasses(String source) {
  final re = RegExp(r'class\s+([A-Z]\w*Page)\s+extends\s+\w+');
  return re.allMatches(source).map((m) => m.group(1)!).toList();
}

List<_NavEdge> _extractPushTargets(String source, String sourceClass) {
  final edges = <_NavEdge>[];
  // Match the builder: (...) => [const] TargetPage pattern used in
  // MaterialPageRoute calls.  Does not need the full MaterialPageRoute(...)
  // wrapper — the builder pattern is specific enough in *_page.dart files
  // and avoids nested-paren complexity.
  final re = RegExp(
    r'builder\s*:\s*\([^()]*\)\s*=>\s*(?:const\s+)?([A-Z]\w*Page)\b',
    dotAll: true,
  );

  for (final match in re.allMatches(source)) {
    final targetClass = match.group(1)!;

    // Determine edge kind: check if preceding context contains
    // pushAndRemoveUntil
    final matchStart = match.start;
    final contextStart = max(0, matchStart - 300);
    final contextBefore = source.substring(contextStart, matchStart);
    final kind =
        contextBefore.contains('pushAndRemoveUntil') ? 'replace' : 'push';

    edges.add(_NavEdge(
      source: sourceClass,
      target: targetClass,
      kind: kind,
    ));
  }

  return edges;
}

List<_NavEdge> _extractHelperCalls(String source, String sourceClass) {
  final edges = <_NavEdge>[];
  if (source.contains('runImportFlow(') || source.contains('runImportFlow (')) {
    edges.add(_NavEdge(
      source: sourceClass,
      target: 'ImportPreviewPage',
      kind: 'helper',
    ));
  }
  return edges;
}

String _inferGroup(String path) {
  final featureRe = RegExp(r'lib/features/([^/]+)/');
  final match = featureRe.firstMatch(path);
  if (match != null) {
    return match.group(1)!;
  }
  if (path.startsWith('lib/core/')) {
    return 'core';
  }
  return 'unknown';
}

void _ensureNode(Map<String, _NavNode> nodes, String id) {
  if (!nodes.containsKey(id)) {
    nodes[id] = _NavNode(
      id: id,
      className: id,
      file: '',
      group: 'unknown',
      notes: 'inferred from edge',
    );
  }
}

// ---------------------------------------------------------------------------
// Override application
// ---------------------------------------------------------------------------

void _applyOverrides(
  Map<String, _NavNode> nodes,
  List<_NavEdge> edges,
  Set<String> edgesSet,
  Map<String, dynamic> overrides,
) {
  // Apply node overrides
  if (overrides.containsKey('nodes') && overrides['nodes'] is List) {
    for (final override in overrides['nodes'] as List) {
      final nodeMap = override as Map<String, dynamic>;
      final id = nodeMap['id'] as String;
      if (nodes.containsKey(id)) {
        final existing = nodes[id]!;
        if (nodeMap.containsKey('group')) {
          existing.group = nodeMap['group'] as String;
        }
        if (nodeMap.containsKey('notes')) {
          existing.notes = nodeMap['notes'] as String;
        }
      } else {
        nodes[id] = _NavNode(
          id: id,
          className: nodeMap['class'] as String? ?? id,
          file: nodeMap['file'] as String? ?? '',
          group: nodeMap['group'] as String? ?? 'unknown',
          notes: nodeMap['notes'] as String?,
        );
      }
    }
  }

  // Apply edge overrides
  if (overrides.containsKey('edges') && overrides['edges'] is List) {
    for (final override in overrides['edges'] as List) {
      final edgeMap = override as Map<String, dynamic>;
      final source = edgeMap['source'] as String;
      final target = edgeMap['target'] as String;
      final kind = edgeMap['kind'] as String? ?? 'push';
      final label = edgeMap['label'] as String?;

      final key = '$source|$target|$kind';

      if (edgesSet.contains(key)) {
        // Update label on existing edge
        for (final edge in edges) {
          if (edge.source == source &&
              edge.target == target &&
              edge.kind == kind) {
            edge.label = label;
            break;
          }
        }
      } else {
        edgesSet.add(key);
        edges.add(_NavEdge(
          source: source,
          target: target,
          kind: kind,
          label: label,
        ));
      }
    }
  }
}

// ---------------------------------------------------------------------------
// HTML generation
// ---------------------------------------------------------------------------

String _generateHtml(String jsonData, int nodeCount, int edgeCount) {
  return '''<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>InkTrack — Navigation Map</title>
<style>
  * { margin: 0; padding: 0; box-sizing: border-box; }
  body {
    font-family: system-ui, -apple-system, sans-serif;
    background: #0f172a;
    color: #e2e8f0;
    overflow: hidden;
    height: 100vh;
  }
  #container {
    width: 100vw;
    height: 100vh;
    position: relative;
  }
  .tooltip {
    position: absolute;
    padding: 10px 14px;
    background: #1e293b;
    border: 1px solid #334155;
    border-radius: 8px;
    font-size: 13px;
    line-height: 1.5;
    pointer-events: none;
    opacity: 0;
    transition: opacity 0.15s;
    z-index: 100;
    max-width: 320px;
    box-shadow: 0 4px 24px rgba(0,0,0,0.4);
  }
  .tooltip.visible { opacity: 1; }
  .tooltip .class-name { font-weight: 700; color: #38bdf8; }
  .tooltip .file-path { color: #64748b; font-size: 11px; margin-top: 2px; }
  .tooltip .group-badge {
    display: inline-block;
    padding: 1px 8px;
    border-radius: 10px;
    font-size: 10px;
    font-weight: 600;
    margin-top: 4px;
  }
  .tooltip .degree {
    color: #94a3b8;
    font-size: 11px;
    margin-top: 4px;
  }
  .tooltip .conn-list {
    margin-top: 4px;
    font-size: 11px;
    color: #94a3b8;
  }
  .tooltip .conn-list span {
    display: inline-block;
    background: #334155;
    padding: 1px 6px;
    border-radius: 4px;
    margin: 1px 2px;
    font-size: 10px;
  }
  #legend {
    position: absolute;
    top: 16px;
    right: 16px;
    background: #1e293b;
    border: 1px solid #334155;
    border-radius: 10px;
    padding: 14px 18px;
    font-size: 12px;
    z-index: 10;
    min-width: 140px;
  }
  #legend h3 {
    font-size: 11px;
    font-weight: 700;
    text-transform: uppercase;
    letter-spacing: 0.5px;
    color: #64748b;
    margin-bottom: 8px;
  }
  .legend-item {
    display: flex;
    align-items: center;
    gap: 8px;
    margin: 3px 0;
  }
  .legend-color {
    width: 10px;
    height: 10px;
    border-radius: 50%;
    flex-shrink: 0;
  }
  .legend-label {
    color: #cbd5e1;
  }
  #stats {
    position: absolute;
    bottom: 16px;
    left: 16px;
    color: #475569;
    font-size: 11px;
    z-index: 10;
  }
  #search-box {
    position: absolute;
    top: 16px;
    left: 16px;
    z-index: 10;
  }
  #search-box input {
    background: #1e293b;
    border: 1px solid #334155;
    border-radius: 8px;
    padding: 8px 14px;
    color: #e2e8f0;
    font-size: 13px;
    outline: none;
    width: 200px;
  }
  #search-box input:focus {
    border-color: #38bdf8;
  }
  #search-box input::placeholder {
    color: #475569;
  }
  .edge-label {
    font-size: 9px;
    fill: #64748b;
  }
</style>
</head>
<body>
<div id="container">
  <div id="search-box">
    <input type="text" id="search-input" placeholder="Search screens…">
  </div>
  <div id="legend">
    <h3>Legend</h3>
    <div class="legend-item"><div class="legend-color" style="background:#818cf8"></div><span class="legend-label">auth</span></div>
    <div class="legend-item"><div class="legend-color" style="background:#f472b6"></div><span class="legend-label">home</span></div>
    <div class="legend-item"><div class="legend-color" style="background:#38bdf8"></div><span class="legend-label">ventas</span></div>
    <div class="legend-item"><div class="legend-color" style="background:#4ade80"></div><span class="legend-label">clientes</span></div>
    <div class="legend-item"><div class="legend-color" style="background:#fb923c"></div><span class="legend-label">proveedores</span></div>
    <div class="legend-item"><div class="legend-color" style="background:#a78bfa"></div><span class="legend-label">inventario</span></div>
    <div class="legend-item"><div class="legend-color" style="background:#facc15"></div><span class="legend-label">movimientos</span></div>
    <div class="legend-item"><div class="legend-color" style="background:#2dd4bf"></div><span class="legend-label">locales</span></div>
    <div class="legend-item"><div class="legend-color" style="background:#94a3b8"></div><span class="legend-label">core</span></div>
    <div class="legend-item"><div class="legend-color" style="background:#475569"></div><span class="legend-label">unknown</span></div>
    <div style="margin-top:8px;border-top:1px solid #334155;padding-top:6px;">
      <div class="legend-item">
        <svg width="20" height="4"><line x1="0" y1="2" x2="20" y2="2" stroke="#64748b" stroke-width="1.5"/></svg>
        <span class="legend-label">push / replace</span>
      </div>
      <div class="legend-item">
        <svg width="20" height="4"><line x1="0" y1="2" x2="20" y2="2" stroke="#64748b" stroke-width="1.5" stroke-dasharray="5,3"/></svg>
        <span class="legend-label">conditional</span>
      </div>
      <div class="legend-item">
        <svg width="20" height="4"><line x1="0" y1="2" x2="20" y2="2" stroke="#475569" stroke-width="1.5" stroke-dasharray="5,3"/></svg>
        <span class="legend-label">tab</span>
      </div>
      <div class="legend-item">
        <svg width="20" height="4"><line x1="0" y1="2" x2="20" y2="2" stroke="#64748b" stroke-width="1.5" stroke-dasharray="2,2"/></svg>
        <span class="legend-label">helper</span>
      </div>
      <div class="legend-item">
        <svg width="20" height="4"><line x1="0" y1="2" x2="20" y2="2" stroke="#94a3b8" stroke-width="2.5"/></svg>
        <span class="legend-label">root</span>
      </div>
    </div>
  </div>
  <div id="stats">$nodeCount nodes · $edgeCount edges · Generated by navigation_graph_generator.dart</div>
  <div id="tooltip" class="tooltip"></div>
</div>

<script id="nav-data" type="application/json">
$jsonData
</script>

<script src="https://d3js.org/d3.v7.min.js"></script>
<script>
// D3.js v7 force-directed navigation graph
(function() {
  'use strict';

  // ---- Data ----
  const raw = document.getElementById('nav-data').textContent;
  const data = JSON.parse(raw);
  const nodes = data.nodes;
  const edges = data.edges;

  // Build a lookup map
  const nodeMap = {};
  nodes.forEach(function(n) { nodeMap[n.id] = n; });

  // ---- Dimensions ----
  var width = window.innerWidth;
  var height = window.innerHeight;

  // ---- Group color palette (matches legend) ----
  var groupColors = {
    auth: '#818cf8', home: '#f472b6', ventas: '#38bdf8',
    clientes: '#4ade80', proveedores: '#fb923c', inventario: '#a78bfa',
    movimientos: '#facc15', locales: '#2dd4bf', core: '#94a3b8',
    root: '#f472b6', unknown: '#475569'
  };

  // ---- SVG (insert before tooltip to keep z-order) ----
  var svg = d3.select('#container').insert('svg', '#tooltip')
    .attr('width', width)
    .attr('height', height)
    .style('background', '#0f172a')
    .style('position', 'absolute')
    .style('top', 0)
    .style('left', 0);

  // ---- Defs: markers and filters ----
  var defs = svg.append('defs');

  // Marker: regular edge
  defs.append('marker')
    .attr('id', 'arrow-regular')
    .attr('viewBox', '0 -5 10 10')
    .attr('refX', 22).attr('refY', 0)
    .attr('markerWidth', 8).attr('markerHeight', 8)
    .attr('orient', 'auto')
    .append('path').attr('d', 'M0,-5L10,0L0,5').attr('fill', '#64748b');

  // Marker: root edge (thicker, lighter)
  defs.append('marker')
    .attr('id', 'arrow-root')
    .attr('viewBox', '0 -5 10 10')
    .attr('refX', 24).attr('refY', 0)
    .attr('markerWidth', 10).attr('markerHeight', 10)
    .attr('orient', 'auto')
    .append('path').attr('d', 'M0,-5L10,0L0,5').attr('fill', '#94a3b8');

  // Marker: tab edge
  defs.append('marker')
    .attr('id', 'arrow-tab')
    .attr('viewBox', '0 -5 10 10')
    .attr('refX', 22).attr('refY', 0)
    .attr('markerWidth', 8).attr('markerHeight', 8)
    .attr('orient', 'auto')
    .append('path').attr('d', 'M0,-5L10,0L0,5').attr('fill', '#475569');

  // ---- Zoom / pan container ----
  var g = svg.append('g');

  // ---- Helper: edge style lookups ----
  function edgeColor(d) {
    if (d.kind === 'root') return '#94a3b8';
    if (d.kind === 'tab') return '#475569';
    return '#64748b';
  }
  function edgeWidth(d) {
    return d.kind === 'root' ? 2.5 : 1.5;
  }
  function edgeDash(d) {
    if (d.kind === 'conditional' || d.kind === 'tab') return '5,3';
    if (d.kind === 'helper') return '2,2';
    return null;
  }
  function markerEnd(d) {
    if (d.kind === 'root') return 'url(#arrow-root)';
    if (d.kind === 'tab') return 'url(#arrow-tab)';
    return 'url(#arrow-regular)';
  }

  // ---- Draw edges ----
  var linkGroup = g.append('g').attr('class', 'links');

  var linkElements = linkGroup.selectAll('line')
    .data(edges)
    .enter().append('line')
    .attr('stroke', edgeColor)
    .attr('stroke-width', edgeWidth)
    .attr('stroke-dasharray', function(d) { return edgeDash(d) || 'none'; })
    .attr('marker-end', markerEnd);

  // Hidden paths for conditional edge labels (textPath)
  var conditionalEdges = edges.filter(function(d) {
    return d.kind === 'conditional' && d.label;
  });
  var edgeLabelPaths = linkGroup.selectAll('path.edge-path')
    .data(conditionalEdges)
    .enter().append('path')
    .attr('class', 'edge-path')
    .attr('fill', 'none')
    .attr('stroke', 'none')
    .attr('id', function(_, i) { return 'edge-path-' + i; });

  var edgeLabels = linkGroup.selectAll('text.edge-label')
    .data(conditionalEdges)
    .enter().append('text')
    .attr('class', 'edge-label')
    .append('textPath')
    .attr('href', function(_, i) { return '#edge-path-' + i; })
    .attr('startOffset', '50%')
    .attr('text-anchor', 'middle')
    .text(function(d) { return d.label; });

  // ---- Draw nodes ----
  var nodeGroup = g.append('g').attr('class', 'nodes');

  var nodeRadius = function(d) {
    return Math.max(10, 5 + (d.inDegree || 0) * 3);
  };
  var nodeFill = function(d) {
    return groupColors[d.group] || '#475569';
  };

  var nodeElements = nodeGroup.selectAll('circle')
    .data(nodes)
    .enter().append('circle')
    .attr('r', nodeRadius)
    .attr('fill', nodeFill)
    .attr('stroke', '#fff')
    .attr('stroke-width', 1.5)
    .style('cursor', 'pointer')
    .on('mouseover', showTooltip)
    .on('mouseout', hideTooltip);

  var labelElements = nodeGroup.selectAll('text')
    .data(nodes)
    .enter().append('text')
    .text(function(d) { return d['class'] || d.id; })
    .attr('text-anchor', 'middle')
    .attr('dy', function(d) { return nodeRadius(d) + 16; })
    .attr('font-family', 'sans-serif')
    .attr('fill', '#e2e8f0')
    .attr('font-size', '12px')
    .attr('pointer-events', 'none');

  // ---- Force simulation ----
  var simulation = d3.forceSimulation(nodes)
    .force('link', d3.forceLink(edges).id(function(d) { return d.id; }).distance(180))
    .force('charge', d3.forceManyBody().strength(-300))
    .force('center', d3.forceCenter(width / 2, height / 2))
    .force('collide', d3.forceCollide().radius(function(d) {
      return Math.max(80, nodeRadius(d) + 30);
    }))
    .on('tick', ticked);

  function ticked() {
    // Update edges
    linkElements
      .attr('x1', function(d) { return d.source.x; })
      .attr('y1', function(d) { return d.source.y; })
      .attr('x2', function(d) { return d.target.x; })
      .attr('y2', function(d) { return d.target.y; });

    // Update conditional edge label paths (midpoint textPath)
    edgeLabelPaths
      .attr('d', function(d) {
        var sx = d.source.x, sy = d.source.y;
        var tx = d.target.x, ty = d.target.y;
        // textPath follows first half of the edge
        var mx = (sx + tx) / 2, my = (sy + ty) / 2;
        return 'M' + sx + ',' + sy + 'L' + mx + ',' + my;
      });

    // Update nodes
    nodeElements
      .attr('cx', function(d) { return d.x; })
      .attr('cy', function(d) { return d.y; });

    labelElements
      .attr('x', function(d) { return d.x; })
      .attr('y', function(d) { return d.y; });
  }

  // ---- Zoom / pan ----
  svg.call(d3.zoom()
    .scaleExtent([0.1, 4])
    .on('zoom', function(event) {
      g.attr('transform', event.transform);
    })
  );

  // ---- Tooltip ----
  function showTooltip(event, d) {
    var tooltip = document.getElementById('tooltip');
    var filteredEdges = edges;
    // Determine connected targets
    var targets = [];
    var sources = [];
    for (var i = 0; i < filteredEdges.length; i++) {
      var e = filteredEdges[i];
      var srcId = typeof e.source === 'object' ? e.source.id : e.source;
      var tgtId = typeof e.target === 'object' ? e.target.id : e.target;
      if (srcId === d.id) targets.push(tgtId);
      if (tgtId === d.id) sources.push(srcId);
    }

    var routeInfo = d.notes ? d.notes : 'anonymous';

    tooltip.innerHTML =
      '<div class="class-name">' + (d['class'] || d.id) + '</div>' +
      '<div class="file-path">' + (d.file || '') + '</div>' +
      '<div class="degree">Route: ' + routeInfo + '</div>' +
      '<div class="conn-list">Navigates to: ' +
        (targets.length ? targets.map(function(t) {
          return '<span>' + t + '</span>';
        }).join('') : '<span>none</span>') +
      '</div>' +
      '<div class="conn-list">Navigated from: ' +
        (sources.length ? sources.map(function(s) {
          return '<span>' + s + '</span>';
        }).join('') : '<span>none</span>') +
      '</div>';

    tooltip.className = 'tooltip visible';
    var rect = event.target.getBoundingClientRect();
    // Position to the right of the node; flip if near right edge
    var left = rect.right + 15;
    var top = Math.max(0, rect.top + rect.height / 2 - 10);
    if (left + 330 > window.innerWidth) {
      left = rect.left - 330;
    }
    tooltip.style.left = left + 'px';
    tooltip.style.top = top + 'px';
  }

  function hideTooltip() {
    document.getElementById('tooltip').className = 'tooltip';
  }

  // ---- Search / filter ----
  document.getElementById('search-input').addEventListener('input', function() {
    var query = this.value.toLowerCase().trim();

    nodeElements
      .attr('opacity', function(d) {
        if (!query) return 1;
        var name = (d['class'] || d.id).toLowerCase();
        return name.indexOf(query) !== -1 ? 1 : 0.15;
      })
      .attr('stroke-opacity', function(d) {
        if (!query) return 1;
        var name = (d['class'] || d.id).toLowerCase();
        return name.indexOf(query) !== -1 ? 1 : 0.15;
      });

    labelElements
      .attr('opacity', function(d) {
        if (!query) return 1;
        var name = (d['class'] || d.id).toLowerCase();
        return name.indexOf(query) !== -1 ? 1 : 0.15;
      });

    function nodeName(id) {
      var n = nodeMap[id];
      return n ? (n['class'] || n.id).toLowerCase() : id.toLowerCase();
    }

    linkElements
      .attr('opacity', function(d) {
        if (!query) return 1;
        var src = (typeof d.source === 'object' ? nodeName(d.source.id) : nodeName(d.source));
        var tgt = (typeof d.target === 'object' ? nodeName(d.target.id) : nodeName(d.target));
        return src.indexOf(query) !== -1 || tgt.indexOf(query) !== -1 ? 1 : 0.15;
      });

    edgeLabels
      .attr('opacity', function(d) {
        if (!query) return 1;
        var src = (typeof d.source === 'object' ? nodeName(d.source.id) : nodeName(d.source));
        var tgt = (typeof d.target === 'object' ? nodeName(d.target.id) : nodeName(d.target));
        return src.indexOf(query) !== -1 || tgt.indexOf(query) !== -1 ? 1 : 0.15;
      });
  });

  // ---- Resize handler ----
  window.addEventListener('resize', function() {
    width = window.innerWidth;
    height = window.innerHeight;
    svg.attr('width', width).attr('height', height);
    simulation.force('center', d3.forceCenter(width / 2, height / 2));
    simulation.alpha(0.3).restart();
  });

  // ---- Kick off with initial positions spread around center ----
  for (var k = 0; k < nodes.length; k++) {
    nodes[k].x = width / 2 + (Math.random() - 0.5) * 300;
    nodes[k].y = height / 2 + (Math.random() - 0.5) * 300;
  }
})();
</script>
</body>
</html>''';
}

// ---------------------------------------------------------------------------
// Data classes
// ---------------------------------------------------------------------------

class _NavNode {
  final String id;
  final String className;
  final String file;
  String group;
  String? notes;
  int inDegree;

  _NavNode({
    required this.id,
    required this.className,
    required this.file,
    required this.group,
    this.notes,
    this.inDegree = 0,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'class': className,
        'file': file,
        'group': group,
        if (notes != null) 'notes': notes,
        'inDegree': inDegree,
      };
}

class _NavEdge {
  final String source;
  final String target;
  final String kind;
  String? label;

  _NavEdge({
    required this.source,
    required this.target,
    required this.kind,
    this.label,
  });

  Map<String, dynamic> toJson() => {
        'source': source,
        'target': target,
        'kind': kind,
        if (label != null) 'label': label,
      };
}
