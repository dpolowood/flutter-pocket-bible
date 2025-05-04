class Books {
    late int bookNumber;
    late String bookName;

    Books({required this.bookNumber, required this.bookName});

    Books.fromMapObject(Map<String, dynamic> map) {
        this.bookNumber = map['book_number'];
        this.bookName = map['long_name'];
    }
}

class Verses {
    late int verseBookNumber;
    late int chapter;
    late int verseNumber;
    late String text;

    Verses({required this.verseBookNumber, required this.chapter, required this.text, required this.verseNumber});

    Verses.fromMapObject(Map<String, dynamic> map) {
        this.verseBookNumber = map['book_number'] ?? 0;
        this.chapter = map['chapter'] ?? 0;
        this.verseNumber = map['verse'] ?? 0;
        this.text = map['text'] ?? '';
    }
}
