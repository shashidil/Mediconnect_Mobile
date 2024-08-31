class SignupDto {
  final Map<String, dynamic>? signupRequestPatient;
  final Map<String, dynamic>? signupRequestPharmacist;

  SignupDto({this.signupRequestPatient, this.signupRequestPharmacist});

  Map<String, dynamic> toJson() {
    return {
      'signupRequestPatient': signupRequestPatient,
      'signupRequestPharmacist': signupRequestPharmacist,
    };
  }
}
