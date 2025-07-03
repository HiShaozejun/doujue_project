class IMEntity {
/*
{
  "uid": "C_9500",
  "chatid": "C_9500",
  "signature": "eJyr1jwxVg__",
  "chatid_c": "C_9500",
  "signature_c": "eJyrVg1jwxVg__",
  "chatid_b": "B_9500",
  "signature_b": "eJosos0MzcMDwoxMMvx68gRt84zDIrzCkqzNPJ16kwL9JWqRYAyw0wqg__"
} 
*/

  String? uid;
  String? chatid;
  String? signature;
  String? chatidC;
  String? signatureC;
  String? chatidB;
  String? signatureB;

  IMEntity({
    this.uid,
    this.chatid,
    this.signature,
    this.chatidC,
    this.signatureC,
    this.chatidB,
    this.signatureB,
  });

  IMEntity.fromJson(Map<String, dynamic> json) {
    uid = json['uid']?.toString();
    chatid = json['chatid']?.toString();
    signature = json['signature']?.toString();
    chatidC = json['chatid_c']?.toString();
    signatureC = json['signature_c']?.toString();
    chatidB = json['chatid_b']?.toString();
    signatureB = json['signature_b']?.toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['uid'] = uid;
    data['chatid'] = chatid;
    data['signature'] = signature;
    data['chatid_c'] = chatidC;
    data['signature_c'] = signatureC;
    data['chatid_b'] = chatidB;
    data['signature_b'] = signatureB;
    return data;
  }
}
