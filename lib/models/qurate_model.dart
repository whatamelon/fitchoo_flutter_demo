class Qurate{
  String qitemId = '';
  String qcode = '';
  String clickCnt = '';
  String quserName = '';
  String imgFaceFile = '';
  String imgItemFile = '';
  String itemupDate = '';
  String title = '';
  String body = '';

  Qurate(
  {
    this.qitemId,
    this.qcode,
    this.clickCnt,
    this.quserName,
    this.imgFaceFile,
    this.imgItemFile,
    this.itemupDate,
    this.title,
    this.body
  });

  factory Qurate.fromJson(Map<String, dynamic> json) {
    return Qurate(
      qitemId: json["qitemId"],
      qcode: json["qcode"],
      clickCnt: json["clickCnt"],
      quserName: json["quserName"],
      imgFaceFile: json["imgFaceFile"],
      imgItemFile: json["imgItemFile"],
      itemupDate: json["itemupDate"],
      title: json["title"],
      body: json["body"]
    );
  }
}