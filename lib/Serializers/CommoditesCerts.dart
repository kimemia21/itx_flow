class CommCert {
  final int commodityId;
  final bool certRequired;
  final int linkedCommid;
  final int authorityId;
  final String authorityName;
  final int certificateTtl;
  final double certificateFee;
  final String certificateTtlUnits;

  // Constructor
  CommCert({
    required this.commodityId,
    required this.certRequired,
    required this.linkedCommid,
    required this.authorityId,
    required this.authorityName,
    required this.certificateTtl,
    required this.certificateFee,
    required this.certificateTtlUnits,
  });

  // Factory method to create a CommCert from a JSON object

  factory CommCert.fromJson(Map<String, dynamic> json) {
    final listKeys = [
      'commodity_id',
      'cert_required',
      'linked_commid',
      'authority_id',
      'authority_name',
      'certificate_ttl',
      'certificate_fee',
      'certificate_ttl_units'
    ];
    for (var key in listKeys) {
      if (!json.containsKey(key) || json[key] == null) {
        print("$key is null in the CommCert function");
      }
    }

    return CommCert(
      commodityId: json['commodity_id'],
      certRequired: json['cert_required'] == "1", // Convert string to boolean
      linkedCommid: json['linked_commid'],
      authorityId: json['authority_id'],
      authorityName: json['authority_name'],
      certificateTtl: json['certificate_ttl']?? 1,
      certificateFee:
          json['certificate_fee']??0.0, // Ensure fee is a double
      certificateTtlUnits: json['certificate_ttl_units']??"null",
    );
  }

  // Method to convert the CommCert instance back to JSON
}
