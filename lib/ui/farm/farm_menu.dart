import 'package:agriconnect/ui/farm/news/news_home.dart';
import 'package:agriconnect/ui/farm/planting/planting_menu.dart';
import 'package:agriconnect/ui/farm/weather/weatherHome.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/colors/gf_color.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:page_transition/page_transition.dart';

import '../../app_theme.dart';
import '../../utils/user_message_helper.dart';
import 'harvesting/harvesting_menu.dart';

class FarmMenu extends StatefulWidget {
  @override
  _FarmMenuState createState() => _FarmMenuState();
}

class _FarmMenuState extends State<FarmMenu> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          WeatherHome(),
          GFListTile(
            avatar: GFAvatar(
              backgroundImage: AssetImage('assets/images/manage_harvest.png'),
              backgroundColor: GFColors.TRANSPARENT,
            ),
            titleText: 'Harvesting',
            color: AppTheme.appSecondaryColor,
            subTitle: Text('Store and view harvesting related activities.'),
            icon: Icon(Icons.chevron_right),
            onTap: () {
              UserMessageHelper.showSnackBar(context, 'Future update.');
              // TODO: uncomment for the second report
              Navigator.push(
                context,
                PageTransition(
                    type: PageTransitionType.leftToRightWithFade,
                    child: HarvestMenu()),
              );
            },
          ),
          GFListTile(
            avatar: GFAvatar(
              backgroundImage: AssetImage('assets/images/manage_planting.png'),
              backgroundColor: GFColors.TRANSPARENT,
            ),
            titleText: 'Planting',
            color: Colors.amberAccent.withOpacity(0.3),
            subTitle: Text('Store and view Planting related activities.'),
            icon: Icon(Icons.chevron_right),
            onTap: () {
              UserMessageHelper.showSnackBar(context, 'Future update.');
              // TODO: uncomment for the second report
              Navigator.push(
                context,
                PageTransition(
                    type: PageTransitionType.leftToRightWithFade,
                    child: PlantingMenu()),
              );
            },
          ),
          GFListTile(
            avatar: GFAvatar(
              backgroundImage: AssetImage('assets/images/manage_news.png'),
              backgroundColor: GFColors.TRANSPARENT,
            ),
            titleText: 'View News',
            color: Colors.redAccent.withOpacity(0.3),
            subTitle: Text('Read the latest news about agriculture here.'),
            icon: Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                PageTransition(
                    type: PageTransitionType.leftToRightWithFade,
                    child: NewsHomePage()),
              );
            },
          ),
          GFListTile(
            avatar: GFAvatar(
              backgroundImage:
                  AssetImage('assets/images/manage_statistics.png'),
              backgroundColor: GFColors.TRANSPARENT,
            ),
            titleText: 'View Statistics',
            subTitle:
                Text('Numbers based on your planting and harvesting history.'),
            color: Colors.lightBlueAccent.withOpacity(0.3),
            icon: Icon(Icons.chevron_right),
            onTap: () {
              UserMessageHelper.showSnackBar(context, 'Future update.');
              // TODO: uncomment for the second report
              // Navigator.push(
              //   context,
              //   PageTransition(
              //       type: PageTransitionType.leftToRightWithFade,
              //       child: StatisticsHome()),
              // );
            },
          ),
        ],
      ),
    );
  }
}
