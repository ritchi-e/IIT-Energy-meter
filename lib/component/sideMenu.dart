import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_responsive_dashboard_ui/config/size_config.dart';
import 'package:flutter_responsive_dashboard_ui/style/colors.dart';



class SideMenu extends StatefulWidget {
  final Function(String) onRegionSelected;

  const SideMenu({
    required Key key,
    required this.onRegionSelected,

  }) : super(key: key);

  @override
  _SideMenuState createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  String selectedRegion = 'Region 1';

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      child: Container(
        width: double.infinity,
        height: SizeConfig.screenHeight,
        decoration: BoxDecoration(color: AppColors.secondaryBg),
        child: SingleChildScrollView(
                  child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
             Container(
               height: 100,
               alignment: Alignment.topCenter,
               width: double.infinity,
               padding: EdgeInsets.only(top: 20),
               child: SizedBox(
                    width: 35,
                    height: 20,
                    child: SvgPicture.asset('assets/mac-action.svg'),
                  ),
             ),
            
              IconButton(
                  iconSize: 35,
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  icon: SvgPicture.asset(
                    'assets/home.svg',
                    color: AppColors.iconGray,
                  ),
                  onPressed: () {
                    setState(() {
                      selectedRegion = ''; // Set selectedRegion to an empty string
    });
    widget.onRegionSelected(selectedRegion); // Call the callback function
  },
),
              IconButton(
                  iconSize: 35,
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  icon: SvgPicture.asset(
                    'assets/region1.svg',
                    color: AppColors.iconGray,
                  ),
                  onPressed: () {
                    setState(() {
                      selectedRegion = 'Region 1'; // Update the selected region
    });
    widget.onRegionSelected(selectedRegion); // Call the callback function

  },
),

              IconButton(
                  iconSize: 35,
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  icon: SvgPicture.asset(
                    'assets/region2.svg',
                    color: AppColors.iconGray,
                  ),
                  onPressed: () {setState(() {
                      selectedRegion = 'Region 2';
    });
    widget.onRegionSelected(selectedRegion); // Call the callback function

  },
),
              IconButton(
                  iconSize: 35,
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  icon: SvgPicture.asset(
                    'assets/region3.svg',
                    color: AppColors.iconGray,
                  ),
                  onPressed: () {setState(() {
                      selectedRegion = 'Region 3';
    });
    widget.onRegionSelected(selectedRegion); // Call the callback function

  },
),
      
            ],
          ),
        ),
      ),
    );
  }
  
  

}


  


