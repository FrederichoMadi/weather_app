import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:weatherapp/app/utils/styles.dart';

import '../../../utils/const.dart';
import '../controllers/deatil_controller.dart';

class DeatilView extends GetView<DeatilController> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<DeatilController>(
        init: DeatilController(),
        builder: (_) {
          return Scaffold(
              body: SafeArea(
                  child: Column(
            children: [
              _cardHeader(context),
              // SizedBox(
              //   height: 12,
              // ),
              Expanded(
                child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: controller.weather['daily'].length - 1,
                    itemBuilder: (context, index) {
                      var day = DateTime.fromMicrosecondsSinceEpoch(
                          controller.weather['daily'][index]['dt'] * 1000000);
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${DateFormat.E().format(day)}",
                              style: oss14.copyWith(
                                  color: Colors.white.withOpacity(0.7)),
                            ),
                            Row(
                              children: [
                                Image.network(
                                  IMAGE_URL +
                                      controller.weather["daily"][index]
                                          ["weather"][0]["icon"] +
                                      ".png",
                                  fit: BoxFit.cover,
                                ),
                                Text(
                                  "${controller.weather['daily'][index]['weather'][0]['main']}",
                                  style: oss16.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white.withOpacity(0.6)),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  "+${controller.weather['daily'][index]['temp']['max'].toInt() - 273}\u00B0",
                                  style: oss16.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                Text(
                                  "+${controller.weather['daily'][index]['temp']['min'].toInt() - 273}\u00B0",
                                  style: oss16.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white.withOpacity(0.6)),
                                ),
                              ],
                            )
                          ],
                        ),
                      );
                    }),
              )
            ],
          )));
        });
  }

  Widget _cardHeader(BuildContext context) {
    return GetBuilder<DeatilController>(
        init: DeatilController(),
        builder: (_) {
          return Container(
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
                          Icons.calendar_month_outlined,
                          color: Colors.white,
                        ),
                        SizedBox(width: 4),
                        Text(
                          "${controller.weather['daily'].length - 1} Days",
                          style: oss20.copyWith(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.more_vert,
                      color: Colors.white,
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.network(
                      IMAGE_URL +
                          controller.weather["daily"][0]["weather"][0]["icon"] +
                          "@2x.png",
                      width: MediaQuery.of(context).size.width * 0.35,
                      fit: BoxFit.fitWidth,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Tommorow",
                          style: GoogleFonts.openSans(
                              fontSize: 18, color: Colors.white),
                        ),
                        Row(
                          children: [
                            Text(
                              "${controller.weather['daily'][0]['temp']['max'].toInt() - 273}",
                              style: GoogleFonts.openSans(
                                  fontSize: 64,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Text(
                              "/${controller.weather['daily'][0]['temp']['min'].toInt() - 273}\u00B0",
                              style: GoogleFonts.openSans(
                                  fontSize: 42,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white.withOpacity(0.6)),
                              textAlign: TextAlign.end,
                            ),
                          ],
                        ),
                        Text(
                          "${controller.weather['daily'][0]['weather'][0]['main']}",
                          style: oss16.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white.withOpacity(0.6)),
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _detailData(
                          icon: SvgPicture.asset("assets/images/ic_wind.svg"),
                          data:
                              "${controller.weather['daily'][0]['wind_speed']}kmph",
                          name: "Wind"),
                      _detailData(
                          icon: SvgPicture.asset("assets/images/ic_water.svg"),
                          data:
                              "${controller.weather['daily'][0]['humidity']}%",
                          name: "Humidity"),
                      _detailData(
                          icon: SvgPicture.asset("assets/images/ic_cloud.svg"),
                          data: "${controller.weather['daily'][0]['clouds']}%",
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
