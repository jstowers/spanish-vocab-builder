import 'package:flutter/material.dart';
import '../models/vocab_word.dart';
import '../services/firebase_service.dart';
import 'word_detail_screen.dart';

class ShowWordsScreen extends StatefulWidget {
  final String? highlightWord;

  const ShowWordsScreen({
    super.key,
    this.highlightWord,
  });

  @override
  State<ShowWordsScreen> createState() => _ShowWordsScreenState();
}

class _ShowWordsScreenState extends State<ShowWordsScreen> with TickerProviderStateMixin {
  String? _highlightedWord;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _highlightedWord = widget.highlightWord;
    
    // Setup animation for highlighting
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    
    // Clear the highlight after 3 seconds
    if (_highlightedWord != null) {
      _animationController.forward();
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          _animationController.reverse().then((_) {
            if (mounted) {
              setState(() {
                _highlightedWord = null;
              });
            }
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final firebaseService = FirebaseService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vocabulary Words'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: StreamBuilder<List<VocabWord>>(
        stream: firebaseService.getVocabWords(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading words: ${snapshot.error}',
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          final words = snapshot.data ?? [];

          if (words.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.library_books,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No vocabulary words yet',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Add your first word to get started!',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(
                  label: Text(
                    'Spanish',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'English',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Part of Speech',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
              rows: words.map((word) {
                final isHighlighted = _highlightedWord == word.spanish;
                
                return DataRow(
                  color: isHighlighted 
                    ? WidgetStateProperty.all(
                        Colors.yellow.withValues(alpha: 0.3 * _animation.value)
                      )
                    : null,
                  cells: [
                    DataCell(
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WordDetailScreen(word: word),
                            ),
                          );
                        },
                        child: Text(
                          word.spanish,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: isHighlighted ? Colors.orange.shade800 : null,
                          ),
                        ),
                      ),
                    ),
                    DataCell(
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WordDetailScreen(word: word),
                            ),
                          );
                        },
                        child: Text(
                          word.english,
                          style: TextStyle(
                            color: isHighlighted ? Colors.orange.shade800 : null,
                          ),
                        ),
                      ),
                    ),
                    DataCell(
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WordDetailScreen(word: word),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: isHighlighted 
                              ? Colors.orange.shade600 
                              : _getPartOfSpeechColor(word.partOfSpeech),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            word.partOfSpeech,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }

  Color _getPartOfSpeechColor(String partOfSpeech) {
    switch (partOfSpeech) {
      case 'Noun':
        return Colors.blue;
      case 'Verb':
        return Colors.green;
      case 'Adjective':
        return Colors.orange;
      case 'Preposition':
        return Colors.purple;
      case 'Phrase':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }
} 