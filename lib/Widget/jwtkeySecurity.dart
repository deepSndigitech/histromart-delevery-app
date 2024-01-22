import 'package:jaguar_jwt/jaguar_jwt.dart';

import '../Helper/constant.dart';

String getToken() {
  final claimSet = new JwtClaim(
    issuer: issuerName,
    maxAge: const Duration(minutes: 5),
  );

  String token = issueJwtHS256(claimSet, jwtKey);
  print("token : $token");
  return token;
}

Map<String, String> get headers => {
      "Authorization": 'Bearer ' + getToken(),
    };
