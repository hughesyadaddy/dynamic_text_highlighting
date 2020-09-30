library dynamic_text_highlighting;

import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class DynamicTextHighlighting extends StatelessWidget {
  //DynamicTextHighlighting
  final String text;
  final List<String> highlights;
  final Color color;
  final TextStyle style;
  final bool caseSensitive;

  //RichText
  final TextAlign textAlign;
  final TextDirection textDirection;
  final bool softWrap;
  final TextOverflow overflow;
  final double textScaleFactor;
  final int maxLines;
  final double minFontSize;
  final double maxFontSize;
  final double stepGranularity;
  final List<double> presetFontSizes;
  final AutoSizeGroup group;
  final Locale locale;
  final bool wrapWords;
  final Widget overflowReplacement;
  final StrutStyle strutStyle;
  final TextWidthBasis textWidthBasis;
  final TextHeightBehavior textHeightBehavior;
  final String semanticsLabel;

  DynamicTextHighlighting({
    //DynamicTextHighlighting
    Key key,
    this.text,
    this.highlights = const [],
    this.color = Colors.yellow,
    this.style,
    this.caseSensitive = false,

    //RichText

    this.textWidthBasis,
    this.textHeightBehavior,
    this.strutStyle,
    this.minFontSize = 12,
    this.maxFontSize = double.infinity,
    this.stepGranularity = 1,
    this.presetFontSizes,
    this.group,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.wrapWords = true,
    this.overflow,
    this.overflowReplacement,
    this.textScaleFactor,
    this.maxLines,
    this.semanticsLabel,
  })  : assert(text != null),
//        assert(highlights != null),
        // assert(color != null),
        // assert(style != null),
//        assert(caseSensitive != null),
        // assert(textAlign != null),
//        assert(softWrap != null),
        // assert(overflow != null),
        // assert(textScaleFactor != null),
        // assert(maxLines == null || maxLines > 0),
        // assert(textWidthBasis != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    //Controls
    if (text == '') {
      return _richText(_normalSpan(text));
    }
    if (highlights.isEmpty) {
      return _richText(_normalSpan(text));
    }
    for (int i = 0; i < highlights.length; i++) {
      if (highlights[i] == null) {
        assert(highlights[i] != null);
        return _richText(_normalSpan(text));
      }
      if (highlights[i].isEmpty) {
        assert(highlights[i].isNotEmpty);
        return _richText(_normalSpan(text));
      }
    }

    //Main code
    List<TextSpan> _spans = List();
    int _start = 0;

    //For "No Case Sensitive" option
    String _lowerCaseText = text.toLowerCase();
    List<String> _lowerCaseHighlights = List();

    highlights.forEach((element) {
      _lowerCaseHighlights.add(element.toLowerCase());
    });

    while (true) {
      Map<int, String> _highlightsMap = Map(); //key (index), value (highlight).

      if (caseSensitive) {
        for (int i = 0; i < highlights.length; i++) {
          int _index = text.indexOf(highlights[i], _start);
          if (_index >= 0) {
            _highlightsMap.putIfAbsent(_index, () => highlights[i]);
          }
        }
      } else {
        for (int i = 0; i < highlights.length; i++) {
          int _index = _lowerCaseText.indexOf(_lowerCaseHighlights[i], _start);
          if (_index >= 0) {
            _highlightsMap.putIfAbsent(_index, () => highlights[i]);
          }
        }
      }

      if (_highlightsMap.isNotEmpty) {
        List<int> _indexes = List();
        _highlightsMap.forEach((key, value) => _indexes.add(key));

        int _currentIndex = _indexes.reduce(min);
        String _currentHighlight = text.substring(_currentIndex,
            _currentIndex + _highlightsMap[_currentIndex].length);

        if (_currentIndex == _start) {
          _spans.add(_highlightSpan(_currentHighlight));
          _start += _currentHighlight.length;
        } else {
          _spans.add(_normalSpan(text.substring(_start, _currentIndex)));
          _spans.add(_highlightSpan(_currentHighlight));
          _start = _currentIndex + _currentHighlight.length;
        }
      } else {
        _spans.add(_normalSpan(text.substring(_start, text.length)));
        break;
      }
    }

    return _richText(TextSpan(children: _spans));
  }

  TextSpan _highlightSpan(String value) {
    if (style.color == null) {
      return TextSpan(
        text: value,
        style: style.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
//          color: Colors.black,
//          backgroundColor: color,
        ),
      );
    } else {
      return TextSpan(
        text: value,
        style: style.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
//          backgroundColor: color,
        ),
      );
    }
  }

  TextSpan _normalSpan(String value) {
    if (style.color == null) {
      return TextSpan(
        text: value,
        style: style.copyWith(
          color: Colors.black,
        ),
      );
    } else {
      return TextSpan(
        text: value,
        style: style,
      );
    }
  }

  AutoSizeText _richText(TextSpan text) {
    return AutoSizeText.rich(
      text,
      key: key,
//      style: style,
      strutStyle: strutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
//      textScaleFactor: fontSize / style.fontSize,
      maxLines: maxLines,
      semanticsLabel: semanticsLabel,
    );
  }
}
