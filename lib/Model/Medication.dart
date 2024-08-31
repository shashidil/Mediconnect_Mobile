class Medication {
  final String medicationName;
  final String medicationDosage;
  final String? days;
  final int medicationQuantity;
  final double amount;

  Medication({
    required this.medicationName,
    required this.medicationDosage,
    this.days,
    required this.medicationQuantity,
    required this.amount,
  });

  factory Medication.fromJson(Map<String, dynamic> json) {
    return Medication(
      medicationName: json['medicationName'],
      medicationDosage: json['medicationDosage'],
      days: json['days'],
      medicationQuantity: json['medicationQuantity'],
      amount: json['amount'].toDouble(),
    );
  }
}
