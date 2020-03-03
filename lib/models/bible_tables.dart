class Books {
  int bookNumber;
  String bookName;

  Books({this.bookNumber, this.bookName});

  Books.fromMapObject(Map<String, dynamic> map) {
    this.bookNumber = map['book_number'];
    this.bookName = map['long_name'];
  }
}

class Verses {
  int verseBookNumber;
  int chapter;
  int verseNumber;
  String text;

  Verses({this.verseBookNumber, this.chapter, this.text, this.verseNumber});

  Verses.fromMapObject(Map<String, dynamic> map) {
    this.verseBookNumber = map['book_number'];
    this.chapter = map['chapter'];
    this.verseNumber = map['verse'];
    this.text = map['text'];
  }
}
