import 'package:flutter/material.dart';
import 'package:flutter_responsive_dashboard_ui/config/responsive.dart';
import 'package:flutter_responsive_dashboard_ui/config/size_config.dart';
import 'package:flutter_responsive_dashboard_ui/data.dart';
import 'package:flutter_responsive_dashboard_ui/style/colors.dart';
import 'package:flutter_responsive_dashboard_ui/style/style.dart';
import 'package:flutter_svg/svg.dart';
import '../main.dart';
import 'package:flutter_responsive_dashboard_ui/dashboard.dart';
import '../data_model.dart';

class HistoryTable extends StatelessWidget {
  const HistoryTable({
    required Key key,
  }) : super(key: key);

  

  @override
  Widget build(BuildContext context) {
    
     return SingleChildScrollView(
      scrollDirection: Responsive.isDesktop(context) ? Axis.vertical : Axis.horizontal,
          child: SizedBox(
            width: Responsive.isDesktop(context) ? double.infinity : SizeConfig.screenWidth,
            child: Table(
        defaultVerticalAlignment:
              TableCellVerticalAlignment.middle,
        children: List.generate(
            transactionHistory.length,
            (index) => TableRow(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 20.0),
                  child: CircleAvatar(
                    radius: 17,
                    child: SvgPicture.asset(transactionHistory[index]["avatar"]!,
                    width:34,
                    height:34,
                    ),
                  ),
                ),
                PrimaryText(
                  text: transactionHistory[index]["label"]!,
                  size: 16,
                  fontWeight: FontWeight.w400,
                  color: AppColors.barBg,
                ),
                PrimaryText(
                  text: transactionHistory[index]["time"]!,
                  size: 16,
                  fontWeight: FontWeight.w400,
                  color: AppColors.barBg,
                ),
                PrimaryText(
                  text:transactionHistory[index]["amount"]!,
                  size: 16,
                  fontWeight: FontWeight.w400,
                  color: AppColors.barBg,
                ),
                PrimaryText(
                  text: transactionHistory[index]["status"]!,
                  size: 16,
                  fontWeight: FontWeight.w400,
                  color: AppColors.barBg,
                ),
              ],
            ),
        ),
      ),
          ),
    );
  }
}