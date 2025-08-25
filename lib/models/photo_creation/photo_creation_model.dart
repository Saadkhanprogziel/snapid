class PhotoCreationModel {
  final String id;
  final String userId;
  final String? guestId;
  final String status;
  final String countryCode;
  final String countryName;
  final String documentType;
  final double? customWidth;
  final double? customHeight;
  final int photos;
  final String processedWatermarkedUrl;
  final bool canDownloadImage;
  final String platform;
  final String createdAt;

  PhotoCreationModel({
    required this.id,
    required this.userId,
    this.guestId,
    required this.status,
    required this.countryCode,
    required this.countryName,
    required this.documentType,
    this.customWidth,
    this.customHeight,
    required this.photos,
    required this.processedWatermarkedUrl,
    required this.canDownloadImage,
    required this.platform,
    required this.createdAt,
  });

  factory PhotoCreationModel.fromJson(Map<String, dynamic> json) {
    return PhotoCreationModel(
      id: json["id"] ?? "",
      userId: json["userId"] ?? "",
      guestId: json["guestId"],
      status: json["status"] ?? "",
      countryCode: json["countryCode"] ?? "",
      countryName: json["countryName"] ?? "",
      documentType: json["documentType"] ?? "",
      customWidth: json["customWidth"] != null
          ? double.tryParse(json["customWidth"].toString())
          : null,
      customHeight: json["customHeight"] != null
          ? double.tryParse(json["customHeight"].toString())
          : null,
      photos: json["photos"] ?? 0,
      processedWatermarkedUrl: json["processedWatermarkedUrl"] ?? "",
      canDownloadImage: json["canDownloadImage"] ?? false,
      platform: json["platform"] ?? "",
      createdAt: json["createdAt"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "userId": userId,
      "guestId": guestId,
      "status": status,
      "countryCode": countryCode,
      "countryName": countryName,
      "documentType": documentType,
      "customWidth": customWidth,
      "customHeight": customHeight,
      "photos": photos,
      "processedWatermarkedUrl": processedWatermarkedUrl,
      "canDownloadImage": canDownloadImage,
      "platform": platform,
      "createdAt": createdAt,
    };
  }
}
