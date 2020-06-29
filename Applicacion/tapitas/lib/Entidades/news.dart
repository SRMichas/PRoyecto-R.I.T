class News{

  final String urlImage,headLine,subHeadLine,urlArticle;

  News({this.headLine,this.subHeadLine,this.urlArticle,this.urlImage});

  factory News.fromJson(Map<String, dynamic> parsedJson){
    return News(
      urlImage: parsedJson["imageUrl"].toString(),
      headLine: parsedJson["headLine"].toString(),
      subHeadLine: parsedJson["subHeadLine"].toString(),
      urlArticle: parsedJson["articleUrl"].toString(),
    );
  }
}