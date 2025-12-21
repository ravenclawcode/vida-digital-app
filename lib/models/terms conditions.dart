enum TermsType { termsofService, privacyPolicy }

class TermsAndConditions {
  final String id;
  final TermsType type;
  final DateTime lastUpdated;
  final List<Clause> clauses;
  bool isAgree;

  TermsAndConditions({
    required this.id,
    required this.type,
    required this.lastUpdated,
    required this.clauses,
    this.isAgree = false,
  });
}

class Clause {
  final String title;
  final String description;

  Clause({required this.title, required this.description});
}
