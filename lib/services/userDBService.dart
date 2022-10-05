import 'package:cible/database/userDBcontroller.dart';
import 'package:cible/providers/defaultUser.dart';
import 'package:provider/provider.dart';

dbupdateUser(context) async {
  List users = [];
  await UserDBcontroller().update(
      Provider.of<DefaultUserProvider>(context, listen: false)
          .toDefaulUserModel);
  users = await UserDBcontroller().liste() as List;
  Provider.of<DefaultUserProvider>(context, listen: false)
      .fromDefaultUser(users[0]);
  return users;
}