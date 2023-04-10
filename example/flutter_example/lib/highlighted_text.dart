import 'package:flutter/material.dart';

/// The core function for handling text highlighting
TextSpan highlightedTextToSpan(
  String text, {
  required String preTag,
  required String postTag,
  TextStyle? highlightedStyle,
}) {
  final preIndex = text.indexOf(preTag);
  final postIndex = text.indexOf(postTag);
  if (preIndex < 0 || postIndex < 0) {
    //if the text doesn't contain pre/post tags, there is no need for highlighting
    return TextSpan(text: text);
  } else {
    //before the pre tag should be normal text
    final beforePre = preIndex == 0 ? null : text.substring(0, preIndex);
    //after the post tag might be normal or highlighted
    final afterPost = text.substring(postIndex + postTag.length);
    //between the Pre and Post tags is the highlighted text
    final between = text.substring(preIndex + preTag.length, postIndex);
    return TextSpan(children: [
      if (beforePre != null && beforePre.isNotEmpty) TextSpan(text: beforePre),
      TextSpan(text: between, style: highlightedStyle),
      //Recursive part to handle cases where multiple places can get highlighted
      if (afterPost.isNotEmpty)
        highlightedTextToSpan(
          afterPost,
          postTag: postTag,
          preTag: preTag,
          highlightedStyle: highlightedStyle,
        ),
    ]);
  }
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
