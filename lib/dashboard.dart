import 'package:flutter/material.dart';
import 'package:flutter_responsive_dashboard_ui/component/appBarActionItems.dart';
import 'package:flutter_responsive_dashboard_ui/component/barChart.dart';
import 'package:flutter_responsive_dashboard_ui/component/header.dart';
import 'package:flutter_responsive_dashboard_ui/component/historyTable.dart';
import 'package:flutter_responsive_dashboard_ui/component/listchart.dart';
import 'package:flutter_responsive_dashboard_ui/component/infoCard.dart';
import 'package:flutter_responsive_dashboard_ui/component/paymentDetailList.dart';
import 'package:flutter_responsive_dashboard_ui/component/sideMenu.dart';
import 'package:flutter_responsive_dashboard_ui/config/responsive.dart';
import 'package:flutter_responsive_dashboard_ui/config/size_config.dart';
import 'package:flutter_responsive_dashboard_ui/style/colors.dart';
import 'package:flutter_responsive_dashboard_ui/style/style.dart';
import '../main.dart';

enum TimePeriod {
  Today,
  This_week,
  This_month,
}



class Dashboard extends StatefulWidget {
  final List<MyDataModel> parsedData;
  const Dashboard({Key? key, required this.parsedData}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  String selectedRegion = ''; // Track the selected region
  TimePeriod selectedTimePeriod = TimePeriod.Today; // Track the selected time period

  void onTimePeriodChanged(TimePeriod newTimePeriod) {
    setState(() {
      selectedTimePeriod = newTimePeriod;
  });
}
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    List<InfoCard> getInfoCardData(List<MyDataModel> parsedData) {

      double powerUsage = 0;
    double currentUsage = 0;
    double voltageUsage = 0;

    for (final entry in parsedData) {
      if (entry.field == 'kWh') {
        powerUsage = entry.value;
      }
      if (entry.field == 'I1') {
        currentUsage = entry.value;
      }
      if (entry.field == 'V1N') {
        voltageUsage = entry.value;
      }
    }
    
    return[InfoCard(
        icon: 'assets/power.svg',
        label: ' Power usage',
        amount: '${powerUsage.toStringAsFixed(2)} KW',
        data: parsedData,
      ),
      InfoCard(
        icon: 'assets/volt.svg',
        label: ' Voltage usage',
        amount: '${voltageUsage.toStringAsFixed(2)} V',
        data: parsedData,
      ),
      InfoCard(
        icon: 'assets/current.svg',
        label: 'Current usage ',
        amount: '${currentUsage.toStringAsFixed(2)} A',
        data: parsedData,
      ),
      InfoCard(
        icon: 'assets/time.svg',
        label: 'Temperature',
        amount: '70 F',
        data: parsedData,
      ),
    ];

  }




    return Scaffold(
      key: _drawerKey,
      drawer: SizedBox(width: 100, child: SideMenu(key: UniqueKey(),onRegionSelected: (region) {
            setState(() {
              selectedRegion = region;
            });
          },
        ),
      ),
      appBar: !Responsive.isDesktop(context)
          ? AppBar(
              elevation: 0,
              backgroundColor: AppColors.white,
              leading: IconButton(
                  onPressed: () {
                    _drawerKey.currentState?.openDrawer();
                  },
                  icon: Icon(Icons.menu, color: AppColors.black)),
              actions: [
                AppBarActionItems(key: _drawerKey,),
              ],
            )
          : PreferredSize(
              preferredSize: Size.zero,
              child: SizedBox(),
            ),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (Responsive.isDesktop(context))
              Expanded(
                flex: 1,
                child: SideMenu(
                  key: UniqueKey(),
                  onRegionSelected: (region) {
                    setState(() {
                      selectedRegion = region;
                    });
                  },
                ),
              ),
            Expanded(
              flex: 10,
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Header(
                        key: UniqueKey(),
                        onTimePeriodChanged: onTimePeriodChanged,
                        selectedTimePeriod: selectedTimePeriod,
                    ),
                      SizedBox(
                        height: SizeConfig.blockSizeVertical * 4,
                      ),
                      SizedBox(
                        width: SizeConfig.screenWidth,
                        child: Wrap(
                          spacing: 10,
                          runSpacing: 20,
                          alignment: WrapAlignment.spaceBetween,
                          children: [
                            InfoCard(
                              icon: 'assets/power.svg',
                              label: ' Power usage',
                              amount: getInfoCardAmount(
                                widget.parsedData,
                                'kWh',
                            ), data: widget.parsedData,
                            ),
                            InfoCard(
                              icon: 'assets/volt.svg',
                              label: ' Voltage usage',
                              amount: getInfoCardAmount(widget.parsedData,
                                'V1N',
                            ), data: widget.parsedData,
                            ),
                            InfoCard(
                              icon: 'assets/current.svg',
                              label: 'Current usage ',
                              amount:getInfoCardAmount(
                                widget.parsedData,
                                'I1',
                              ), data: widget.parsedData,
                            ),
                            InfoCard(
                              icon: 'assets/time.svg',
                              label: 'Temperature',
                              amount: '70 F ', data: widget.parsedData,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.blockSizeVertical * 4,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              PrimaryText(
                                text: 'Efficiency',
                                size: 16,
                                fontWeight: FontWeight.w400,
                                color: AppColors.secondary,
                              ),
                              PrimaryText(
                                text: '60 \% Efficiency',
                                size: 30,
                                fontWeight: FontWeight.w800,
                              ),
                            ],
                          ),
                          PrimaryText(
                            text: 'Past 2 minutes',
                            size: 16,
                            fontWeight: FontWeight.w400,
                            color: AppColors.secondary,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: SizeConfig.blockSizeVertical * 3,
                      ),
                      Container(
                        height: 180,
                        child: BarChartCopmponent(key: UniqueKey(), data: [],),
                      ),
                      SizedBox(
                        height: SizeConfig.blockSizeVertical * 5,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          PrimaryText(
                            text: 'Frequency Variation',
                            size: 30,
                            fontWeight: FontWeight.w800,
                          ),
                          PrimaryText(
                            text: selectedRegion.isNotEmpty
                                ? 'Region: $selectedRegion'
                                : 'Select a region',
                            size: 16,
                            fontWeight: FontWeight.w400,
                            color: AppColors.secondary,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: SizeConfig.blockSizeVertical * 3,
                      ),
                      if (selectedRegion.isNotEmpty) ...[
                         RegionDetails(selectedRegion: selectedRegion,parsedData: widget.parsedData),
                      ] else ...[
                        HistoryTable(key: UniqueKey(),), // Display a placeholder when no region is selected
                      ],
                      if (!Responsive.isDesktop(context))
                        PaymentDetailList(key: _drawerKey)
                    ],
                  ),
                ),
              ),
            ),
            if (Responsive.isDesktop(context))
              Expanded(
                flex: 4,
                child: SafeArea(
                  child: Container(
                    width: double.infinity,
                    height: SizeConfig.screenHeight,
                    decoration: BoxDecoration(color: AppColors.secondaryBg),
                    child: SingleChildScrollView(
                      padding:
                          EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                      child: Column(
                        children: [
                          AppBarActionItems(key: UniqueKey()),
                          PaymentDetailList(key: UniqueKey()),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    ); 
  }
  


String getInfoCardAmount(List<MyDataModel> data, String field) {
    String amount = '0';

    for (final entry in data) {
      if (entry.field == field) {
        amount = entry.value.toStringAsFixed(2);
      }
    }

    return amount;
  }
}

class RegionDetails extends StatelessWidget {
  final String selectedRegion;
  final List<MyDataModel> parsedData;

  const RegionDetails({
    Key? key, 
    required this.selectedRegion, 
    required this.parsedData,})
      : super(key: key);
 
  @override
  Widget build(BuildContext context) {
    print('Parsed Data Length: ${parsedData.length}');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
                            // Add your implementation for displaying details of the selected region here
                            // You can use tables, bar graphs, or any other desired UI components
        Text(
          'Details for $selectedRegion',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        // Add your UI components here
      SizedBox(height: 20),
        Text(
          'Current',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          height: 200,
          child: LineChartComponent(data: parsedData, fields: ["AvgPF"],
          ),
        ),
        SizedBox(height: 20),
        Text(
          'Voltage',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          height: 200,
          child: LineChartComponent(data: parsedData, fields:["V1N"]),
        ),
        SizedBox(height: 20),

      ],
    );
  }
}
