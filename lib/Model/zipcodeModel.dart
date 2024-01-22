import 'package:intl/intl.dart';
import '../Widget/parameterString.dart';

class Zipcode_Model {
  String? id,zipcode;

  Zipcode_Model(
      {this.id, this.zipcode});

  factory Zipcode_Model.fromJson(Map<String, dynamic> json) {

    return new Zipcode_Model(
        id: json[ID],
        zipcode: json[ZIPCODE],
        );
  }
}
