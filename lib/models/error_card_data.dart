/// model that describes data to pass in [ErrorCard].
class ErrorCardData {
  final String title;
  final String imgPath;

  /// true means that [ErrorCard] needs a refresh button
  final bool hasRefreshButton;

  ErrorCardData(
      {required this.title,
      required this.imgPath,
      this.hasRefreshButton = false});
}
