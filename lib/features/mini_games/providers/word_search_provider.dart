import 'dart:math';
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/data/word_search_data.dart';

class WordPosition {
  final int row;
  final int col;
  const WordPosition(this.row, this.col);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WordPosition &&
          runtimeType == other.runtimeType &&
          row == other.row &&
          col == other.col;

  @override
  int get hashCode => row.hashCode ^ col.hashCode;
}

class PlacedWord {
  final String word;
  final List<WordPosition> positions;
  PlacedWord(this.word, this.positions);
}

class WordSearchGameState {
  final bool isPlaying;
  final bool isGameOver;
  final int score;
  final int timeLeft;
  final WordSearchCategory? currentCategory;
  final List<List<String>> grid;
  final List<PlacedWord> placedWords;
  final Set<String> foundWords;
  final List<WordPosition> currentSelection;

  const WordSearchGameState({
    this.isPlaying = false,
    this.isGameOver = false,
    this.score = 0,
    this.timeLeft = 180,
    this.currentCategory,
    this.grid = const [],
    this.placedWords = const [],
    this.foundWords = const {},
    this.currentSelection = const [],
  });

  WordSearchGameState copyWith({
    bool? isPlaying,
    bool? isGameOver,
    int? score,
    int? timeLeft,
    WordSearchCategory? currentCategory,
    List<List<String>>? grid,
    List<PlacedWord>? placedWords,
    Set<String>? foundWords,
    List<WordPosition>? currentSelection,
  }) {
    return WordSearchGameState(
      isPlaying: isPlaying ?? this.isPlaying,
      isGameOver: isGameOver ?? this.isGameOver,
      score: score ?? this.score,
      timeLeft: timeLeft ?? this.timeLeft,
      currentCategory: currentCategory ?? this.currentCategory,
      grid: grid ?? this.grid,
      placedWords: placedWords ?? this.placedWords,
      foundWords: foundWords ?? this.foundWords,
      currentSelection: currentSelection ?? this.currentSelection,
    );
  }
}

class WordSearchGameNotifier extends StateNotifier<WordSearchGameState> {
  Timer? _timer;
  final int _gridSize = 12;
  final Random _random = Random();
  final String _alphabet = "ABCÇDEFGĞHIİJKLMNOÖPRSŞTUÜVYZ";

  static const List<String> _restrictedWords = [
    'AMK', 'AQ', 'MK', 'PİÇ', 'PUŞT', 'İBNE', 'GÖT', 'SİK', 'BOK', 'LAN', 'SEKS',
    'KMA', 'QA', 'KM', 'ÇİP', 'TŞUP', 'ENBİ', 'TÖG', 'KİS', 'KOB', 'NAL', 'SKES',
    'SİKTİR', 'RİTKİS'
  ];

  WordSearchGameNotifier() : super(const WordSearchGameState());

