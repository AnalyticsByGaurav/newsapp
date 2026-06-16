import 'package:equatable/equatable.dart';

class SiteSettings extends Equatable {
  final String siteName;
  final String tagline;
  final String? logo;
  final String? favicon;
  final String primaryColor;
  final String contactEmail;

  const SiteSettings({
    required this.siteName,
    required this.tagline,
    this.logo,
    this.favicon,
    required this.primaryColor,
    required this.contactEmail,
  });

  @override
  List<Object?> get props => [siteName, primaryColor, contactEmail];
}
