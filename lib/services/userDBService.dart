import 'package:cible/database/userDBcontroller.dart';
import 'package:cible/providers/defaultUser.dart';
import 'package:provider/provider.dart';

dbupdateUser(context, user) async {
  List users = [];
  await UserDBcontroller().update(user);
  users = await UserDBcontroller().liste() as List;
  Provider.of<DefaultUserProvider>(context, listen: false)
      .fromDefaultUser(users[0]);
  return users;
}
