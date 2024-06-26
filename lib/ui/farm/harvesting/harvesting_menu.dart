import 'package:agriconnect/app_theme.dart';
import 'package:agriconnect/ui/farm/harvesting/harvesting_list.dart';
import 'package:agriconnect/ui/farm/harvesting/planting_selection_list.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:page_transition/page_transition.dart';

class HarvestMenu extends StatefulWidget {
  @override
  _HarvestMenuState createState() => _HarvestMenuState();
}

class _HarvestMenuState extends State<HarvestMenu> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.background,
      child: Scaffold(
          appBar: GFAppBar(
            leading: GFIconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              type: GFButtonType.transparent,
            ),
            title: Text(
              "Manage Harvesting",
              style: TextStyle(
                color: AppTheme.nearlyWhite,
              ),
            ),
            backgroundColor: AppTheme.pastelGreen,
          ),
          backgroundColor: Colors.transparent,
          body: ListView(
            children: [
              Container(
                padding: EdgeInsets.only(top: 15.00),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.leftToRightWithFade,
                              child: PlantingSelectionList(),
                            ));
                      },
                      child: GFCard(
                        boxFit: BoxFit.cover,
                        image:
                            Image.asset('assets/images/harvesting_create.jpg'),
                        title: GFListTile(
                          titleText: 'Create Harvesting',
                          subTitle: Text("Record a new harvesting activity."),
                          icon: Icon(Icons.arrow_forward),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.leftToRightWithFade,
                              child: HarvestList(),
                            ));
                      },
                      child: GFCard(
                        boxFit: BoxFit.cover,
                        image:
                            Image.asset('assets/images/harvesting_view.jfif'),
                        title: GFListTile(
                          titleText: 'View Harvesting',
                          subTitle:
                              Text("Take a look at all your previous records."),
                          icon: Icon(Icons.arrow_forward),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }
}
