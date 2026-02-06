import 'package:flutter/foundation.dart';
import 'package:mindfullshelter/models/terms_conditions_model.dart';
import '../data/dummy_data.dart';

class TermsAndConditionsProvider with ChangeNotifier {
  final Map<TermsType, TermsAndConditions> _termsData = {
    TermsType.termsofService: DummyData.termsOfService,
    TermsType.privacyPolicy: DummyData.privacyPolicy,
  };

  TermsAndConditions getTerms(TermsType type) {
    return _termsData[type]!;
  }

  void toggleAgree(TermsType type) {
    _termsData[type]!.isAgree = !_termsData[type]!.isAgree;
    notifyListeners();
  }

  bool isAgreed(TermsType type) {
    return _termsData[type]!.isAgree;
  }
}
