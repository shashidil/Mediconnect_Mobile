class OrderQuantityByMonthDTO {
  final int year;
  final int month;
  final int orderCount;

  OrderQuantityByMonthDTO({required this.year, required this.month, required this.orderCount});

  factory OrderQuantityByMonthDTO.fromJson(Map<String, dynamic> json) {
    return OrderQuantityByMonthDTO(
      year: json['year'],
      month: json['month'],
      orderCount: json['orderCount'],
    );
  }
}