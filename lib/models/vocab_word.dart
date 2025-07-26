class VocabWord {
  final String id;
  final String spanish;
  final String english;
  final String partOfSpeech;

  VocabWord({
    required this.id,
    required this.spanish,
    required this.english,
    required this.partOfSpeech,
  });

  Map<String, dynamic> toMap() {
    return {
      'spanish': spanish,
      'english': english,
      'partOfSpeech': partOfSpeech,
    };
  }

  factory VocabWord.fromMap(String id, Map<String, dynamic> map) {
    return VocabWord(
      id: id,
      spanish: map['spanish'] ?? '',
      english: map['english'] ?? '',
      partOfSpeech: map['partOfSpeech'] ?? '',
    );
  }
}

class PartOfSpeech {
  static const List<String> options = [
    'Noun',
    'Verb',
    'Adjective',
    'Preposition',
    'Phrase',
  ];
} 