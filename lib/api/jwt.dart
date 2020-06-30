import 'package:jwt_decoder/jwt_decoder.dart';

class JwtVerify{
  bool isExpired(String token){
    if(JwtDecoder.isExpired(token)){
      return false;
    }
    return true;
  }
}