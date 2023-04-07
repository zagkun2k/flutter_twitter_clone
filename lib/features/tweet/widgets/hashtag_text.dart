import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:twitter_clone/features/tweet/views/hashtag_view.dart';
import 'package:twitter_clone/theme/theme.dart';

class HashtagText extends StatelessWidget {
  final String text;

  const HashtagText({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    List<TextSpan> textSpans = [];
    text.split(' ').forEach(
      (element) {
        if (element.startsWith('#')) {
          textSpans.add(
            TextSpan(
              text: '$element ',
              style: const TextStyle(
                color: Pallete.blueColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.push(
                    context,
                    HashtagView.route(element),
                  );
                },
            ),
          );
        } else if (element.startsWith('www.') ||
            element.startsWith('https://') ||
            element.startsWith('https://www.')) {
          textSpans.add(
            TextSpan(
              text: '$element ',
              style: const TextStyle(
                  color: Pallete.blueColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          );
        } else {
          textSpans.add(
            TextSpan(
              text: '$element ',
              style: const TextStyle(
                // color: Pallete.blueColor,
                fontSize: 16,
                // fontWeight: FontWeight.bold
              ),
            ),
          );
        }
      },
    );
    return RichText(
      text: TextSpan(
        children: textSpans,
      ),
    );
  }
}
