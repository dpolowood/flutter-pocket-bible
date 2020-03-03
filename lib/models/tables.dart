class Libros {
  int libroID;
  String libro;
  // int totalPalabras;

  Libros({this.libroID, this.libro /*,this.totalPalabras*/});

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (libroID != null) {
      map['LibroID'] = libroID;
    }
    map['Libro'] = libro;
    // map['TotalPalabras'] = totalPalabras;

    return map;
  }

  Libros.fromMapObject(Map<String, dynamic> map) {
    this.libroID = map['LibroID'];
    this.libro = map['Libro'];
    // this.totalPalabras = map['TotalPalabras'];
  }
}

class Versiculos {
  int libroIDtwo;
  int capitulo;
  int versiculo;
  String texto;

  Versiculos({this.libroIDtwo, this.capitulo, this.versiculo, this.texto});

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (libroIDtwo != null) {
      map['libroid'] = libroIDtwo;
    }
    map['capitulo'] = capitulo;
    map['versiculo'] = versiculo;
    map['texto'] = texto;

    return map;
  }

  Versiculos.fromMapObject(Map<String, dynamic> map) {
    this.libroIDtwo = map['libroid'];
    this.capitulo = map['capitulo'];
    this.versiculo = map['versiculo'];
    this.texto = map['texto'];
  }
}
