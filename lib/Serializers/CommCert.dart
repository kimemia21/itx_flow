class CommoditiesCert {
  int commodityId;
  String certRequired;
  int? linkedCommid;
  String? contactDepartmentName;
  int? certificateTtl;
  double? certificateFee;
  String? certificateTtlUnits;

  CommoditiesCert({
    required this.commodityId,
    required this.certRequired,
    this.linkedCommid,
    this.contactDepartmentName,
    this.certificateTtl,
    this.certificateFee,
    this.certificateTtlUnits,
  });

  // Method to create an instance from a JSON object
  factory CommoditiesCert.fromJson(Map<String, dynamic> json) {
  List<String> requiredKeys = [
    'commodity_id',
    'cert_required',
    'linked_commid',
    'contact_department_name',
    'certificate_ttl',
    'certificate_fee',
    'certificate_ttl_units',
  ];
  


    return CommoditiesCert(
      commodityId: json['commodity_id'],
      certRequired: json['cert_required'],
      linkedCommid: json['linked_commid'],
      contactDepartmentName: json['contact_department_name'],
      certificateTtl: json['certificate_ttl'],
      certificateFee: json['certificate_fee']?.toDouble(),
      certificateTtlUnits: json['certificate_ttl_units'],
    );
  }



}
