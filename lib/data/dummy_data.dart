import 'package:flutter/cupertino.dart';
import 'package:mindfullshelter/models/activity_model.dart';
import 'package:mindfullshelter/models/terms_conditions_model.dart';
import 'package:mindfullshelter/utils/app_assets.dart';

import '../models/mood_model.dart';

class DummyData {
  // static List<User> users = [
  //   User(
  //     id: '1',
  //     email: 'test@gmail.com',
  //     username: 'tester',
  //     password: '123456',
  //   ),
  // ];

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

  // static final List<Medication> medicines = [
  //   Medication(
  //     id: '1',
  //     name: 'Antiretroviral',
  //     time: DateTime.now().copyWith(hour: 8, minute: 0),
  //   ),
  //   Medication(
  //     id: '2',
  //     name: 'Protease Inhibitors',
  //     time: DateTime.now().copyWith(hour: 14, minute: 0),
  //   ),
  //   Medication(
  //     id: '3',
  //     name: 'Entry Inhibitors',
  //     time: DateTime.now().copyWith(hour: 19, minute: 0),
  //   ),
  // ];

  static final List<Mood> moods = [
    Mood(id: '1', emoji: Image.asset(icHappy), label: 'Senang'),
    Mood(id: '2', emoji: Image.asset(icCalm), label: 'Tenang'),
    Mood(id: '3', emoji: Image.asset(icNormal), label: 'Biasa'),
    Mood(id: '4', emoji: Image.asset(icSad), label: 'Sedih'),
    Mood(id: '5', emoji: Image.asset(icAnxious), label: 'Cemas'),
    Mood(id: '6', emoji: Image.asset(icTired), label: 'Lelah'),
  ];

  static final List<Activity> activity = [
    Activity(
      id: '1',
      title: 'Mendengarkan “Meditasi Penyembuhan”',
      date: DateTime.now(),
      icon: Image.asset(icAudio),
      color: Color(0xFFDCFFFB),
    ),
    Activity(
      id: '2',
      title: 'Bergabung di “Komunitas Anonim”',
      date: DateTime.now().subtract(Duration(days: 1)),
      icon: Image.asset(icComunity),
      color: Color(0xFFFFF7D2),
    ),
    Activity(
      id: '3',
      title: 'Membaca “Tips Kesehatan Mental”',
      date: DateTime.now().subtract(Duration(days: 2)),
      icon: Image.asset(icEducation),
      color: Color(0xFFFFE5F0),
    ),
  ];

  // static final List<AudioMindfulness> audioMindfulness = [
  //   AudioMindfulness(
  //     id: '1',
  //     title: 'Relaksasi Pagi Hari',
  //     description: 'Mulai hari dengan tenang dan penuh harapan',
  //     category: 'Relaksasi',
  //     duration: 300,
  //     audioUrl: 'assets/audio/relaksasi_pagi.mp3',
  //     thumbnailUrl: '🌅',
  //   ),
  //   AudioMindfulness(
  //     id: '2',
  //     title: 'Musik Menenangkan',
  //     description: 'Musik instrumental untuk ketenangan pikiran',
  //     category: 'Relaksasi',
  //     duration: 420,
  //     audioUrl: 'assets/audio/musik_tenang.mp3',
  //     thumbnailUrl: '🎵',
  //   ),
  //   AudioMindfulness(
  //     id: '3',
  //     title: 'Tidur Nyenyak',
  //     description: 'Musik untuk membantu tidur lebih berkualitas',
  //     category: 'Tidur',
  //     duration: 600,
  //     audioUrl: 'assets/audio/tidur_nyenyak.mp3',
  //     thumbnailUrl: '🌙',
  //   ),
  //   AudioMindfulness(
  //     id: '4',
  //     title: 'Meditasi Penyembuhan',
  //     description: 'Meditasi untuk inner peace dan penyembuhan',
  //     category: 'Meditasi',
  //     duration: 480,
  //     audioUrl: 'assets/audio/meditasi_penyembuhan.mp3',
  //     thumbnailUrl: '🧘',
  //   ),
  //   AudioMindfulness(
  //     id: '5',
  //     title: 'Bernapas dengan Tenang',
  //     description: 'Latihan pernapasan untuk menenangkan pikiran',
  //     category: 'Relaksasi',
  //     duration: 240,
  //     audioUrl: 'assets/audio/bernapas_tenang.mp3',
  //     thumbnailUrl: '🌬️',
  //   ),
  // ];

