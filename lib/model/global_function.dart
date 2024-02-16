class GlobalFunction {
  String truncateText(String text, int maxWords) {
    List<String> words = text.split(' ');

    if (words.length <= maxWords) {
      return text;
    }

    List<String> truncatedWords = words.sublist(0, maxWords);
    return '${truncatedWords.join(' ')}...';
  }
}