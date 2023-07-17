import 'package:cible/helpers/textHelper.dart';
import 'package:cible/providers/appColorsProvider.dart';
import 'package:cible/providers/appManagerProvider.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class EventDetailsFormation extends StatefulWidget {
  const EventDetailsFormation({Key? key}) : super(key: key);

  @override
  _EventDetailsFormationState createState() => _EventDetailsFormationState();
}

class _EventDetailsFormationState extends State<EventDetailsFormation> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Notions à aborder',
              style: GoogleFonts.poppins(
                fontSize: AppText.p3(context),
                fontWeight: FontWeight.w800,
                color: AppColorProvider().black,
              ),
            ),
            const Gap(5),
            Text(
              Provider.of<AppManagerProvider>(context, listen: true)
                  .currentEvent
                  .notions,
              style: GoogleFonts.poppins(
                fontSize: AppText.p4(context),
                color: AppColorProvider().black87,
              ),
            ),
          ],
        ),
        const Gap(10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Savoir faire à acquérir',
              style: GoogleFonts.poppins(
                fontSize: AppText.p3(context),
                fontWeight: FontWeight.w800,
                color: AppColorProvider().black,
              ),
            ),
            const Gap(5),
            Text(
              Provider.of<AppManagerProvider>(context, listen: true)
                  .currentEvent
                  .savoirFaire,
              style: GoogleFonts.poppins(
                fontSize: AppText.p4(context),
                color: AppColorProvider().black87,
              ),
            ),
          ],
        ),
        const Gap(10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Méthodologie',
              style: GoogleFonts.poppins(
                fontSize: AppText.p3(context),
                fontWeight: FontWeight.w800,
                color: AppColorProvider().black,
              ),
            ),
            const Gap(5),
            Text(
              Provider.of<AppManagerProvider>(context, listen: true)
                  .currentEvent
                  .methodologie,
              style: GoogleFonts.poppins(
                fontSize: AppText.p4(context),
                color: AppColorProvider().black87,
              ),
            ),
          ],
        ),
        const Gap(10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Prérequis',
              style: GoogleFonts.poppins(
                fontSize: AppText.p3(context),
                fontWeight: FontWeight.w800,
                color: AppColorProvider().black,
              ),
            ),
            const Gap(5),
            Text(
              Provider.of<AppManagerProvider>(context, listen: true)
                  .currentEvent
                  .prerequis,
              style: GoogleFonts.poppins(
                fontSize: AppText.p4(context),
                color: AppColorProvider().black87,
              ),
            ),
          ],
        ),
        const Gap(10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Public cible',
              style: GoogleFonts.poppins(
                fontSize: AppText.p3(context),
                fontWeight: FontWeight.w800,
                color: AppColorProvider().black,
              ),
            ),
            const Gap(5),
            Text(
              Provider.of<AppManagerProvider>(context, listen: true)
                  .currentEvent
                  .publicCible,
              style: GoogleFonts.poppins(
                fontSize: AppText.p4(context),
                color: AppColorProvider().black87,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
