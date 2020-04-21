import 'dart:convert';

class GNCharge {
  int code;
  int chargeId;
  int total;
  String status;
  String createdAt;

  GNCharge();

  String toJSON() {
    return jsonEncode({"charge_id": chargeId, "total": total, "status": status, "created_at": createdAt});
  }

  GNCharge.fromMap(Map<String, dynamic> map) {
    assert(map['code'] == 200);
    code = map['code'];
    Map<String, dynamic> data = map['data'];
    chargeId = data['charge_id'];
    total = data['total'];
    status = data['status'];
    createdAt = data['created_at'];
  }
}
