import 'package:cible/helpers/screenSizeHelper.dart';
import 'package:cible/views/acceuil/acceuil.controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

inputDecoration(label, largeur) {
  return InputDecoration(
    filled: true,
    fillColor: Color.fromARGB(134, 255, 255, 255),
    hintText: '${label}',
    hintStyle: GoogleFonts.poppins(fontSize: largeur / 25, color: Colors.black),
    contentPadding: const EdgeInsets.all(15),
    focusedBorder: OutlineInputBorder(
      // borderSide: BorderSide(color: Colors.white),
      borderRadius: BorderRadius.circular(10),
    ),
    enabledBorder: OutlineInputBorder(
      // borderSide: BorderSide(color: Colors.white),
      borderRadius: BorderRadius.circular(10),
    ),
  );
}

bottomNavigation(context, currentIndex) {
  return Container(
    margin: EdgeInsets.all(Device.getScreenWidth(context) * .05),
    height: Device.getScreenWidth(context) * .155,
    decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(.1),
          blurRadius: 30,
          offset: Offset(0, 10),
        ),
      ],
      borderRadius: BorderRadius.circular(50),
    ),
    child: ListView.builder(
      itemCount: 4,
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(
          horizontal: Device.getScreenWidth(context) * .02),
      itemBuilder: (context, index) => InkWell(
        onTap: () {
          currentIndex = index;
          HapticFeedback.lightImpact();
        },
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Stack(
          children: [
            AnimatedContainer(
              duration: Duration(seconds: 1),
              curve: Curves.fastLinearToSlowEaseIn,
              width: index == currentIndex
                  ? Device.getScreenWidth(context) * .32
                  : Device.getScreenWidth(context) * .18,
              alignment: Alignment.center,
              child: AnimatedContainer(
                duration: Duration(seconds: 1),
                curve: Curves.fastLinearToSlowEaseIn,
                height: index == currentIndex
                    ? Device.getScreenWidth(context) * .12
                    : 0,
                width: index == currentIndex
                    ? Device.getScreenWidth(context) * .32
                    : 0,
                decoration: BoxDecoration(
                  color: index == currentIndex
                      ? Colors.blueAccent.withOpacity(.2)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
            AnimatedContainer(
              duration: Duration(seconds: 1),
              curve: Curves.fastLinearToSlowEaseIn,
              width: index == currentIndex
                  ? Device.getScreenWidth(context) * .31
                  : Device.getScreenWidth(context) * .18,
              alignment: Alignment.center,
              child: Stack(
                children: [
                  Row(
                    children: [
                      AnimatedContainer(
                        duration: Duration(seconds: 1),
                        curve: Curves.fastLinearToSlowEaseIn,
                        width: index == currentIndex
                            ? Device.getScreenWidth(context) * .13
                            : 0,
                      ),
                      AnimatedOpacity(
                        opacity: index == currentIndex ? 1 : 0,
                        duration: Duration(seconds: 1),
                        curve: Curves.fastLinearToSlowEaseIn,
                        child: Text(
                          index == currentIndex
                              ? '${listOfStrings[index]}'
                              : '',
                          style: TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      AnimatedContainer(
                        duration: Duration(seconds: 1),
                        curve: Curves.fastLinearToSlowEaseIn,
                        width: index == currentIndex
                            ? Device.getScreenWidth(context) * .03
                            : 20,
                      ),
                      Icon(
                        listOfIcons[index],
                        size: Device.getScreenWidth(context) * .076,
                        color: index == currentIndex
                            ? Colors.blueAccent
                            : Colors.black26,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
