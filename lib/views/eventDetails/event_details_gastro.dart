import 'package:cible/helpers/textHelper.dart';
import 'package:cible/providers/appColorsProvider.dart';
import 'package:cible/providers/appManagerProvider.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class EventDetailsGastro extends StatefulWidget {
  const EventDetailsGastro({Key? key}) : super(key: key);

  @override
  _EventDetailsGastroState createState() => _EventDetailsGastroState();
}

class _EventDetailsGastroState extends State<EventDetailsGastro> {
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
              'Les entrées',
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
                  .gastronomieEntree,
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
              'Les plats de résistance',
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
                  .gastronomieResistance,
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
              'Les desserts',
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
                  .gastronomieDessert,
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
              'Les boissons',
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
                  .gastronomieBoisson,
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