  // static final List<Chat> chatMessages = [
  //   Chat(
  //     id: '1',
  //     message: 'Halo! Aku Teman Hati. Ada yang bisa aku bantu hari ini?',
  //     isUser: false,
  //     timestamp: DateTime.now().subtract(Duration(minutes: 5)),
  //   ),
  // ];

  // static final List<AnonymousPost> anonymousPosts = [
  //   AnonymousPost(
  //     id: 'post_1',
  //     content:
  //         'Hari ini aku merasa lebih kuat. Dukungadari teman-teman di sini sangat membantu dalam perjalananku.',
  //     timestamp: DateTime.now().subtract(Duration(hours: 2)),
  //     likes: 12,
  //     commentsCount: 2,
  //     category: Category.mentalHealth,
  //   ),
  //   AnonymousPost(
  //     id: 'post_2',
  //     content:
  //         'Kadang aku merasa sendirian, tapi setelah bergabung dikomunitas ini, aku tahu aku tidak sendiri. Kita semua saling mendukung.',
  //     timestamp: DateTime.now().subtract(Duration(hours: 5)),
  //     likes: 25,
  //     commentsCount: 0,
  //     category: Category.sosial,
  //   ),
  // ];

  // static final List<AnonymousComment> anonymousComments = [
  //   AnonymousComment(
  //     id: 'c1',
  //     postId: 'post_1',
  //     content: 'Semangat terus ya!',
  //     timestamp: DateTime.now().subtract(Duration(minutes: 30)),
  //   ),
  //   AnonymousComment(
  //     id: 'c2',
  //     postId: 'post_1',
  //     content: 'Kita semua bangga padamu.',
  //     timestamp: DateTime.now().subtract(Duration(minutes: 15)),
  //   ),
  // ];

