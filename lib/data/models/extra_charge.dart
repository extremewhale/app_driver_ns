class ExtraCharge {
  final String fullText;
  final String shortText;
  final String finalAmount;
  final bool mustAddAmount;

  const ExtraCharge({
    required this.fullText,
    required this.shortText,
    required this.finalAmount,
    this.mustAddAmount = false,
  });
}
