class CommoditiesCert {
  int commodityId;
  String certRequired;
  int? linkedCommid;
  int? authorityId;
  String? authorityName;
  int? certificateTtl;
  double? certificateFee;
  String? certificateTtlUnits;
  int? proofOfPaymentRequired;
  String? certificateName;
  int? certificateId;

  CommoditiesCert({
    required this.commodityId,
    required this.certRequired,
    this.linkedCommid,
    this.authorityId,
    this.authorityName,
    this.certificateTtl,
    this.certificateFee,
    this.certificateTtlUnits,
    this.proofOfPaymentRequired,
    this.certificateName,
    this.certificateId,
  });

  // Method to create an instance from a JSON object
  factory CommoditiesCert.fromJson(Map<String, dynamic> json) {
    return CommoditiesCert(
      commodityId: json['commodity_id'],
      certRequired: json['cert_required'],
      linkedCommid: json['linked_commid'],
      authorityId: json['authority_id'],
      authorityName: json['authority_name'],
      certificateTtl: json['certificate_ttl'],
      certificateFee: json['certificate_fee']?.toDouble(),
      certificateTtlUnits: json['certificate_ttl_units'],
      proofOfPaymentRequired: json['proof_of_payment_required'],
      certificateName: json['certificate_name'],
      certificateId: json['certificate_id'],
    );
  }
}
