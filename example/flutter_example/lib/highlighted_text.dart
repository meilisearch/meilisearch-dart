import 'package:flutter/material.dart';

/// This can be added to the sdk
class HighlightableStringPart {
  final String text;
  final bool isHighlighted;

  const HighlightableStringPart({
    required this.text,
    required this.isHighlighted,
  });
}

/// The core function for handling text highlighting
/// This can be added to the sdk
Iterable<HighlightableStringPart> parseHighligtableString({
  required String text,
  required String preTag,
  required String postTag,
}) sync* {
  final preIndex = text.indexOf(preTag);
  final postIndex = text.indexOf(postTag);
  if (preIndex < 0 || postIndex < 0) {
    //if the text doesn't contain pre/post tags, there is no need for highlighting
    yield HighlightableStringPart(text: text, isHighlighted: false);
  } else {
    //before the pre tag should be normal text
    final beforePre = preIndex == 0 ? null : text.substring(0, preIndex);
    //after the post tag might be normal or highlighted
    final afterPost = text.substring(postIndex + postTag.length);
    //between the Pre and Post tags is the highlighted text
    final between = text.substring(preIndex + preTag.length, postIndex);
    if (beforePre != null && beforePre.isNotEmpty) {
      yield HighlightableStringPart(text: beforePre, isHighlighted: false);
    }
    yield HighlightableStringPart(text: between, isHighlighted: true);
    if (afterPost.isNotEmpty) {
      yield* parseHighligtableString(
        text: afterPost,
        postTag: postTag,
        preTag: preTag,
      );
    }
  }
}

/// adapts [parseHighligtableString] to flutter's [TextSpan]
TextSpan highlightedTextToSpan(
  String text, {
  required String preTag,
  required String postTag,
  TextStyle? highlightedStyle,
}) {
  final parts = parseHighligtableString(
    postTag: postTag,
    preTag: preTag,
    text: text,
  ).toList();
  return TextSpan(
    children: parts
        .map(
          (e) => TextSpan(
              text: e.text, style: e.isHighlighted ? highlightedStyle : null),
        )
        .toList(),
  );
}

class HighlightedText extends StatelessWidget {
  const HighlightedText({
    super.key,
    required this.preTag,
    required this.postTag,
    required this.original,
    this.highlightedStyle = const TextStyle(
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.normal,
      decoration: TextDecoration.underline,
    ),
  });

  final String original;
  final String preTag;
  final String postTag;
  final TextStyle? highlightedStyle;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      highlightedTextToSpan(
        original,
        postTag: postTag,
        preTag: preTag,
        highlightedStyle: highlightedStyle,
      ),
    );
  }
}
