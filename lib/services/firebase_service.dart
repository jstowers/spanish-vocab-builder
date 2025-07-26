import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/vocab_word.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'spanish-english-pairs';

  /// addDocument takes a VocabWord object and adds it as a new 
  /// document in the Firestore database collection.
  Future<void> addDocument(VocabWord word) async {
    print('FirebaseService: start addDocument for ${word.spanish} -> ${word.english}');

    try {
      // create timestamp
      final now = DateTime.now();
      final timestamp = _formatTimestamp(now);
      
      // create document data object
      final documentData = {
        'spanish': word.spanish,
        'english': word.english,
        'partOfSpeech': word.partOfSpeech,
        'source': 'app',
        'timestamp': timestamp,
        'notes': word.notes,
      };

      // add the document and get the DocumentReference ID
      final docRef = await _firestore.collection(_collection).add(documentData);
      print('Document added successfully with ID: ${docRef.id}');

      if (docRef.id.isEmpty) {
        throw Exception('Failed to add word: document reference ID is empty.');
      }
    } catch (e) {
      print('FirebaseService: ERROR trying to add document: $e');
      print('Error type: ${e.runtimeType}');
      if (e is FirebaseException) {
        print('FirebaseException code: ${e.code}');
        print('FirebaseException message: ${e.message}');
      }
      throw Exception('Failed to add word $word.spanish -> $word.english.');
    }
  }

  /// updateVocabWord takes a VocabWord object and updates the corresponding
  /// document in the database.
  Future<void> updateVocabWord(VocabWord word) async {
    try {
      await _firestore.collection(_collection).doc(word.id).update({
        'spanish': word.spanish,
        'english': word.english,
        'partOfSpeech': word.partOfSpeech,
        'notes': word.notes,
      });
    } catch (e) {
      throw Exception('Failed to update word: $e');
    }
  }

  /// getVocabWords returns a list of all vocabulary words 
  /// sorted alphabetically in Spanish.
  Stream<List<VocabWord>> getVocabWords() {
    final wordPairsCollection = _firestore.collection('spanish-english-pairs');

    return wordPairsCollection
        .orderBy('spanish')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return VocabWord.fromMap(doc.id, doc.data());
      }).toList();
    });
  }

  /// deleteVocabWord takes a string ID and deletes the corresponding
  /// document in the database.
  Future<void> deleteVocabWord(String id) async {
    final wordPairsCollection = _firestore.collection('spanish-english-pairs');
    try {
      await wordPairsCollection.doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete word: $e');
    }
  }

  /// _formatTimestamp formats a DateTime to a timestamp string.
  /// 
  /// It uses the user's local time zone and returns a timestamp 
  /// in the format:
  /// 
  ///     "July 19, 2025 at 12:01:59 AM UTC-5"
  /// 
  String _formatTimestamp(DateTime dateTime) {
    // Use local timezone
    final localTime = dateTime.toLocal();
    
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    
    final month = months[localTime.month - 1];
    final day = localTime.day;
    final year = localTime.year;
    final hour = localTime.hour;
    final minute = localTime.minute.toString().padLeft(2, '0');
    final second = localTime.second.toString().padLeft(2, '0');
    final ampm = hour >= 12 ? 'PM' : 'AM';
    final hour12 = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    
    // Get timezone offset
    final offset = localTime.timeZoneOffset;
    final offsetHours = offset.inHours;
    final offsetString = offsetHours >= 0 ? '+$offsetHours' : '$offsetHours';
    
    return '$month $day, $year at $hour12:$minute:$second $ampm UTC$offsetString';
  }
} 