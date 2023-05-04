import 'package:cible/helpers/screenSizeHelper.dart';
import 'package:cible/helpers/textHelper.dart';
import 'package:cible/views/splash/splash.controller.dart';
import 'package:cible/views/splash/splash.widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:cible/constants/localPath.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../core/routes.dart';
import '../../helpers/colorsHelper.dart';
import 'package:line_icons/line_icons.dart';
import 'dart:async';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  PageController _controller = PageController(initialPage: 0);
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: 2), () async {
      await setSharepreferencePagePosition(0);
    });
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: Device.getDiviseScreenWidth(context, 30)),
      width: Device.getStaticScreenWidth(context),
      height: Device.getStaticScreenHeight(context),
      decoration: BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
            image: AssetImage("assets/images/preview_fond.png"),
            fit: BoxFit.fill,
            colorFilter: ColorFilter.linearToSrgbGamma(),
            repeat: ImageRepeat.repeat),
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
              child: Stack(children: [
            Container(
              alignment: Alignment(0.3, -0.8),
              child: Row(
                children: [
                  Container(
                    height: Device.getDiviseScreenHeight(context, 8),
                    child: Image.asset('${imagesPath}logo_blanc.png'),
                  ),
                ],
              ),
            ),
            PageView(
              controller: _controller,
              onPageChanged: (value) {
                setState(() {
                  currentPage = value;
                });
              },
              children: [slide1(context), slide2(context), slide3(context)],
            ),
            Container(
                alignment: Alignment(0, 0.6),
                child: SmoothPageIndicator(
                  controller: _controller,
                  count: 3,
                  axisDirection: Axis.horizontal,
                  effect: SlideEffect(
                      spacing: 5.0,
                      radius: 50.0,
                      dotWidth: 7,
                      dotHeight: 7,
                      paintStyle: PaintingStyle.fill,
                      strokeWidth: 1.5,
                      offset: 10,
                      dotColor: Color.fromARGB(255, 224, 224, 224),
                      activeDotColor: AppColor.primaryColor),
                )),
            Container(
              alignment: Alignment(0, 0.82),
              padding: EdgeInsets.symmetric(
                  horizontal: Device.getDiviseScreenWidth(context, 25)),
              child: this.currentPage == 2
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    side: BorderSide(color: Colors.red))),
                            padding: MaterialStateProperty.resolveWith<
                                EdgeInsetsGeometry>(
                              (Set<MaterialState> states) {
                                return EdgeInsets.symmetric(
                                  horizontal:
                                      Device.getDiviseScreenWidth(context, 6)
                                          .toDouble(),
                                  vertical:
                                      Device.getDiviseScreenHeight(context, 50)
                                          .toDouble(),
                                );
                              },
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/auth');
                          },
                          child: FittedBox(
                            child: Text(
                              "Profitez bien",
                              style: GoogleFonts.poppins(
                                  textStyle:
                                      Theme.of(context).textTheme.bodyLarge,
                                  fontSize: AppText.p1(context),
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        this.currentPage > 0
                            ? Container(
                                decoration: BoxDecoration(
                                  color: AppColor.primaryColor.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(50),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColor.primaryColor
                                          .withOpacity(0.2),
                                      spreadRadius: 1,
                                      blurRadius: 1,
                                      offset: Offset(0, 1),
                                    ),
                                  ],
                                ),
                                child: IconButton(
                                  icon: Icon(LineIcons.arrowLeft),
                                  onPressed: () {
                                    _controller.previousPage(
                                        duration: Duration(milliseconds: 500),
                                        curve: Curves.easeIn);
                                  },
                                  color: AppColor.primaryColor,
                                ),
                              )
                            : SizedBox(),
                        this.currentPage != 0
                            ? SizedBox(
                                width: Device.getDiviseScreenWidth(context, 30),
                              )
                            : SizedBox(),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColor.primaryColor,
                            borderRadius: BorderRadius.circular(50),
                            boxShadow: [
                              BoxShadow(
                                color: AppColor.primaryColor.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 2,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: IconButton(
                            icon: Icon(LineIcons.arrowRight),
                            onPressed: () {
                              _controller.nextPage(
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.easeIn);
                            },
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
            )
          ]))),
    );
  }
}
