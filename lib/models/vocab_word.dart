class VocabWord {
  final String id;
  final String spanish;
  final String english;
  final String partOfSpeech;
  final String? dateTime;
  final String? notes;

  VocabWord({
    required this.id,
    required this.spanish,
    required this.english,
    required this.partOfSpeech,
    this.dateTime,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'spanish': spanish,
      'english': english,
      'partOfSpeech': partOfSpeech,
      'dateTime': dateTime,
      'notes': notes,
    };
  }

  factory VocabWord.fromMap(String id, Map<String, dynamic> map) {
    return VocabWord(
      id: id,
      spanish: map['spanish'] ?? '',
      english: map['english'] ?? '',
      partOfSpeech: map['partOfSpeech'] ?? '',
      dateTime: map['dateTime'] ?? map['timestamp'], // Support both old and new field names
      notes: map['notes'],
    );
  }

  VocabWord copyWith({
    String? id,
    String? spanish,
    String? english,
    String? partOfSpeech,
    String? dateTime,
    String? notes,
  }) {
    return VocabWord(
      id: id ?? this.id,
      spanish: spanish ?? this.spanish,
      english: english ?? this.english,
      partOfSpeech: partOfSpeech ?? this.partOfSpeech,
      dateTime: dateTime ?? this.dateTime,
      notes: notes ?? this.notes,
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