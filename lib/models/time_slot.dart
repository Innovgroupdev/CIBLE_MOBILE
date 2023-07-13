import 'package:cible/helpers/dateHelper.dart';
import 'package:flutter/material.dart';

class TimeSlotWithDate {
  String date;
  List<TimeRange> heures;

  TimeSlotWithDate({required this.date, required this.heures});

  factory TimeSlotWithDate.fromMap(Map map) {
    List heures = map['creneauhoraires'] ?? map['creneauxhoraires'] ?? [];
    var timeRange = TimeSlotWithDate(
      date: DateConvertisseur().convertDateFormatToEEEE(map['libelle']),
      heures: heures.map((e) => TimeRange.fromMap(e)).toList(),
    );
    return timeRange;
  }
}

class TimeRange {
  String heureDebut;
  String heureFin;

  TimeRange({required this.heureDebut, required this.heureFin});

  factory TimeRange.fromMap(Map map) {
    var timeRange = TimeRange(
      heureDebut: DateConvertisseur().convertTimeFromMap(map['heure_debut']),
      heureFin: DateConvertisseur().convertTimeFromMap(map['heure_fin']),
    );
    return timeRange;
  }
}

class ParticularTimeRange {
  String heureDebut;
  String heureFin;
  String date;
  String commentaire;

  ParticularTimeRange(
      {required this.date,
      required this.heureDebut,
      required this.heureFin,
      required this.commentaire});

  factory ParticularTimeRange.fromMap(Map map) {
    var particularTimeRange = ParticularTimeRange(
      date: map['date'] ?? '',
      heureDebut: DateConvertisseur().convertTimeFromMap(map['heure_debut']),
      heureFin: DateConvertisseur().convertTimeFromMap(map['heure_fin']),
      commentaire: map['commentaire'] ?? '',
    );
    return particularTimeRange;
  }
}

class TimeSlotWithoutDate {
  String heureDebut;
  String heureFin;

  TimeSlotWithoutDate({required this.heureDebut, required this.heureFin});

  factory TimeSlotWithoutDate.fromMap(Map map) {
    var timeSlotWithoutDate = TimeSlotWithoutDate(
      heureDebut: DateConvertisseur().convertTimeFromMap(map['heure_debut']),
      heureFin: DateConvertisseur().convertTimeFromMap(map['heure_fin']),
    );
    return timeSlotWithoutDate;
  }
}

class TimeSlotWithWeekDays {
  String day;
  List<TimeSlotWithoutDate> heures;

  TimeSlotWithWeekDays({required this.day, required this.heures});

  factory TimeSlotWithWeekDays.fromMap(Map map) {
    List heures = map['creneauhoraires'] ?? [];

    var timeSlotWithoutDate = TimeSlotWithWeekDays(
      day: map['libelle'],
      heures: heures.map((e) => TimeSlotWithoutDate.fromMap(e)).toList(),
    );
    return timeSlotWithoutDate;
  }
}
