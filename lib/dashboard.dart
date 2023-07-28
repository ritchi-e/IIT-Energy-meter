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
// ignore: unused_import
import '../main.dart';
import 'package:flutter_responsive_dashboard_ui/data_model.dart';
import 'package:flutter_responsive_dashboard_ui/influx_service.dart';


enum TimePeriod {
  two_minutes,
  five_minutes,
 ten_minutes,
}

String getLatestPowerFactor(List<MyDataModel> data) {
  if (data.isEmpty) {
    return ''; // Return an empty string if the data list is empty
  }
  data.sort((a, b) => b.time.compareTo(a.time));
  for (final entry in data.reversed) {
     
      return '${entry.avgPF.toStringAsFixed(2)} %';
    
  }
  return ''; // Return an empty string if no entry with field = 'AvgPF' is found
}

class Dashboard extends StatefulWidget {
  final List<MyDataModel> parsedData;
  const Dashboard({Key? key, required this.parsedData}) : super(key: key);
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  InfluxService influxService = InfluxService(); // Declare and initialize influxService

  String selectedRegion = ''; // Track the selected region
  TimePeriod selectedTimePeriod = TimePeriod.ten_minutes; // Track the selected time period
  List<MyDataModel> parsedData = [];

 Future<void> fetchDataForSelectedTimePeriod() async {
 String timeDuration;
  switch (selectedTimePeriod) {
    case TimePeriod.two_minutes:
      timeDuration = "2m";
      break;
    case TimePeriod.five_minutes:
      timeDuration = "5m";
      break;
    case TimePeriod.ten_minutes:
      timeDuration = "10m";
      break;
    default:
      timeDuration = "10m";
      break;
  }
 String region = '722748/0'; // Replace this with the selected region if needed
     // Create an instance of the InfluxService class
  List<MyDataModel> data = await influxService.getInfluxData(timeDuration, region);
 
  setState(() {
    parsedData = data;
  });
}

  void onTimePeriodChanged(TimePeriod newTimePeriod) {
    setState(() {
      selectedTimePeriod = newTimePeriod;
  });
  fetchDataForSelectedTimePeriod(); // Call the method to fetch data based on the selected time period

}
@override
  void initState() {
    super.initState();
    // Initialize parsedData here if needed
    fetchDataForSelectedTimePeriod(); // Fetch data for the initial selected time period
  }
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    List<InfoCard> getInfoCardData(List<MyDataModel> parsedData) {

      double powerUsage = 0;
    double currentUsage = 0;
    double voltageUsage = 0;

    for (final entry in parsedData) {
    powerUsage = entry.kWh; // Accessing the kWh value
    currentUsage = entry.i1; // Accessing the I1 value
    voltageUsage = entry.v1N; // Accessing the V1N value
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
      drawer: SizedBox(
        width: 100, 
        child: SideMenu(
          key: UniqueKey(),
          onRegionSelected: (region) {
            setState(() {
              selectedRegion = region;
            });
          },
        ),
      ),
      appBar: !Responsive.isDesktop(context)
          ? AppBar(
              elevation: 0,
              backgroundColor: AppColors.secondaryBg,
              leading: Builder(
                builder:(context){
                  return IconButton(
                  onPressed: () {
                  Scaffold.of(context).openDrawer(); // Open the drawer when the hamburger icon is clicked
                   },
                  icon: Icon(Icons.menu, color: AppColors.black)
                  );
                },
              ),
              actions: [
                AppBarActionItems(
                  key: _drawerKey,),
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
                              amount: '${widget.parsedData.first.kWh.toStringAsFixed(2)} KW',
                              data: widget.parsedData,
                            ),
                            InfoCard(
                              icon: 'assets/volt.svg',
                              label: ' Voltage usage',
                              amount: '${widget.parsedData.first.v1N.toStringAsFixed(2)} V',
                              data: widget.parsedData,
                            ),
                            InfoCard(
                              icon: 'assets/current.svg',
                              label: 'Current usage ',
                              amount: '${widget.parsedData.first.i1.toStringAsFixed(2)} A',
                              data: widget.parsedData,
                            ),
                            InfoCard(
                              icon: 'assets/time.svg',
                              label: 'Temperature',
                              amount: '70 F ',
                              data: widget.parsedData,
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
                                text: 'Average PF',
                                size: 30,
                                fontWeight: FontWeight.w400,
                                color: AppColors.barBg,
                              ),
                              PrimaryText(
                                text:getLatestPowerFactor(widget.parsedData),
                                size: 15,
                                fontWeight: FontWeight.w800,
                              ),
                            ],
                          ),
                          PrimaryText(
                            text: 'Fetched Details',
                            size: 16,
                            fontWeight: FontWeight.w400,
                            color: AppColors.iconGray,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: SizeConfig.blockSizeVertical * 3,
                      ),
                      Container(
                        height: 180,
                        child: BarChartCopmponent(
                          key: UniqueKey(),
                          data: widget.parsedData,
                          ),
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
                            color: AppColors.iconGray,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: SizeConfig.blockSizeVertical * 3,
                      ),
                      if (selectedRegion.isNotEmpty) ...[
                         RegionDetails(
                          selectedRegion: selectedRegion,
                          parsedData: widget.parsedData),
                      ] else ...[
                        HistoryTable(
                          key: UniqueKey(),
                          ), // Display a placeholder when no region is selected
                      ],
                      if (!Responsive.isDesktop(context))
                        PaymentDetailList(key: _drawerKey, parsedData: widget.parsedData,)
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
                          PaymentDetailList(key: UniqueKey(), parsedData: widget.parsedData,),
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
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color:AppColors.primary),
        ),
        // Add your UI components here
      SizedBox(height: 10),
        Text(
          'Current',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          height: 300,
         child: LineChartComponent(dataList: parsedData, chartType: ChartType.current,),
        
        ),
        SizedBox(height: 10),
        Text(
          'Voltage',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          height: 400,
          child: LineChartComponent(dataList: parsedData, chartType: ChartType.voltage),
          ),
        SizedBox(height: 20),

      ],
    );
  }
}
