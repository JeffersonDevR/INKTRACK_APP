import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';

// Import the generator script directly — we test the pure functions.
// Since the generator is a script (not a library), we redefine the key
// functions here to test them. In a real package these would be library
// exports; for a zero-dep script this is the idiomatic approach.

// ---------------------------------------------------------------------------
// Extracted logic under test (mirrors scripts/navigation_graph_generator.dart)
// ---------------------------------------------------------------------------

List<String> extractClasses(String source) {
  final re = RegExp(r'class\s+([A-Z]\w*Page)\s+extends\s+\w+');
  return re.allMatches(source).map((m) => m.group(1)!).toList();
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

List<_NavEdge> extractPushTargets(String source, String sourceClass) {
  final edges = <_NavEdge>[];
  final re = RegExp(
    r'builder\s*:\s*\([^()]*\)\s*=>\s*(?:const\s+)?([A-Z]\w*Page)\b',
    dotAll: true,
  );

  for (final match in re.allMatches(source)) {
    final targetClass = match.group(1)!;
    final matchStart = match.start;
    final contextStart = matchStart > 300 ? matchStart - 300 : 0;
    final contextBefore = source.substring(contextStart, matchStart);
    final kind = contextBefore.contains('pushAndRemoveUntil') ? 'replace' : 'push';

    edges.add(_NavEdge(
      source: sourceClass,
      target: targetClass,
      kind: kind,
    ));
  }

  return edges;
}

List<_NavEdge> extractHelperCalls(String source, String sourceClass) {
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

String inferGroup(String path) {
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

Map<String, dynamic> applyOverrides(
  Map<String, dynamic> nodesJson,
  List<Map<String, dynamic>> edgesJson,
  Map<String, dynamic> overrides,
) {
  final nodes = <String, Map<String, dynamic>>{};
  for (final node in nodesJson.entries) {
    nodes[node.key] = Map<String, dynamic>.from(node.value);
  }
  final edges = edgesJson.map((e) => Map<String, dynamic>.from(e)).toList();
  final edgesSet = <String>{};
  for (final edge in edges) {
    edgesSet.add('${edge['source']}|${edge['target']}|${edge['kind']}');
  }

  if (overrides.containsKey('nodes') && overrides['nodes'] is List) {
    for (final override in overrides['nodes'] as List) {
      final nodeMap = override as Map<String, dynamic>;
      final id = nodeMap['id'] as String;
      if (nodes.containsKey(id)) {
        if (nodeMap.containsKey('group')) nodes[id]!['group'] = nodeMap['group'];
        if (nodeMap.containsKey('notes')) nodes[id]!['notes'] = nodeMap['notes'];
      } else {
        nodes[id] = Map<String, dynamic>.from(nodeMap);
      }
    }
  }

  if (overrides.containsKey('edges') && overrides['edges'] is List) {
    for (final override in overrides['edges'] as List) {
      final edgeMap = override as Map<String, dynamic>;
      final source = edgeMap['source'] as String;
      final target = edgeMap['target'] as String;
      final kind = edgeMap['kind'] as String? ?? 'push';
      final key = '$source|$target|$kind';

      if (edgesSet.contains(key)) {
        for (final edge in edges) {
          if (edge['source'] == source &&
              edge['target'] == target &&
              edge['kind'] == kind) {
            if (edgeMap.containsKey('label')) edge['label'] = edgeMap['label'];
            break;
          }
        }
      } else {
        edgesSet.add(key);
        edges.add(Map<String, dynamic>.from(edgeMap));
      }
    }
  }

  return {
    'nodes': nodes,
    'edges': edges,
  };
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('extractClasses', () {
    test('finds page classes in source', () {
      const source = '''
class LoginPage extends StatefulWidget { }
class HomePage extends StatelessWidget { }
class NotAPage extends SomeWidget { }
''';
      expect(extractClasses(source), unorderedEquals(['LoginPage', 'HomePage']));
    });

    test('returns empty for no page classes', () {
      const source = 'class Foo extends Bar { }';
      expect(extractClasses(source), isEmpty);
    });

    test('finds classes with different base types', () {
      const source = '''
class ClienteFormPage extends StatefulWidget { }
class MyPage extends ConsumerWidget { }
''';
      expect(extractClasses(source), unorderedEquals(['ClienteFormPage', 'MyPage']));
    });
  });

  group('extractPushTargets', () {
    test('single-line MaterialPageRoute', () {
      const source = '''
class HomePage extends StatelessWidget {
  void go(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => ProductoFormPage()));
  }
}
''';
      final edges = extractPushTargets(source, 'HomePage');
      expect(edges.length, 1);
      expect(edges[0].source, 'HomePage');
      expect(edges[0].target, 'ProductoFormPage');
      expect(edges[0].kind, 'push');
    });

    test('multi-line MaterialPageRoute', () {
      const source = '''
class MainLayoutPage extends StatefulWidget {
  void go(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const RegistrarVentaPage(),
      ),
    );
  }
}
''';
      final edges = extractPushTargets(source, 'MainLayoutPage');
      expect(edges.length, 1);
      expect(edges[0].target, 'RegistrarVentaPage');
      expect(edges[0].kind, 'push');
    });

    test('pushAndRemoveUntil yields kind replace', () {
      const source = '''
class ProfilePage extends StatelessWidget {
  void go(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (route) => false,
    );
  }
}
''';
      final edges = extractPushTargets(source, 'ProfilePage');
      expect(edges.length, 1);
      expect(edges[0].target, 'LoginPage');
      expect(edges[0].kind, 'replace');
    });

    test('Navigator.of(context).push variant', () {
      const source = '''
class SomePage extends StatelessWidget {
  void go(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const LocalesPage()),
    );
  }
}
''';
      final edges = extractPushTargets(source, 'SomePage');
      expect(edges.length, 1);
      expect(edges[0].target, 'LocalesPage');
      expect(edges[0].kind, 'push');
    });
  });

  group('extractHelperCalls', () {
    test('detects runImportFlow call', () {
      const source = '''
class HomePage extends StatelessWidget {
  Future<void> import() async {
    await runImportFlow<Venta>(
      context: context,
      moduleName: 'Ventas',
      ...
    );
  }
}
''';
      final edges = extractHelperCalls(source, 'HomePage');
      expect(edges.length, 1);
      expect(edges[0].target, 'ImportPreviewPage');
      expect(edges[0].kind, 'helper');
    });

    test('returns empty for no call', () {
      const source = 'class SomePage extends StatelessWidget { }';
      expect(extractHelperCalls(source, 'SomePage'), isEmpty);
    });
  });

  group('inferGroup', () {
    test('extracts feature group from path', () {
      expect(
        inferGroup('lib/features/auth/presentation/pages/login_page.dart'),
        'auth',
      );
      expect(
        inferGroup('lib/features/ventas/presentation/pages/home_page.dart'),
        'ventas',
      );
      expect(
        inferGroup('lib/features/clientes/presentation/pages/clientes_page.dart'),
        'clientes',
      );
    });

    test('returns core for lib/core path', () {
      expect(
        inferGroup('lib/core/widgets/import_preview_page.dart'),
        'core',
      );
    });

    test('returns unknown for unrecognized path', () {
      expect(inferGroup('lib/something/other.dart'), 'unknown');
    });
  });

  group('override merge', () {
    test('adds synthetic node', () {
      final overrides = {
        'nodes': [
          {
            'id': 'app:root',
            'class': 'app:root',
            'file': 'lib/main.dart',
            'group': 'root',
          },
        ],
        'edges': [],
      };
      final result = applyOverrides({}, [], overrides);
      expect(result['nodes'], containsPair('app:root', anything));
      expect(result['nodes']['app:root']['group'], 'root');
    });

    test('adds override edges', () {
      final overrides = {
        'nodes': [],
        'edges': [
          {
            'source': 'app:root',
            'target': 'LoginPage',
            'kind': 'root',
            'label': 'state:loggedOut',
          },
        ],
      };
      final result = applyOverrides({}, [], overrides);
      expect(result['edges'].length, 1);
      expect(result['edges'][0]['source'], 'app:root');
      expect(result['edges'][0]['label'], 'state:loggedOut');
    });

    test('deduplicates edges by (source, target, kind)', () {
      final existing = [
        {'source': 'A', 'target': 'B', 'kind': 'push'},
      ];
      final overrides = {
        'nodes': [],
        'edges': [
          {'source': 'A', 'target': 'B', 'kind': 'push', 'label': 'updated'},
        ],
      };
      final result = applyOverrides({}, existing, overrides);
      // Should be 1 edge (not 2), with label updated
      expect(result['edges'].length, 1);
      expect(result['edges'][0]['label'], 'updated');
    });

    test('appends new unique edges', () {
      final existing = [
        {'source': 'A', 'target': 'B', 'kind': 'push'},
      ];
      final overrides = {
        'nodes': [],
        'edges': [
          {'source': 'B', 'target': 'C', 'kind': 'push'},
        ],
      };
      final result = applyOverrides({}, existing, overrides);
      expect(result['edges'].length, 2);
    });
  });

  group('integration', () {
    test('generator produces valid HTML with embedded JSON', () {
      // Create a temporary project structure
      final tmpDir = Directory.systemTemp.createTempSync('nav_map_test_');
      try {
        // Create lib/features/ventas/presentation/pages/home_page.dart
        final homePageDir = Directory(
          '${tmpDir.path}/lib/features/ventas/presentation/pages',
        )
          ..createSync(recursive: true);
        File('${homePageDir.path}/home_page.dart').writeAsStringSync('''
import 'package:flutter/material.dart';
import 'package:InkTrack/core/utils/import_flow.dart';
import 'package:InkTrack/features/movimientos/presentation/pages/movimiento_form_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void goIngreso(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MovimientoFormPage(
          initialType: MovimientoType.ingreso,
        ),
      ),
    );
  }

  Future<void> import(BuildContext context) async {
    await runImportFlow<Venta>(
      context: context,
      moduleName: 'Ventas',
      requiredColumns: [],
    );
  }
}
''');

        // Create lib/core/widgets/import_preview_page.dart
        final coreDir =
            Directory('${tmpDir.path}/lib/core/widgets')..createSync(recursive: true);
        File('${coreDir.path}/import_preview_page.dart').writeAsStringSync('''
class ImportPreviewPage extends StatelessWidget {
  const ImportPreviewPage({super.key});
}
''');

        // Create overrides file
        final scriptsDir = Directory('${tmpDir.path}/scripts')..createSync(recursive: true);
        File('${scriptsDir.path}/navigation_graph_overrides.json').writeAsStringSync(
          jsonEncode({
            'nodes': [
              {
                'id': 'app:root',
                'class': 'app:root',
                'file': 'lib/main.dart',
                'group': 'root',
              },
            ],
            'edges': [
              {
                'source': 'app:root',
                'target': 'LoginPage',
                'kind': 'root',
                'label': 'state:loggedOut',
              },
            ],
          }),
        );

        // Run the generator script
        final result = await Process.run(
          'dart',
          [
            '${Directory.current.path}/scripts/navigation_graph_generator.dart',
          ],
          workingDirectory: tmpDir.path,
        );

        expect(result.exitCode, 0,
            reason: 'Generator exited with code ${result.exitCode}: '
                '${result.stderr}');

        // Verify output exists
        final outputFile = File('${tmpDir.path}/navigation_map.html');
        expect(outputFile.existsSync(), true);

        final html = outputFile.readAsStringSync();

        // Verify embedded JSON block
        expect(html, contains('<script id="nav-data" type="application/json">'));
        expect(html, contains('</script>'));

        // Extract JSON and validate
        final jsonStart =
            html.indexOf('<script id="nav-data" type="application/json">');
        final contentStart = html.indexOf('>', jsonStart) + 1;
        final jsonEnd = html.indexOf('</script>', contentStart);
        final jsonStr = html.substring(contentStart, jsonEnd).trim();

        final data = jsonDecode(jsonStr) as Map<String, dynamic>;
        expect(data, containsPair('nodes', isA<List>));
        expect(data, containsPair('edges', isA<List>));

        final nodes = data['nodes'] as List;
        final edges = data['edges'] as List;

        // Should at least include HomePage, ImportPreviewPage, MovimientoFormPage
        final nodeIds = nodes.map((n) => (n as Map)['id'] as String).toSet();
        expect(nodeIds, contains('HomePage'));
        expect(nodeIds, contains('ImportPreviewPage'));
        expect(nodeIds, contains('MovimientoFormPage'));

        // Should have push edge from HomePage -> MovimientoFormPage
        final pushEdges = edges.where((e) =>
            (e as Map)['source'] == 'HomePage' &&
            (e)['target'] == 'MovimientoFormPage' &&
            (e)['kind'] == 'push');
        expect(pushEdges.length, 1);

        // Should have helper edge from HomePage -> ImportPreviewPage
        final helperEdges = edges.where((e) =>
            (e as Map)['source'] == 'HomePage' &&
            (e)['target'] == 'ImportPreviewPage' &&
            (e)['kind'] == 'helper');
        expect(helperEdges.length, 1);

        // Should have override edge app:root -> LoginPage
        final rootEdges = edges.where((e) =>
            (e as Map)['source'] == 'app:root' &&
            (e)['target'] == 'LoginPage' &&
            (e)['kind'] == 'root');
        expect(rootEdges.length, 1);

        // Verify node inDegree
        final movFormNode = nodes.firstWhere(
            (n) => (n as Map)['id'] == 'MovimientoFormPage');
        expect((movFormNode as Map)['inDegree'], 1);

        // Verify HTML structure
        expect(html, contains('<!DOCTYPE html>'));
        expect(html, contains('<script src="https://d3js.org/d3.v7.min.js">'));
      } finally {
        tmpDir.deleteSync(recursive: true);
      }
    });
  });
}
