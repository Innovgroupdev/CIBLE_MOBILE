RegExp emailRegex = RegExp(r"^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$");

var telRegex = (String tel) {
  if (tel.isEmpty) {
    return true;
  } else if (tel.length < 5) {
    return true;
  } else {
    return false;
  }
};

RegExp passwordRegex = RegExp(r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).+$");
