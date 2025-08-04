class LogingLog{
  String name = '';
  String mail = '';
  String password = '';
  bool loggedin = false;
  LogingLog({this.name = '', this.mail = '', this.password = '', this.loggedin = false});
  void printval(){
    print(this.name);
    print(this.mail);
    print(this.password);
    print(this.loggedin);
  }
  bool check(){
    bool ck = this.name != '' && this.mail != '' && this.password != '';
    return ck;
  }
}