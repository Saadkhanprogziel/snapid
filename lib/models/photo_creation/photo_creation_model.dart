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
  final String? processedImageUrl;
  final bool canDownloadImage;
  final String platform;
  final String countryFlag;
  final String size;
  final String createdAt;
  final List<String> originalImages; // ✅ new field

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
    this.processedImageUrl,
    required this.countryFlag,
    required this.size,
    required this.canDownloadImage,
    required this.platform,
    required this.createdAt,
    this.originalImages = const [], // ✅ default empty list
  });

  factory PhotoCreationModel.fromJson(Map<String, dynamic> json) {
    return PhotoCreationModel(
      id: json["id"]?.toString() ?? "",
      userId: json["userId"]?.toString() ?? "",
      guestId: json["guestId"]?.toString(),
      countryFlag: json['countryFlag']?.toString() ?? "",
      status: json["status"]?.toString() ?? "",
      size: json["size"]?.toString() ?? "",
      countryCode: json["countryCode"]?.toString() ?? "",
      countryName: json["countryName"]?.toString() ?? "",
      documentType: json["documentType"]?.toString() ?? "",
      customWidth: json["customWidth"] != null
          ? double.tryParse(json["customWidth"].toString())
          : null,
      customHeight: json["customHeight"] != null
          ? double.tryParse(json["customHeight"].toString())
          : null,
      photos: int.tryParse(json["photos"]?.toString() ?? "0") ?? 0,
      processedWatermarkedUrl: json["processedWatermarkedUrl"]?.toString() ?? "",
      processedImageUrl: json["processedImageUrl"]?.toString(),
      canDownloadImage: json["canDownloadImage"] is bool
          ? json["canDownloadImage"]
          : json["canDownloadImage"]?.toString().toLowerCase() == "true",
      platform: json["platform"]?.toString() ?? "",
      createdAt: json["createdAt"]?.toString() ?? "",
      originalImages: (json["originalImages"] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [], // ✅ parse array of URLs
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
      "countryFlag": countryFlag,
      "processedWatermarkedUrl": processedWatermarkedUrl,
      "processedImageUrl": processedImageUrl,
      "canDownloadImage": canDownloadImage,
      "platform": platform,
      "createdAt": createdAt,
      "size": size,
      "originalImages": originalImages, // ✅ include in JSON
    };
  }
}
