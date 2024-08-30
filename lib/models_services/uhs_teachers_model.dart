
import 'package:gsheets/gsheets.dart';

class UHSTeachersModel {
  static const _credentials = r'''
  {
    "type": "service_account",
    "project_id": "uhs-student-tools",
    "private_key_id": "4ed299cfa929d960e19ebbe198b3cfd42a4c8b99",
    "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQC55qvfRw7FCIh6\n/YhlWjpcWlasP3RAf59BN0ph50UAFqU4HWhR5amiFQm/o1Ea4gJ4rnlRI2Epy7+n\nqNpbrg4yBIeG6jHE5t76sYq8Q4jfXLrLpPU/Uzcvkjzpeurhu6nmZuABEDTPFNrU\n7ns1nlO9V0EgkvKVTqZvSCJetz93Fosyq5+XMI0pt528yiHKYYA4RCYzkf3J57fi\nYtqQALoynZEyyKbiNE04qz66/5PWIf7Rxfb9owEkR1tz7gXlhH3HTBehadglGCQm\nQBzr+l5dyrBpSxXxb4NK+v8xdsZqOWeYZ4qNIJvie/l4Re7UgFS9ZWFzj8DP3PyU\nWFCisQH3AgMBAAECggEACbahe7d6cGsjY8xu3bTa4HZ2mZDF4eoz3Ql8NnoKDe4g\n+zn2Ix6tQA3PW5cMptXxAR3vXYD2vmNUrqL7qIIDYIkCDSzxesisFUyaONS33cvk\n6r0XdL6ZXz/0iiflBp8dSoT3kWFSZmZAOj4CbBPLa6pCeebpC/TMbNDHvaE04g5R\nbFeQvzviVAkwvR772S8ngMgVlzzLPEZeqJLk/h+AIauhlGpEKC8zsQzk3g+ME4uE\nCttmAeg1Scdt1+bjXXpgl4VV38nCVTG6VBZoEm3p2OBsmNuKshQRSM9/wO7U3T+l\noeIaPg9jbRwsO2vzb24cbihvb7KUUt5rhGkZ2cHXcQKBgQD+ykznoHwrGS4JZKaN\nykw33p7XlvmPWX4fhjd7fqw3ckGj2XyqwoHZp2fjg/HVBSl/zM8O2K6ubzgXZrLQ\no7W3A+ZXoMVioSeWxarsxVuxzDqSG7dsvr1431EwjvZ851C3+p5H+A8PWgWw0IKS\n+Tzh6Sv63ri98nLVVCqZOkBamQKBgQC6yKK3wSFD185srHzq4frdv59/dIVOvHJy\nVjjcQ06cVMYKmeAQkvlB7vebSXaY4bKHEMS0KfjYB1DVNYWGBPK69X3RXL+DRkin\ndQMFrNA+XU+dnyDqCuQ6DRv40QHifMPwN+jMjOwocXdazWDP52iKG9p8rNx970a9\nDj4+W9QrDwKBgQCAI74Jv+yywDcnAjfBl7w9XPkF9CgOsDN+J0JAGbUDLbNVdEv+\nlVQ44ric8/7r42y7mYWJMfCoSccr/bpws+Tv5kYyS+j5cZM3gLI14gv7n3rVgJr/\nVe50m9t5UG0m5C70WFbCWz83uU6jXjpNMIwuEdbMlLbU0Npv76R8647yAQKBgQCY\nRQY6DS0ENMNo3rk7dpxf+F6bti8TABfA1D+oeQp18bo9XDJI8LhZIuoiYyJXAe/b\nojTptynRWy1vkyFWH2SOO6GlcxoBd+O0+HRNRRPDM6i7E8XuZpCmLpe2IRWLQTEu\n/TVAxEWlttKZaMLa2ojjxk84wmdCFzWw3BKsHYp6ywKBgEAWeviJNmSwXgxccCjG\nk2woThJ5EqXM5eHeKntYTluHSY25+G8t6UByfHYbqPp/vXZHvtbGRzqxYUUz5d19\n671I55vEN74libEaRE4LxIVLxXgOsw5DK3W0anQNnSItur4e5lCdYWXOM3LJlRih\nok62Sgog4kBFl8paE+qFQPNy\n-----END PRIVATE KEY-----\n",
    "client_email": "gsheet-api@uhs-student-tools.iam.gserviceaccount.com",
    "client_id": "109477291222665665516",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/gsheet-api%40uhs-student-tools.iam.gserviceaccount.com",
    "universe_domain": "googleapis.com"
  }
  ''';
  static int numTeachers = 0;
  static List<Map<String,String>> teachers = [];

  static const _spreadsheetId = '1h8FykeO8w03h7JLZqGPNo12bC7y_SSDUFNg2h7Ulx8A';
  static final _gsheets = GSheets(_credentials);
  static Worksheet? _worksheet;
  
  Future init() async {
    final ss = await _gsheets.spreadsheet(_spreadsheetId);
    _worksheet = ss.worksheetByTitle('Teachers');
    loadTeachers();
  }

  static Future loadTeachers() async {
    if (_worksheet == null) return;

    List<List<String>> teacherInfo = await _worksheet!.values.allColumns(fromColumn: 1);

    for (int i = 0; i < teacherInfo[0].length; i++) {
      teachers.add(<String, String>{});
      teachers[i]["First Name"] = teacherInfo[0][i];
      teachers[i]["Last Name"] = teacherInfo[1][i];
      teachers[i]["Departments"] = teacherInfo[2][i];
      teachers[i]["Email"] = teacherInfo[3][i];
      numTeachers++;
    }
  }
}