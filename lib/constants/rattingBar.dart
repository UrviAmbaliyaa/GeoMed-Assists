import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geomed_assist/constants/Appcolors.dart';

class rattingBar extends StatefulWidget {
  final bool tapOnly;
  final double initValue;
  final double? size;
  const rattingBar({super.key, required this.tapOnly, required this.initValue, this.size});

  @override
  State<rattingBar> createState() => _rattingBarState();
}

class _rattingBarState extends State<rattingBar> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RatingBar.builder(
          initialRating: widget.initValue,
          minRating: 1,
          ignoreGestures: widget.tapOnly,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          unratedColor: AppColor.greycolor,
          itemSize: widget.size ?? 16,
          itemBuilder: (context, _) => Icon(
            Icons.star,
            color: Colors.amber,
          ),
          onRatingUpdate: (rating) {
            print(rating);
          },
        ),
        widget.tapOnly? Text(" ${(widget.initValue*20).toInt()}%",style: TextStyle(color: AppColor.greycolor, fontSize: 10)):SizedBox.shrink(),
      ],
    );
  }
}
