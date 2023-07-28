import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_responsive_dashboard_ui/style/colors.dart';

class AppBarActionItems extends StatelessWidget {
  const AppBarActionItems({
    required Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
            icon: SvgPicture.asset(
              'assets/calendar.svg',
              width: 25,
              color:AppColors.iconGray,
            ),
            onPressed: () {}),
        SizedBox(width: 10),
        IconButton(
            icon: SvgPicture.asset('assets/time.svg', width: 25.0, color:AppColors.iconGray),
            onPressed: () {}),
        SizedBox(width: 15),
        Row(children: [
          CircleAvatar(
            radius: 17,
            child: SvgPicture.asset(
              'assets/man.svg',
            width:34,
            height:34,
            ),
          ),
          Icon(Icons.arrow_drop_down_outlined, color: AppColors.black)
        ]),
      ],
    );
  }
}