import 'package:flutter/material.dart';
import '../models/vocab_word.dart';
import '../services/firebase_service.dart';

class WordDetailScreen extends StatefulWidget {
  final VocabWord word;

  const WordDetailScreen({
    super.key,
    required this.word,
  });

  @override
  State<WordDetailScreen> createState() => _WordDetailScreenState();
}

class _WordDetailScreenState extends State<WordDetailScreen> {
  late TextEditingController _spanishController;
  late TextEditingController _englishController;
  late TextEditingController _notesController;
  late String _selectedPartOfSpeech;
  late VocabWord _originalWord;
  late VocabWord _currentWord;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _originalWord = widget.word;
    _currentWord = widget.word;
    
    _spanishController = TextEditingController(text: widget.word.spanish);
    _englishController = TextEditingController(text: widget.word.english);
    _notesController = TextEditingController(text: widget.word.notes ?? '');
    _selectedPartOfSpeech = widget.word.partOfSpeech;

    // Listen for changes to detect when to enable/disable update button
    _spanishController.addListener(_checkForChanges);
    _englishController.addListener(_checkForChanges);
    _notesController.addListener(_checkForChanges);
  }

  @override
  void dispose() {
    _spanishController.dispose();
    _englishController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _checkForChanges() {
    final newWord = VocabWord(
      id: _originalWord.id,
      spanish: _spanishController.text.trim(),
      english: _englishController.text.trim(),
      partOfSpeech: _selectedPartOfSpeech,
      dateTime: _originalWord.dateTime,
      notes: _notesController.text.trim(),
    );

    final hasChanges = _originalWord.spanish != newWord.spanish ||
        _originalWord.english != newWord.english ||
        _originalWord.partOfSpeech != newWord.partOfSpeech ||
        _originalWord.notes != newWord.notes;

    if (hasChanges != _hasChanges) {
      setState(() {
        _hasChanges = hasChanges;
        _currentWord = newWord;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Word Detail'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Spanish word field
            TextField(
              controller: _spanishController,
              decoration: const InputDecoration(
                labelText: 'Spanish word',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.language),
              ),
            ),
            const SizedBox(height: 16),

            // English definition field
            TextField(
              controller: _englishController,
              decoration: const InputDecoration(
                labelText: 'English definition',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.translate),
              ),
            ),
            const SizedBox(height: 16),

            // Part of speech dropdown
            DropdownButtonFormField<String>(
              value: _selectedPartOfSpeech,
              decoration: const InputDecoration(
                labelText: 'Part of speech',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.category),
              ),
              items: PartOfSpeech.options.map((String option) {
                return DropdownMenuItem<String>(
                  value: option,
                  child: Text(option),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedPartOfSpeech = newValue;
                  });
                  _checkForChanges();
                }
              },
            ),
            const SizedBox(height: 16),

            // Date and Time field (not editable)
            TextField(
              enabled: false,
              decoration: InputDecoration(
                labelText: 'Date and Time',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.access_time),
                hintText: _originalWord.dateTime ?? 'No date available',
              ),
            ),
            const SizedBox(height: 16),

            // Notes field
            TextField(
              controller: _notesController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Note or Reference',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.note),
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 32),

            // Update button (primary)
            ElevatedButton(
              onPressed: _hasChanges ? _updateWord : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Update Word',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),

            // Delete button (secondary)
            OutlinedButton(
              onPressed: _deleteWord,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Delete Word',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _updateWord() async {
    if (!_hasChanges) return;

    try {
      final firebaseService = FirebaseService();
      await firebaseService.updateVocabWord(_currentWord);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Word updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Update the original word to reflect the changes
        _originalWord = _currentWord;
        setState(() {
          _hasChanges = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating word: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _deleteWord() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Word'),
          content: Text(
            'Are you sure you want to delete "${_currentWord.spanish}"?\n\nThis action cannot be undone.',
            style: const TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _confirmDelete();
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text(
                'Delete',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _confirmDelete() async {
    try {
      final firebaseService = FirebaseService();
      await firebaseService.deleteVocabWord(_currentWord.id);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Word deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Navigate back to the words list
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting word: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
} 