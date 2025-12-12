import 'dart:convert';

int? _toInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

bool _toBool(dynamic value) {
  if (value == null) return false;
  if (value is bool) return value;
  if (value is int) return value != 0;
  if (value is String) {
    final lower = value.toLowerCase();
    return lower == 'true' || lower == '1' || lower == 'y' || lower == 'yes';
  }
  return false;
}

class Listing {
  final String mlsNumber;
  final String? propertyRt;
  final int? cmnKey;
  final String fullAddress;
  final bool displayAddress;
  final int? listPrice;
  final int? beds;
  final int? bathsTotal;
  final int? sqft;
  final String? status;
  final String? propertyType;
  final String? remarks;
  final int? photoCount;
  final List<String> pictures;
  final String? listAgentName;
  final String? listAgentOffice;

  Listing({
    required this.mlsNumber,
    required this.fullAddress,
    required this.displayAddress,
    required this.pictures,
    this.propertyRt,
    this.cmnKey,
    this.listPrice,
    this.beds,
    this.bathsTotal,
    this.sqft,
    this.status,
    this.propertyType,
    this.remarks,
    this.photoCount,
    this.listAgentName,
    this.listAgentOffice,
  });

  factory Listing.fromJson(Map<String, dynamic> json) {
    return Listing(
      mlsNumber: json['IDCMLSNUMBER'] as String? ?? '',
      propertyRt: json['PROPERTYRT'] as String?,
      cmnKey: _toInt(json['CMNCMNKEY']),
      fullAddress: json['IDCFULLADDRESS'] as String? ?? '',
      displayAddress: _toBool(json['IDCDISPLAYADDRESS']),
      listPrice: _toInt(json['IDCLISTPRICE']),
      beds: _toInt(json['BEDS']),
      bathsTotal: _toInt(json['BATHSTOTAL']),
      sqft: _toInt(json['SQFT']),
      status: json['IDCSTATUS'] as String?,
      propertyType: json['IDCPROPERTYTYPE'] as String?,
      remarks: json['IDCREMARKS'] as String?,
      photoCount: _toInt(json['MLSPHOTOCOUNT']),
      pictures: (json['PICTURE'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      listAgentName: json['LISTAGENTNAME'] as String?,
      listAgentOffice: json['LISTAGENTOFFICE'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'IDCMLSNUMBER': mlsNumber,
      'PROPERTYRT': propertyRt,
      'CMNCMNKEY': cmnKey,
      'IDCFULLADDRESS': fullAddress,
      'IDCDISPLAYADDRESS': displayAddress,
      'IDCLISTPRICE': listPrice,
      'BEDS': beds,
      'BATHSTOTAL': bathsTotal,
      'SQFT': sqft,
      'IDCSTATUS': status,
      'IDCPROPERTYTYPE': propertyType,
      'IDCREMARKS': remarks,
      'MLSPHOTOCOUNT': photoCount,
      'PICTURE': pictures,
      'LISTAGENTNAME': listAgentName,
      'LISTAGENTOFFICE': listAgentOffice,
    };
  }

  static List<Listing> listFromJsonString(String jsonString) {
    final decoded = json.decode(jsonString) as Map<String, dynamic>;
    final data = decoded['data'] as List<dynamic>? ?? [];
    return data
        .map((e) => Listing.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}