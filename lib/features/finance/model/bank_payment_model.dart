import 'package:get/get.dart';

class BankPaymentModel {
  String? link;
  String? type;
  int? srl;
  String? docdate;
  String? party;
  String? narr;
  double? amount;
  bool? authorise;
  RxBool? isPdfLoading;

  BankPaymentModel({
    this.link,
    this.type,
    this.srl,
    this.docdate,
    this.party,
    this.narr,
    this.amount,
    this.authorise,
    this.isPdfLoading,
  });

  factory BankPaymentModel.fromJson(Map<String, dynamic> json) {
    return BankPaymentModel(
      link: json['link'] as String?,
      type: json['type'] as String?,
      srl: json['srl'] as int?,
      docdate: json['docdate'] as String?,
      party: json['party'] as String?,
      narr: json['narr'] as String?,
      amount: (json['amount'] as num?)?.toDouble(),
      authorise: json['authorise'] as bool?,
      isPdfLoading: false.obs,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'link': link,
      'type': type,
      'srl': srl,
      'docdate': docdate,
      'party': party,
      'narr': narr,
      'amount': amount,
      'authorise': authorise,
    };
  }

  static List<BankPaymentModel> fromDecodedJsonList(List<dynamic> jsonList) {
    return jsonList.map((item) => BankPaymentModel.fromJson(item)).toList();
  }
}