  // final List<Education> educations = [
  //   Education(
  //     type: EducationType.videoEducation,
  //     educationContent: [
  //       VideoEdu(
  //         id: '1',
  //         title: 'Memahami HIV/AIDS: Dasar-dasar yang Perlu Diketahui',
  //         description:
  //             'Video ini memberikan pemahaman yang lebih mendalam tentang topik dasar yang penting untuk dipelajari.\nMateri disusun oleh para ahli kesehatan dan disampaikan dengan cara yang mudah dipahami. Anda akan memperoleh informasi yang akurat dan dapat dipercaya.\nTonton video ini untuk memperluas pengetahuan Anda serta mendapatkan wawasan yang bermanfaat dalam perjalanan kesehatan Anda.',
  //         category: 'Dasar',
  //         thumbnail: Image.asset(thumbnail1),
  //         duration: 738,
  //         likes: 13,
  //       ),
  //       VideoEdu(
  //         id: '2',
  //         title: 'Menjaga Kesehatan Mental Sebagai Penyintas HIV',
  //         description:
  //             'Video ini memberikan pemahaman yang lebih mendalam tentang topik dasar yang penting untuk dipelajari.\n\nMateri disusun oleh para ahli kesehatan dan disampaikan dengan cara yang mudah dipahami. Anda akan memperoleh informasi yang akurat dan dapat dipercaya.\n\nTonton video ini untuk memperluas pengetahuan Anda serta mendapatkan wawasan yang bermanfaat dalam perjalanan kesehatan Anda.',
  //         category: 'Kesehatan Mental',
  //         thumbnail: Image.asset(thumbnail2),
  //         duration: 912,
  //         likes: 26,
  //       ),
  //       VideoEdu(
  //         id: '3',
  //         title: 'Hidup Produk dengan HIV: Tips dan Strategi',
  //         description:
  //             'Video ini memberikan pemahaman yang lebih mendalam tentang topik dasar yang penting untuk dipelajari.\n\nMateri disusun oleh para ahli kesehatan dan disampaikan dengan cara yang mudah dipahami. Anda akan memperoleh informasi yang akurat dan dapat dipercaya.\n\nTonton video ini untuk memperluas pengetahuan Anda serta mendapatkan wawasan yang bermanfaat dalam perjalanan kesehatan Anda.',
  //         category: 'Gaya Hidup',
  //         thumbnail: Image.asset(thumbnail3),
  //         duration: 627,
  //         likes: 11,
  //       ),
  //     ],
  //   ),
  //   Education(
  //     type: EducationType.articleEducation,
  //     educationContent: [
  //       ArticleEdu(
  //         id: '1',
  //         title: 'Stigma dan Diskriminasi: Cara Menghadapinya',
  //         description:
  //             'Panduan praktis untuk menghadapi stigma dalam kehidupan sehari-hari...\nDalam kehidupan sehari-hari, kita mungkin menghadapi berbagai tantangan. Artikel ini disusun untuk memberikan panduan praktis dan dukungan yang Anda butuhkan.\nSetiap orang memiliki perjalanan yang unik, dan penting untuk menemukan strategi yang paling sesuai dengan situasi Anda. Informasi yang kami bagikan di sini didasarkan pada penelitian terkini dan pengalaman praktis dari para ahli kesehatan mental.\nDengan memahami dan menerapkan informasi yang dibagikan, Anda dapat mengambil langkah positif menuju kesejahteraan yang lebih baik. Ingatlah bahwa Anda tidak sendirian dalam perjalanan ini.\nKomunitas VIDA Digital hadir untuk mendukung Anda setiap langkah dalam perjalanan menuju kesehatan dan kebahagiaan yang lebih baik.',
  //         importantNote:
  //             'Jangan ragu untuk mencari bantuan profesional ketika diperlukan. Kesehatan mental Anda sama pentingnya dengan kesehatan fisik.',
  //         category: 'Kesehatan Mental',
  //         duration: 300,
  //         date: DateTime.now().subtract(Duration(days: 1)),
  //         likes: 18,
  //       ),
  //       ArticleEdu(
  //         id: '2',
  //         title: 'Membangun Sistem Dukungan yang kuat',
  //         description:
  //             'Pentingnya memiliki jaringan dukungan dan cara membangunnya...\nDalam kehidupan sehari-hari, kita mungkin menghadapi berbagai tantangan. Artikel ini disusun untuk memberikan panduan praktis dan dukungan yang Anda butuhkan.\nSetiap orang memiliki perjalanan yang unik, dan penting untuk menemukan strategi yang paling sesuai dengan situasi Anda. Informasi yang kami bagikan di sini didasarkan pada penelitian terkini dan pengalaman praktis dari para ahli kesehatan mental.\nDengan memahami dan menerapkan informasi yang dibagikan, Anda dapat mengambil langkah positif menuju kesejahteraan yang lebih baik. Ingatlah bahwa Anda tidak sendirian dalam perjalanan ini.\nKomunitas VIDA Digital hadir untuk mendukung Anda setiap langkah dalam perjalanan menuju kesehatan dan kebahagiaan yang lebih baik.',
  //         importantNote:
  //             'Jangan ragu untuk mencari bantuan profesional ketika diperlukan. Kesehatan mental Anda sama pentingnya dengan kesehatan fisik.',
  //         category: 'Kesehatan Mental',
  //         duration: 420,
  //         date: DateTime.now().subtract(Duration(days: 1)),
  //         likes: 32,
  //       ),
  //       ArticleEdu(
  //         id: '3',
  //         title: 'Nutrisi dan Gaya Hidup Sehat',
  //         description:
  //             'Panduan nutrisi khusus untuk meningkatkan kualitas hidup...\nDalam kehidupan sehari-hari, kita mungkin menghadapi berbagai tantangan. Artikel ini disusun untuk memberikan panduan praktis dan dukungan yang Anda butuhkan.\nSetiap orang memiliki perjalanan yang unik, dan penting untuk menemukan strategi yang paling sesuai dengan situasi Anda. Informasi yang kami bagikan di sini didasarkan pada penelitian terkini dan pengalaman praktis dari para ahli kesehatan mental.\nDengan memahami dan menerapkan informasi yang dibagikan, Anda dapat mengambil langkah positif menuju kesejahteraan yang lebih baik. Ingatlah bahwa Anda tidak sendirian dalam perjalanan ini.\nKomunitas VIDA Digital hadir untuk mendukung Anda setiap langkah dalam perjalanan menuju kesehatan dan kebahagiaan yang lebih baik.',
  //         importantNote:
  //             'Jangan ragu untuk mencari bantuan profesional ketika diperlukan. Kesehatan mental Anda sama pentingnya dengan kesehatan fisik.',
  //         category: 'Dukungan',
  //         duration: 360,
  //         date: DateTime.now().subtract(Duration(days: 3)),
  //         likes: 11,
  //       ),
  //       ArticleEdu(
  //         id: '4',
  //         title: 'Mindfulness untuk Mengatasi Kecemasan',
  //         description:
  //             'Teknik mindfulness yang dapat membantu mengurangi kecemasan...\nDalam kehidupan sehari-hari, kita mungkin menghadapi berbagai tantangan. Artikel ini disusun untuk memberikan panduan praktis dan dukungan yang Anda butuhkan.\nSetiap orang memiliki perjalanan yang unik, dan penting untuk menemukan strategi yang paling sesuai dengan situasi Anda. Informasi yang kami bagikan di sini didasarkan pada penelitian terkini dan pengalaman praktis dari para ahli kesehatan mental.\nDengan memahami dan menerapkan informasi yang dibagikan, Anda dapat mengambil langkah positif menuju kesejahteraan yang lebih baik. Ingatlah bahwa Anda tidak sendirian dalam perjalanan ini.\nKomunitas VIDA Digital hadir untuk mendukung Anda setiap langkah dalam perjalanan menuju kesehatan dan kebahagiaan yang lebih baik.',
  //         importantNote:
  //             'Jangan ragu untuk mencari bantuan profesional ketika diperlukan. Kesehatan mental Anda sama pentingnya dengan kesehatan fisik.',
  //         category: 'Kesehatan Mental',
  //         duration: 240,
  //         date: DateTime.now().subtract(Duration(days: 4)),
  //         likes: 21,
  //       ),
  //       ArticleEdu(
  //         id: '5',
  //         title: 'Mengenal Hak-Hak Penyintas HIV/AIDS',
  //         description:
  //             'Informasi lengkap tentang hak-hak legal dan sosial...\nDalam kehidupan sehari-hari, kita mungkin menghadapi berbagai tantangan. Artikel ini disusun untuk memberikan panduan praktis dan dukungan yang Anda butuhkan.\nSetiap orang memiliki perjalanan yang unik, dan penting untuk menemukan strategi yang paling sesuai dengan situasi Anda. Informasi yang kami bagikan di sini didasarkan pada penelitian terkini dan pengalaman praktis dari para ahli kesehatan mental.\nDengan memahami dan menerapkan informasi yang dibagikan, Anda dapat mengambil langkah positif menuju kesejahteraan yang lebih baik. Ingatlah bahwa Anda tidak sendirian dalam perjalanan ini.\nKomunitas VIDA Digital hadir untuk mendukung Anda setiap langkah dalam perjalanan menuju kesehatan dan kebahagiaan yang lebih baik.',
  //         importantNote:
  //             'Jangan ragu untuk mencari bantuan profesional ketika diperlukan. Kesehatan mental Anda sama pentingnya dengan kesehatan fisik.',
  //         category: 'Lifestyle',
  //         duration: 480,
  //         date: DateTime.now().subtract(Duration(days: 7)),
  //         likes: 9,
  //       ),
  //     ],
  //   ),
  // ];

