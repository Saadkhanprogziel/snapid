
import 'dart:html' as html;

class WebDownloadHelper {
  static Future<void> downloadImage(String url) async {
    try {
      final response = await html.HttpRequest.request(
        url,
        responseType: "blob",
      );
      final blob = response.response as html.Blob;
      final objectUrl = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: objectUrl)
        ..download = "snapid_image_${DateTime.now().millisecondsSinceEpoch}.jpg"
        ..style.display = 'none';
      html.document.body?.append(anchor);
      anchor.click();
      anchor.remove();
      html.Url.revokeObjectUrl(objectUrl);
    } catch (e) {
      print('Download failed: $e');
    }
  }
}
