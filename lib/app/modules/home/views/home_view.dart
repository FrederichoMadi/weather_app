import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:weatherapp/app/routes/app_pages.dart';
import 'package:weatherapp/app/utils/const.dart';
import 'package:weatherapp/app/utils/styles.dart';

import '../controllers/home_controller.dart';
import 'package:timeago/timeago.dart' as timeago;

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
        init: HomeController(),
        builder: (_) {
          return Scaffold(
            body: controller.state == 'loading'
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : SafeArea(
                    child: SmartRefresher(
                      controller: controller.refreshController,
                      onLoading: controller.onLoading,
                      onRefresh: controller.onRefresh,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            _cardHeader(context),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Today",
                                    style: oss16.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  InkWell(
                                    onTap: () => Get.toNamed(Routes.DEATIL,
                                        arguments: controller.weather),
                                    child: Text(
                                      "${controller.weather['daily'].length - 1} days >",
                                      style: oss12.copyWith(
                                        color: Colors.white.withOpacity(0.6),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height * 0.17,
                              padding: const EdgeInsets.all(8.0),
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                itemCount: controller.weather['hourly'].length,
                                itemBuilder: ((context, index) {
                                  var time =
                                      DateTime.fromMicrosecondsSinceEpoch(
                                          controller.weather['hourly'][index]
                                                  ['dt'] *
                                              1000000);

                                  var currentTime =
                                      DateTime.fromMicrosecondsSinceEpoch(
                                          controller.weather['current']['dt'] *
                                              1000000);
                                  return Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.2,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      border: Border.all(
                                          color: Colors.white.withOpacity(0.6)),
                                      color: time
                                                  .difference(currentTime)
                                                  .inSeconds <
                                              1
                                          ? darkBlue
                                          : null,
                                    ),
                                    child: Column(
                                      children: [
                                        Text(
                                          "${controller.weather['hourly'][index]['temp'].toInt() - 273}\u00B0",
                                          style: oss12.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                        Image.network(
                                          IMAGE_URL +
                                              controller.weather["hourly"]
                                                      [index]['weather'][0]
                                                  ["icon"] +
                                              ".png",
                                          fit: BoxFit.cover,
                                        ),
                                        Text(
                                          "${DateFormat.Hm().format(time)}",
                                          style: oss12.copyWith(
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
          );
        });
  }

  Widget _cardHeader(BuildContext context) {
    return GetBuilder<HomeController>(
        init: HomeController(),
        builder: (_) {
          return controller.state == 'loading'
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          colors: [blue, darkBlue],
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xff053F8D),
                          offset: Offset(1, 6),
                          blurRadius: 10,
                        )
                      ],
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(30.0))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SvgPicture.asset("assets/images/circle_menu.svg"),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                color: Colors.white,
                              ),
                              Text(
                                controller.weather['timezone'],
                                style: oss12.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Icon(
                            Icons.more_vert,
                            color: Colors.white,
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.50,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          border: Border.all(color: Colors.white),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              height: 8,
                              width: 8,
                              decoration: BoxDecoration(
                                  color: Colors.yellow,
                                  borderRadius: BorderRadius.circular(80)),
                            ),
                            Text(
                              "Updated " +
                                  timeago.format(controller.currentTime),
                              style: oss12.copyWith(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      Image.network(
                        IMAGE_URL +
                            controller.weather["current"]["weather"][0]
                                ["icon"] +
                            "@2x.png",
                        width: MediaQuery.of(context).size.width * 0.35,
                        fit: BoxFit.fitWidth,
                      ),
                      Text(
                        "${controller.weather['current']['temp'].toInt() - 273}\u00B0",
                        style: GoogleFonts.openSans(
                            fontSize: 116,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Text(
                        "${controller.weather['current']['weather'][0]['main']}",
                        style: oss16.copyWith(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      Text(
                        "${DateFormat("d, MMMM").format(controller.currentTime)}",
                        style: oss16.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white.withOpacity(0.6)),
                      ),
                      SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _detailData(
                                icon: SvgPicture.asset(
                                    "assets/images/ic_wind.svg"),
                                data:
                                    "${controller.weather['current']['wind_speed']}kmph",
                                name: "Wind"),
                            _detailData(
                                icon: SvgPicture.asset(
                                    "assets/images/ic_water.svg"),
                                data:
                                    "${controller.weather['current']['humidity']}%",
                                name: "Humidity"),
                            _detailData(
                                icon: SvgPicture.asset(
                                    "assets/images/ic_cloud.svg"),
                                data:
                                    "${controller.weather['current']['clouds']}%",
                                name: "Chance of rain"),
                          ],
                        ),
                      ),
                      SizedBox(height: 12),
                    ],
                  ),
                );
        });
  }

  Widget _detailData({
    required SvgPicture icon,
    required String data,
    required String name,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        icon,
        Text(
          data,
          style: oss12.copyWith(color: Colors.white),
        ),
        Text(
          name,
          style: oss12.copyWith(color: Colors.white.withOpacity(0.6)),
        )
      ],
    );
  }
}
