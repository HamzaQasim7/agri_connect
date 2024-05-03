import 'package:farmassist/ui/farm/news/news_home.dart';
import 'package:farmassist/ui/farm/weather/weatherHome.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/colors/gf_color.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:page_transition/page_transition.dart';

import '../../utils/user_message_helper.dart';

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
            color: Colors.blueGrey[100],
            subTitle: Text('Store and view harvesting related activities.'),
            icon: Icon(Icons.chevron_right),
            onTap: () {
              UserMessageHelper.showSnackBar(context, 'Future update.');
              // TODO: uncomment for the second report
              // Navigator.push(
              //   context,
              //   PageTransition(
              //       type: PageTransitionType.leftToRightWithFade,
              //       child: HarvestMenu()),
              // );
            },
          ),
          GFListTile(
            avatar: GFAvatar(
              backgroundImage: AssetImage('assets/images/manage_news.png'),
              backgroundColor: GFColors.TRANSPARENT,
            ),
            titleText: 'View News',
            color: Colors.blueGrey[100],
            subTitle: Text('Read the latest news about agriculture here.'),
            icon: Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                PageTransition(
                    type: PageTransitionType.leftToRightWithFade,
                    child: HomePage()),
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
            color: Colors.blueGrey[100],
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
