import 'package:flutter/material.dart';

class HtmlParser {
  static Widget parse(String html, {TextStyle? baseStyle, double? fontSize}) {
    final style = baseStyle ?? const TextStyle(fontSize: 16, height: 1.6);
    final fs = fontSize ?? style.fontSize ?? 16;
    final children = _parseHtml(html, style, fs);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  static List<Widget> _parseHtml(String html, TextStyle base, double fs) {
    final widgets = <Widget>[];
    // Simplified HTML processing
    final cleaned = html
        .replaceAll('\r\n', '\n')
        .replaceAll('\r', '\n');

    // Split on block elements
    final blocks = _splitBlocks(cleaned);
    for (final block in blocks) {
      final widget = _parseBlock(block.trim(), base, fs);
      if (widget != null) widgets.add(widget);
    }
    return widgets;
  }

  static List<String> _splitBlocks(String html) {
    final blocks = <String>[];
    // Split on block-level tags
    final blockRegex = RegExp(
      r'<(p|h[1-6]|ul|ol|li|blockquote|br|div)[^>]*>(.*?)<\/\1>|<br\s*/?>',
      dotAll: true,
      caseSensitive: false,
    );
    int lastEnd = 0;
    for (final match in blockRegex.allMatches(html)) {
      if (match.start > lastEnd) {
        final text = html.substring(lastEnd, match.start).trim();
        if (text.isNotEmpty) blocks.add(text);
      }
      blocks.add(match.group(0) ?? '');
      lastEnd = match.end;
    }
    if (lastEnd < html.length) {
      final text = html.substring(lastEnd).trim();
      if (text.isNotEmpty) blocks.add(text);
    }
    return blocks;
  }

  static Widget? _parseBlock(String block, TextStyle base, double fs) {
    if (block.isEmpty) return null;

    // Heading h2
    final h2Match = RegExp(r'<h2[^>]*>(.*?)<\/h2>', dotAll: true, caseSensitive: false).firstMatch(block);
    if (h2Match != null) {
      return Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 8),
        child: Text(
          _stripTags(h2Match.group(1) ?? ''),
          style: base.copyWith(
            fontSize: fs + 4,
            fontWeight: FontWeight.bold,
            height: 1.3,
          ),
        ),
      );
    }

    // Heading h3
    final h3Match = RegExp(r'<h3[^>]*>(.*?)<\/h3>', dotAll: true, caseSensitive: false).firstMatch(block);
    if (h3Match != null) {
      return Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 6),
        child: Text(
          _stripTags(h3Match.group(1) ?? ''),
          style: base.copyWith(
            fontSize: fs + 2,
            fontWeight: FontWeight.bold,
            height: 1.3,
          ),
        ),
      );
    }

    // Blockquote
    final bqMatch = RegExp(r'<blockquote[^>]*>(.*?)<\/blockquote>', dotAll: true, caseSensitive: false).firstMatch(block);
    if (bqMatch != null) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: const Border(left: BorderSide(color: Color(0xFFE53935), width: 4)),
          color: const Color(0xFFE53935).withValues(alpha: 0.05),
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(8),
            bottomRight: Radius.circular(8),
          ),
        ),
        child: Text(
          _stripTags(bqMatch.group(1) ?? ''),
          style: base.copyWith(
            fontSize: fs,
            fontStyle: FontStyle.italic,
            color: Colors.grey[700],
          ),
        ),
      );
    }

    // Unordered list
    final ulMatch = RegExp(r'<ul[^>]*>(.*?)<\/ul>', dotAll: true, caseSensitive: false).firstMatch(block);
    if (ulMatch != null) {
      final items = RegExp(r'<li[^>]*>(.*?)<\/li>', dotAll: true, caseSensitive: false)
          .allMatches(ulMatch.group(1) ?? '')
          .map((m) => _stripTags(m.group(1) ?? '').trim())
          .where((s) => s.isNotEmpty)
          .toList();
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('• ', style: TextStyle(fontSize: 16, height: 1.6)),
                Expanded(
                  child: Text(item, style: base.copyWith(fontSize: fs)),
                ),
              ],
            ),
          )).toList(),
        ),
      );
    }

    // Paragraph and default text - process inline formatting
    final pMatch = RegExp(r'<p[^>]*>(.*?)<\/p>', dotAll: true, caseSensitive: false).firstMatch(block);
    final content = pMatch != null ? (pMatch.group(1) ?? '') : block;
    final stripped = _stripTags(content).trim();
    if (stripped.isEmpty && !block.contains('<br')) return null;
    if (stripped.isEmpty) return const SizedBox(height: 8);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: _buildRichText(content, base.copyWith(fontSize: fs)),
    );
  }

  static Widget _buildRichText(String html, TextStyle base) {
    final spans = <TextSpan>[];
    final regex = RegExp(
      r'<strong[^>]*>(.*?)<\/strong>|<b[^>]*>(.*?)<\/b>|<em[^>]*>(.*?)<\/em>|<i[^>]*>(.*?)<\/i>|([^<]+)',
      dotAll: true,
      caseSensitive: false,
    );
    for (final match in regex.allMatches(html)) {
      if (match.group(1) != null || match.group(2) != null) {
        // Strong/bold
        spans.add(TextSpan(
          text: _stripTags(match.group(1) ?? match.group(2) ?? ''),
          style: base.copyWith(fontWeight: FontWeight.bold),
        ));
      } else if (match.group(3) != null || match.group(4) != null) {
        // Em/italic
        spans.add(TextSpan(
          text: _stripTags(match.group(3) ?? match.group(4) ?? ''),
          style: base.copyWith(fontStyle: FontStyle.italic),
        ));
      } else if (match.group(5) != null) {
        final text = _decodeEntities(match.group(5)!);
        if (text.isNotEmpty) {
          spans.add(TextSpan(text: text, style: base));
        }
      }
    }
    if (spans.isEmpty) {
      return Text(_stripTags(html), style: base);
    }
    return RichText(text: TextSpan(children: spans));
  }

  static String _stripTags(String html) {
    return _decodeEntities(
      html.replaceAll(RegExp(r'<[^>]+>'), ' ')
          .replaceAll(RegExp(r'\s+'), ' ')
          .trim(),
    );
  }

  static String _decodeEntities(String text) {
    return text
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&mdash;', '—')
        .replaceAll('&ndash;', '–')
        .replaceAll('&hellip;', '...');
  }
}
