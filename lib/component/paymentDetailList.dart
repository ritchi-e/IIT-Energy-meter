import 'package:flutter/material.dart';
import 'package:flutter_responsive_dashboard_ui/component/paymentListTile.dart';
import 'package:flutter_responsive_dashboard_ui/config/size_config.dart';
import 'package:flutter_responsive_dashboard_ui/data.dart';
import 'package:flutter_responsive_dashboard_ui/style/colors.dart';
import 'package:flutter_responsive_dashboard_ui/style/style.dart';
import 'package:intl/intl.dart';
import 'package:flutter_responsive_dashboard_ui/main.dart';
import 'package:flutter_responsive_dashboard_ui/data_model.dart';

class PaymentDetailList extends StatelessWidget {
 final List<MyDataModel> parsedData;
 
  const PaymentDetailList({
    required Key key,
    required this.parsedData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
 
      final currentDate = DateFormat('dd MMM yyyy').format(DateTime.now());
     List<Map<String, dynamic>> updatedActivities = recentActivities.map((activity) {

      final label = activity['label'] as String; // Get the label from recentActivities
      final threshold = (activity['threshold'] as num).toDouble(); // Get the threshold from recentActivities

      // Find the corresponding data from the parsedData based on the label
      final dataEntry = parsedData.firstWhere(
        (entry) => label == 'v1N' || label == 'v2N' || label == 'v3N',
  
      );

     // ignore: unnecessary_null_comparison
     if (dataEntry != null) {
    final threshold = (activity['threshold'] as num).toDouble();
    double value;
    if (label == 'v1N') {
      value = dataEntry.v1N;
    } else if (label == 'v2N') {
      value = dataEntry.v2N;
    } else if (label == 'v3N') {
      value = dataEntry.v3N;
    } else {
      value = 0.0; // Set a default value or handle the case when the label is not 'v1N', 'v2N', or 'v3N'
    }

   if (value > threshold) {
      print('Notification: ${activity['label']} exceeded the threshold.');
      return {...activity, 'amount': value.toStringAsFixed(2)};
    } else {
      print('Threshold not exceeded for ${activity['label']}');
      return activity;
    }
  } else {
    print('Data entry not found for ${activity['label']}');
    return activity;
  }
}).toList();
      
     return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(
        height: SizeConfig.blockSizeVertical * 5,
      ),
      Container(
        decoration:
            BoxDecoration(borderRadius: BorderRadius.circular(30), boxShadow: [
          BoxShadow(
            color: AppColors.iconGray,
            blurRadius: 15.0,
            offset: const Offset(
              10.0,
              15.0,
            ),
          )
        ]),
        child: Image.asset('assets/card.png'),
      ),
      SizedBox(
        height: SizeConfig.blockSizeVertical * 5,
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PrimaryText(
              text: 'Alerts',
               size: 18,
                fontWeight: FontWeight.w800
                ),
          PrimaryText(
            text: currentDate,
            size: 14,
            fontWeight: FontWeight.w400,
            color: AppColors.secondary,
          ),
        ],
      ),
      SizedBox(
        height: SizeConfig.blockSizeVertical * 2,
      ),
      Column(
        children: List.generate(
         recentActivities.length,
          (index) => PaymentListTile(
            icon: updatedActivities[index]["icon"] as String,
            label: updatedActivities[index]["label"] as String,
            amount: updatedActivities[index]["amount"] as String,
        ),  ),
      ),
      SizedBox(
        height: SizeConfig.blockSizeVertical * 5,
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PrimaryText(
              text: 'Meter specifications', size: 18, fontWeight: FontWeight.w800),
          PrimaryText(
            text: currentDate,
            size: 14,
            fontWeight: FontWeight.w400,
            color: AppColors.secondary,
          ),
        ],
      ),
      SizedBox(
        height: SizeConfig.blockSizeVertical * 2,
      ),
      Column(
        children: List.generate(
          upcomingPayments.length,
          (index) => PaymentListTile(
              icon: upcomingPayments[index]["icon"]!,
              label: upcomingPayments[index]["label"]!,
              amount: upcomingPayments[index]["amount"]!),
        ),
      ),
    ]);
    
  }
  double getDataValue(String label, MyDataModel dataEntry) {
    switch (label) {
      case 'v1N':
        return dataEntry.v1N;
      case 'v2N':
        return dataEntry.v2N;
      case 'v3N':
        return dataEntry.v3N;
      default:
        return 0.0; // Return a default value if the label is not matched
    }
  }
}