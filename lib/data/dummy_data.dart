import 'package:flutter/cupertino.dart';
import 'package:mindfullshelter/models/terms_conditions_model.dart';
import 'package:mindfullshelter/utils/app_assets.dart';

import '../models/mood_model.dart';

class DummyData {
  static final TermsAndConditions termsOfService = TermsAndConditions(
    id: '1',
    type: TermsType.termsofService,
    lastUpdated: DateTime(2025, 11, 30),
    clauses: [
      Clause(
        title: '1. Clause 1',
        description:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Viverra condimentum eget purus in. Consectetur eget id morbi amet amet, in. Ipsum viverra pretium tellus neque. Ullamcorper suspendisse aenean leo pharetra in sit semper et. Amet quam placerat sem.',
      ),
      Clause(
        title: '2. Clause 2',
        description:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Viverra condimentum eget purus in. Consectetur eget id morbi amet amet, in. Ipsum viverra pretium tellus neque. Ullamcorper suspendisse aenean leo pharetra in sit semper et. Amet quam placerat sem.\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Viverra condimentum eget purus in. Consectetur eget id morbi amet amet, in. Ipsum viverra pretium tellus neque. Ullamcorper suspendisse aenean leo pharetra in sit semper et. Amet quam placerat sem.',
      ),
      Clause(
        title: '3. Clause 3',
        description:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Viverra condimentum eget purus in. Consectetur eget id morbi amet amet, in. Ipsum viverra pretium tellus neque. Ullamcorper suspendisse aenean leo pharetra in sit semper et. Amet quam placerat sem.\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Viverra condimentum eget purus in. Consectetur eget id morbi amet amet, in. Ipsum viverra pretium tellus neque. Ullamcorper suspendisse aenean leo pharetra in sit semper et. Amet quam placerat sem.',
      ),
    ],
  );

  static final TermsAndConditions privacyPolicy = TermsAndConditions(
    id: '1',
    type: TermsType.privacyPolicy,
    lastUpdated: DateTime(2025, 11, 30),
    clauses: [
      Clause(
        title: '1. Clause 1',
        description:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Viverra condimentum eget purus in. Consectetur eget id morbi amet amet, in. Ipsum viverra pretium tellus neque. Ullamcorper suspendisse aenean leo pharetra in sit semper et. Amet quam placerat sem.',
      ),
      Clause(
        title: '2. Clause 2',
        description:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Viverra condimentum eget purus in. Consectetur eget id morbi amet amet, in. Ipsum viverra pretium tellus neque. Ullamcorper suspendisse aenean leo pharetra in sit semper et. Amet quam placerat sem.\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Viverra condimentum eget purus in. Consectetur eget id morbi amet amet, in. Ipsum viverra pretium tellus neque. Ullamcorper suspendisse aenean leo pharetra in sit semper et. Amet quam placerat sem.',
      ),
      Clause(
        title: '3. Clause 3',
        description:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Viverra condimentum eget purus in. Consectetur eget id morbi amet amet, in. Ipsum viverra pretium tellus neque. Ullamcorper suspendisse aenean leo pharetra in sit semper et. Amet quam placerat sem.\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Viverra condimentum eget purus in. Consectetur eget id morbi amet amet, in. Ipsum viverra pretium tellus neque. Ullamcorper suspendisse aenean leo pharetra in sit semper et. Amet quam placerat sem.',
      ),
    ],
  );

  static final List<Mood> moods = [
    Mood(id: '6', emoji: Image.asset(icHappy), label: 'Senang'),
    Mood(id: '5', emoji: Image.asset(icCalm), label: 'Tenang'),
    Mood(id: '4', emoji: Image.asset(icNormal), label: 'Biasa'),
    Mood(id: '3', emoji: Image.asset(icTired), label: 'Lelah'),
    Mood(id: '2', emoji: Image.asset(icSad), label: 'Sedih'),
    Mood(id: '1', emoji: Image.asset(icAnxious), label: 'Cemas'),
  ];
}
