class ContractSummary {
  final int id;
  final String contractType;
  final int canBid;
  final String? contractTypeDescription;
  final String? contractTypeIcon;
  final int count;

  ContractSummary( {
    required this.count,
    required this.id,
    required this.contractType,
    required this.canBid,
    this.contractTypeDescription,
    this.contractTypeIcon,
  });

  factory ContractSummary.fromJson(Map<String, dynamic> json) {
    List params = [
      "id",
      "contract_type",
      "can_bid",
      "contract_type_description",
      "contract_type_icon",
      "contract_count"
    ];
    for (var element in params) {
      if (!json.containsKey(element) || json[element] == null) {
        print("$element is null");
      }
    }
    
    return ContractSummary(
      id: json['id'],
      contractType: json['contract_type'],
      canBid: json['can_bid'],
      contractTypeDescription: json['contract_type_description'] ?? "null",
      contractTypeIcon: json['contract_type_icon'] ?? "null",
      count: json["contract_count"]
    );
  }
}
