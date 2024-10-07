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
  factory CommoditiesCert.fromJson(Map json) { 
    return CommoditiesCert( 
      commodityId: json['commodity_id'] ?? 0,  // Default to 0 if null
      certRequired: json['cert_required'] ?? 'Not Required',  // Default to 'Not Required' if null
      linkedCommid: json['linked_commid'] ?? 0,  // Default to 0 if null
      authorityId: json['authority_id'] ?? 0,  // Default to 0 if null
      authorityName: json['authority_name'] ?? 'Unknown Authority',  // Default to 'Unknown Authority' if null
      certificateTtl: json['certificate_ttl'] ?? 0,  // Default to 0 if null
      certificateFee: json['certificate_fee'] != null ? json['certificate_fee'].toDouble() : 0.0,  // Default to 0.0 if null
      certificateTtlUnits: json['certificate_ttl_units'] ?? 'Unknown Unit',  // Default to 'Unknown Unit' if null
      proofOfPaymentRequired: json['proof_of_payment_required'] ?? 0,  // Default to 0 if null
      certificateName: json['certificate_name'] ?? 'Unknown Certificate',  // Default to 'Unknown Certificate' if null
      certificateId: json['certificate_id'] ?? 0,  // Default to 0 if null
    ); 
  } 
}