  static final Map<String, List<String>> botResponses = {
    'sedih': [
      'Aku mengerti kamu sedang merasa sedih. Tidak apa-apa untuk merasa sedih kadang-kadang. Mau cerita lebih lanjut?',
      'Sepertinya kamu sedang tidak baik-baik saja. Ingat, perasaan sedih itu normal dan akan berlalu. Aku di sini untuk mendengarkan',
    ],
    'senang': [
      'Wah, senang sekali mendengarnya! Apa yang membuat kamu senang hari ini?',
      'Keren! Terus semangat ya! Cerita dong apa yang membuat kamu bahagia!',
    ],
    'takut': [
      'Tidak apa-apa merasa takut. Semua orang pernah merasa takut. Mau coba tarik napas dalam-dalam bersama?',
      'Aku ada di sini bersamamu. Ketakutan akan berlalu. Kamu lebih kuat dari yang kamu kira!',
    ],
    'marah': [
      'Sepertinya ada yang membuatmu kesal. Coba tarik napas dalam-dalam dulu ya. Mau cerita apa yang terjadi?',
      'Marah itu wajar, tapi mari kita tenangkan diri dulu. Bagaimana kalau mencoba meditasi sebentar?',
    ],
    'default': [
      'Cerita lebih lanjut dong, aku siap mendengarkan!',
      'Hmm, menarik! Apa lagi yang ingin kamu ceritakan?',
      'Aku mengerti. Terus cerita ya, aku mendengarkan dengan seksama',
    ],
  };
}