  void startGame() {
    _timer?.cancel();
    
    // Pick a category different from the current one to ensure a new puzzle on restart
    WordSearchCategory category;
    if (state.currentCategory != null && WordSearchData.categories.length > 1) {
      final otherCategories = WordSearchData.categories
          .where((c) => c.id != state.currentCategory!.id)
          .toList();
      category = otherCategories[_random.nextInt(otherCategories.length)];
    } else {
      category = WordSearchData.categories[_random.nextInt(WordSearchData.categories.length)];
    }
    
    final gridResult = _generateGrid(category.words);

    state = WordSearchGameState(
      isPlaying: true,
      isGameOver: false,
      score: 0,
      timeLeft: 180,
      currentCategory: category,
      grid: gridResult.grid,
      placedWords: gridResult.placedWords,
      foundWords: {},
      currentSelection: [],
    );

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.timeLeft > 0) {
        state = state.copyWith(timeLeft: state.timeLeft - 1);
      } else {
        endGame();
      }
    });
  }

  void endGame() {
    _timer?.cancel();
    state = state.copyWith(isPlaying: false, isGameOver: true);
  }

  void updateSelection(List<WordPosition> selection) {
    if (!state.isPlaying || state.isGameOver) return;
    state = state.copyWith(currentSelection: selection);
  }

  void submitSelection(List<WordPosition> selection) {
    if (!state.isPlaying || state.isGameOver) return;
    
    String selectedWordForward = "";
    String selectedWordBackward = "";
    for (var pos in selection) {
      selectedWordForward += state.grid[pos.row][pos.col];
    }
    selectedWordBackward = selectedWordForward.split('').reversed.join('');

    bool foundNew = false;
    String? foundWord;

    for (var placed in state.placedWords) {
      if (state.foundWords.contains(placed.word)) continue;
      
      bool posMatchForward = _positionsMatch(selection, placed.positions);
      bool posMatchBackward = _positionsMatch(selection.reversed.toList(), placed.positions);

      if (posMatchForward || posMatchBackward) {
        foundNew = true;
        foundWord = placed.word;
        break;
      }
    }

    if (foundNew && foundWord != null) {
      final newFound = Set<String>.from(state.foundWords)..add(foundWord);
      int points = foundWord.length * 10;
      
      state = state.copyWith(
        foundWords: newFound,
        score: state.score + points,
        currentSelection: [],
      );

      if (newFound.length == state.placedWords.length) {
        endGame();
      }
    } else {
      state = state.copyWith(currentSelection: []);
    }
  }
  
  bool _positionsMatch(List<WordPosition> a, List<WordPosition> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  bool _checkForRestrictedWords(List<List<String>> currentGrid, int r, int c, String candidate) {
    String original = currentGrid[r][c];
    currentGrid[r][c] = candidate;

    // Check Row
    String rowStr = "";
    for (int i = 0; i < _gridSize; i++) {
      rowStr += currentGrid[r][i] == '' ? ' ' : currentGrid[r][i];
    }

    // Check Column
    String colStr = "";
    for (int i = 0; i < _gridSize; i++) {
      colStr += currentGrid[i][c] == '' ? ' ' : currentGrid[i][c];
    }

    // Check Diagonal 1 (down-right)
    String diag1Str = "";
    int offset1 = min(r, c);
    int startR1 = r - offset1;
    int startC1 = c - offset1;
    for (int i = 0; startR1 + i < _gridSize && startC1 + i < _gridSize; i++) {
      String cell = currentGrid[startR1 + i][startC1 + i];
      diag1Str += cell == '' ? ' ' : cell;
    }

    // Check Diagonal 2 (up-right)
    String diag2Str = "";
    int offset2 = min(_gridSize - 1 - r, c);
    int startR2 = r + offset2;
    int startC2 = c - offset2;
    for (int i = 0; startR2 - i >= 0 && startC2 + i < _gridSize; i++) {
      String cell = currentGrid[startR2 - i][startC2 + i];
      diag2Str += cell == '' ? ' ' : cell;
    }

    currentGrid[r][c] = original;

    final cleanedRow = rowStr.replaceAll(' ', '');
    final cleanedCol = colStr.replaceAll(' ', '');
    final cleanedDiag1 = diag1Str.replaceAll(' ', '');
    final cleanedDiag2 = diag2Str.replaceAll(' ', '');

    for (var word in _restrictedWords) {
      if (cleanedRow.contains(word) ||
          cleanedCol.contains(word) ||
          cleanedDiag1.contains(word) ||
          cleanedDiag2.contains(word)) {
        return false;
      }
    }

    return true;
  }

  _GridGenerationResult _generateGrid(List<String> wordsToPlace) {
    List<List<String>> grid = List.generate(_gridSize, (_) => List.filled(_gridSize, ''));
    List<PlacedWord> placedWords = [];

    final directions = [
      [0, 1],   // Right
      [1, 0],   // Down
      [1, 1],   // Diagonal Down-Right
      [-1, 1],  // Diagonal Up-Right
    ];

    for (var word in wordsToPlace) {
      bool placed = false;
      int attempts = 0;

      while (!placed && attempts < 100) {
        attempts++;
        final dir = directions[_random.nextInt(directions.length)];
        final dRow = dir[0];
        final dCol = dir[1];

        int startRow = _random.nextInt(_gridSize);
        int startCol = _random.nextInt(_gridSize);

        int endRow = startRow + (word.length - 1) * dRow;
        int endCol = startCol + (word.length - 1) * dCol;

        if (endRow >= 0 && endRow < _gridSize && endCol >= 0 && endCol < _gridSize) {
          bool canPlace = true;
          for (int i = 0; i < word.length; i++) {
            int r = startRow + i * dRow;
            int c = startCol + i * dCol;
            if (grid[r][c] != '' && grid[r][c] != word[i]) {
              canPlace = false;
              break;
            }
          }

          if (canPlace) {
            List<WordPosition> positions = [];
            for (int i = 0; i < word.length; i++) {
              int r = startRow + i * dRow;
              int c = startCol + i * dCol;
              grid[r][c] = word[i];
              positions.add(WordPosition(r, c));
            }
            placedWords.add(PlacedWord(word, positions));
            placed = true;
          }
        }
      }
    }

    for (int r = 0; r < _gridSize; r++) {
      for (int c = 0; c < _gridSize; c++) {
        if (grid[r][c] == '') {
          List<String> shuffledAlphabet = _alphabet.split('')..shuffle(_random);
          String selectedLetter = '';
          for (var letter in shuffledAlphabet) {
            if (_checkForRestrictedWords(grid, r, c, letter)) {
              selectedLetter = letter;
              break;
            }
          }
          grid[r][c] = selectedLetter.isNotEmpty ? selectedLetter : 'A';
        }
      }
    }

    return _GridGenerationResult(grid, placedWords);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

class _GridGenerationResult {
  final List<List<String>> grid;
  final List<PlacedWord> placedWords;
  _GridGenerationResult(this.grid, this.placedWords);
}

final wordSearchProvider = StateNotifierProvider<WordSearchGameNotifier, WordSearchGameState>((ref) {
  return WordSearchGameNotifier();
});
