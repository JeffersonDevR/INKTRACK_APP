import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import '../utils/ocr_parser.dart';

class OcrResult {
  final double? amount;
  final String? clientName;

  OcrResult({this.amount, this.clientName});
}

class ScannerService {
  final TextRecognizer _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

  Future<OcrResult> scanImage(XFile image) async {
    final inputImage = InputImage.fromFilePath(image.path);
    final recognizedText = await _textRecognizer.processImage(inputImage);
    
    final fullText = recognizedText.text;
    return OcrResult(
      amount: OcrParser.findTotal(fullText),
      clientName: OcrParser.findClientName(fullText),
    );
  }

  void dispose() {
    _textRecognizer.close();
  }
}
