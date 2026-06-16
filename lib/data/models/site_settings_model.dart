import '../../domain/entities/site_settings.dart';

class SiteSettingsModel extends SiteSettings {
  const SiteSettingsModel({
    required super.siteName,
    required super.tagline,
    super.logo,
    super.favicon,
    required super.primaryColor,
    required super.contactEmail,
  });

  factory SiteSettingsModel.fromJson(Map<String, dynamic> json) {
    return SiteSettingsModel(
      siteName: json['site_name']?.toString() ?? 'Namasteram News',
      tagline: json['tagline']?.toString() ?? '',
      logo: json['logo']?.toString(),
      favicon: json['favicon']?.toString(),
      primaryColor: json['primary_color']?.toString() ?? '#E53935',
      contactEmail: json['contact_email']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'site_name': siteName,
        'tagline': tagline,
        'logo': logo,
        'favicon': favicon,
        'primary_color': primaryColor,
        'contact_email': contactEmail,
      };
}
