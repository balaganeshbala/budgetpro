class IncomeModel {
  final int id;
  final String name;
  final double amount;

  IncomeModel({required this.id, required this.name, required this.amount});

  factory IncomeModel.fromJson(Map<String, dynamic> json) {
    return IncomeModel(
      id: json['id'],
      name: json['name'],
      amount: json['amount'].toDouble(),
    );
  }
}
