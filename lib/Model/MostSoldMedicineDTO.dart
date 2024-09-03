class MostSoldMedicineDTO {
  final String medicationName;
  final int totalQuantity;

  MostSoldMedicineDTO({required this.medicationName, required this.totalQuantity});

  factory MostSoldMedicineDTO.fromJson(Map<String, dynamic> json) {
    return MostSoldMedicineDTO(
      medicationName: json['medicationName'],
      totalQuantity: json['totalQuantity'],
    );
  }
}