import 'package:flutter/material.dart';
import 'package:flutter_responsive_dashboard_ui/config/responsive.dart';
import 'package:flutter_responsive_dashboard_ui/style/colors.dart';
import 'package:flutter_responsive_dashboard_ui/style/style.dart';
import 'package:flutter_responsive_dashboard_ui/dashboard.dart';

class Header extends StatelessWidget {
  final Function(TimePeriod) onTimePeriodChanged;
  final TimePeriod selectedTimePeriod;

  const Header({
    required Key key,
    required this.onTimePeriodChanged, 
    required this.selectedTimePeriod,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
      SizedBox(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PrimaryText(
                  text: 'Energy Meter',
                  size: 30,
                  fontWeight: FontWeight.w800),
              PrimaryText(
                text: 'Dashboard',
                size: 16,
                fontWeight: FontWeight.w400,
                color: AppColors.secondary,
              )
            ]),
      ),
      Spacer(
        flex: 1,
      ),
      Expanded(
        flex: Responsive.isDesktop(context) ? 1 : 3,
       child: DropdownButton<TimePeriod>(
    value: selectedTimePeriod,
    onChanged: (TimePeriod? newValue) {
      if (newValue != null) {
        onTimePeriodChanged(newValue);
      }
    },
    items: TimePeriod.values.map<DropdownMenuItem<TimePeriod>>(
      (TimePeriod value) {
        return DropdownMenuItem<TimePeriod>(
          value: value,
          child: Text(value.toString().split('.').last),
        );
      },
    ).toList(),
  ),
),
    ],
    );
  }
}