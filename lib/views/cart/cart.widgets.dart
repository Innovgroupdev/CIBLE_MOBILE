// Container(
//                         color: Colors.green,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Container(
//                               width: 30,
//                               decoration: BoxDecoration(
//                                 color: AppColorProvider().grey5,
//                                 shape: BoxShape.circle,
//                               ),
//                               child: IconButton(
//                                 icon: Icon(
//                                   Icons.remove,
//                                   size: AppText.p1(context),
//                                 ),
//                                 onPressed: () => setState(() {
//                                   final newValue = _currentValue - 1;
//                                   _currentValue = newValue.clamp(0, 100);
//                                 }),
//                               ),
//                             ),
//                             Gap(10),
//                             Text(
//                               '$_currentValue',
//                               style: GoogleFonts.poppins(
//                                 textStyle:
//                                     Theme.of(context).textTheme.bodyLarge,
//                                 fontSize: AppText.p1(context),
//                                 fontWeight: FontWeight.bold,
//                                 color: appColorProvider.black87,
//                               ),
//                             ),
//                             Gap(10),
//                             Container(
//                               width: 30,
//                               decoration: BoxDecoration(
//                                 color: AppColorProvider().grey5,
//                                 shape: BoxShape.circle,
//                               ),
//                               child: IconButton(
//                                 icon: Icon(
//                                   Icons.add,
//                                   size: AppText.p3(context),
//                                 ),
//                                 onPressed: () => setState(() {
//                                   final newValue = _currentValue + 1;
//                                   _currentValue = newValue.clamp(0, 100);
//                                 }),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),