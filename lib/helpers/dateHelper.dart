import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'dart:html';
import 'package:intl/date_symbol_data_local.dart';
import 'dart:convert';

var enDatesFuture = initializeDateFormatting('fr', null);

class DateConvertisseur {
  convertirDate(string) {
    if (string != null) {
      String format = "yyyy-MM-ddThh:mm:ss";
      var formateur = DateFormat(format, 'fr_FR');
      DateTime dateTime = formateur.parse(string);
      return "${dateTime.year}-${dateTime.month}-${dateTime.day}";
    } else {
      return null;
    }
  }

  convertirDateFromApI(String string) {
    print(DateTime.now());

    if (string != null && string.isNotEmpty) {
      string = string.split("T")[0] + " " + string.split("T")[1].split(".")[0];
      return convertirDatePicker(DateTime.parse(string));
    } else {
      return null;
    }
  }

  convertirStringtoDateTime(string) {
    // String format = "yyyy-mm-dd";
    // var formateur = DateFormat(format, 'fr_FR');

    DateTime dateTime = DateFormat.yMMMMEEEEd('fr_FR').parse(string);

    return dateTime;
  }

  convertirDatePicker(dateTime) {
    return DateFormat('yMMMMEEEEd', 'fr_FR').format(dateTime);
  }

  convertirDatePickerInvert(String dateTime) {
    return DateFormat('yMMMMEEEEd', 'fr_FR').parse(dateTime);
  }

  DateTime convertStringToDateTime(value) {
    var temp = value.split('/');
    String stringd = '${temp[2]}-${temp[1]}-${temp[0]} 00:00:00.000';
    print(stringd);
    return DateTime.parse(stringd);
  }

  convertirStringDatePicker(String dateTimeString) {
    var temp = dateTimeString.split('/');
    String stringd = '${temp[2]}-${temp[1]}-${temp[0]} 00:00:00.000';
    print(stringd);
    var date = DateTime.parse(stringd);
    return DateFormat('yMMMMEEEEd', 'fr_FR').format(date);
  }

  convertirStringPickertoStringDateTime(dateTime) {
    return DateFormat('yyyy-mm-dd', 'fr_FR').format(dateTime);
  }

  convertirHeure(string) {
    if (string != null) {
      String format = "yyyy-MM-ddThh:mm:ss";
      var formateur = DateFormat(format);
      DateTime date = formateur.parse(string);

      return "${date.hour} h : ${date.minute} m";
    }
  }

  compareDates(DateTime date1, DateTime date2) {
    if (date1.year > date2.year) {
      return true;
    } else if (date1.year < date2.year) {
      return false;
    } else {
      if (date1.month > date2.month) {
        return true;
      } else if (date1.month < date2.month) {
        return false;
      } else {
        if (date1.day > date2.day) {
          return true;
        } else if (date1.day < date2.day) {
          return false;
        } else {
          return true;
        }
      }
    }
  }

  compareEqualityDates(DateTime date1, DateTime date2) {
    if (date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day) {
      return true;
    } else {
      return false;
    }
  }

  convertirTimeofDay(time) {
    return '${(time.period == DayPeriod.am || time.hour >= 12 ? time.hour : time.hour + 12).toString().padLeft(2, '0')} h : ${time.minute.toString().padLeft(2, '0')} min';
  }
}
