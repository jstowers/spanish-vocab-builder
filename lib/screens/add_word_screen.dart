import 'package:flutter/material.dart';
import '../models/vocab_word.dart';
import '../services/firebase_service.dart';
import 'show_words_screen.dart';

class AddWordScreen extends StatefulWidget {
  const AddWordScreen({super.key});

  @override
  State<AddWordScreen> createState() => _AddWordScreenState();
}

class _AddWordScreenState extends State<AddWordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _spanishController = TextEditingController();
  final _englishController = TextEditingController();
  String _selectedPartOfSpeech = PartOfSpeech.options[0];
  final _firebaseService = FirebaseService();
  bool _isLoading = false;

  @override
  void dispose() {
    _spanishController.dispose();
    _englishController.dispose();
    super.dispose();
  }

  Future<void> _saveWord() async {
    print("INSIDE _saveWord()");
    
    if (!_formKey.currentState!.validate()) {
      print("Form validation failed.");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final word = VocabWord(
        id: '', // Will be set by Firebase
        spanish: _spanishController.text.trim(),
        english: _englishController.text.trim(),
        partOfSpeech: _selectedPartOfSpeech,
      );

      await _firebaseService.addDocument(word);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Word saved successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Navigate to show words screen with the new word highlighted
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => ShowWordsScreen(
              highlightWord: word.spanish,
            ),
          ),
          (route) => false, // Remove all previous routes
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving word: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Word'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              
              // Three fields in a column
              // Spanish word field
              TextFormField(
                controller: _spanishController,
                decoration: const InputDecoration(
                  labelText: 'Spanish',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.language),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter a Spanish word or phrase';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // English definition field
              TextFormField(
                controller: _englishController,
                decoration: const InputDecoration(
                  labelText: 'English',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.translate),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter an English word or phrase';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // Part of speech dropdown
              DropdownButtonFormField<String>(
                value: _selectedPartOfSpeech,
                decoration: const InputDecoration(
                  labelText: 'Part of Speech',
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
                  setState(() {
                    _selectedPartOfSpeech = newValue!;
                  });
                },
              ),
              
              const SizedBox(height: 32),
              
              // Save button
              SizedBox(
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _saveWord,
                  icon: _isLoading 
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save),
                  label: Text(
                    _isLoading ? 'Saving...' : 'Save Word',
                    style: const TextStyle(fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 