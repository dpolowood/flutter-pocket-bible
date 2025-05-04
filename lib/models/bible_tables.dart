class Book {
    final int id;
    final String title;

    Book({
        required this.id,
        required this.title
    });

    factory Book.fromMap(Map<String, dynamic> map) {
        return Book(
            id: map['book_number'],
            title: map['long_name'],
        );
    }

    Map<String, dynamic> toMap() {
        return {
            'book_number': id,
            'long_name': title,
        };
    }
}

class Verse {
    late int verseBookNumber;
    late int chapter;
    late int verseNumber;
    late String text;

    Verse({
        required this.verseBookNumber,
        required this.chapter,
        required this.text,
        required this.verseNumber
    });

    Verse.fromMap(Map<String, dynamic> map) {
        this.verseBookNumber = map['book_number'] ?? 0;
        this.chapter = map['chapter'] ?? 0;
        this.verseNumber = map['verse'] ?? 0;
        this.text = map['text'] ?? '';
    }
}
