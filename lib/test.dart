import 'package:flutter/material.dart';
import 'iq_test_page.dart';
import 'medha_ui.dart';
import 'profile.dart';
import 'services/user_service.dart';

class TestSelectionPage extends StatefulWidget {
  const TestSelectionPage({super.key});

  @override
  State<TestSelectionPage> createState() => _TestSelectionPageState();
}

class _TestSelectionPageState extends State<TestSelectionPage> {
  Future<void> _startIqTest() async {
    await UserService.initialize();

    final user = UserService.currentUser;
    final isAboveAllowedAge = user != null && user.age > 18;
    final hasSchool = user != null && user.schoolId != null && user.school.trim().isNotEmpty;

    if (!mounted) return;

    if (isAboveAllowedAge) {
      await _showAgeRestrictionDialog();
      return;
    }

    if (!hasSchool) {
      await showDialog<void>(
        context: context,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
          title: const Text('Complete Profile'),
          content: const Text(
            'Please enter or select your school name in Profile before starting the test.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'OK',
                style: TextStyle(color: MedhaColors.primary),
              ),
            ),
          ],
        ),
      );
      if (!mounted) return;
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const EditableProfilePage(startEditing: true),
        ),
      );
      return;
    }

    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const IqTestPage()),
    );
  }

  Future<void> _showAgeRestrictionDialog() {
    return showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
        contentPadding: const EdgeInsets.fromLTRB(24, 18, 24, 12),
        actionsPadding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
        title: Column(
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3E8),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFF4B183)),
              ),
              child: const Icon(
                Icons.info_outline_rounded,
                color: Color(0xFFE07A1F),
                size: 38,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'MMCT Age Limit',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: MedhaColors.text,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'The MMCT test is only for students who are 18 years old or younger.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                height: 1.5,
                color: MedhaColors.muted,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: MedhaColors.surfaceAlt,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: MedhaColors.border),
              ),
              child: const Text(
                'You are not eligible to give this test.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: MedhaColors.text,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.check_circle_outline_rounded,
              size: 18,
              color: MedhaColors.primary,
            ),
            label: const Text(
              'OK',
              style: TextStyle(
                color: MedhaColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tests = [
      {
        'title': 'MMCT',
        'subtitle': 'Medha Matrix Cognitive Test - Assess your cognitive abilities',
        'icon': Icons.lightbulb_outline_rounded,
      },
      {
        'title': 'Depression Scale',
        'subtitle': 'Evaluate your emotional well-being',
        'icon': Icons.sentiment_dissatisfied_outlined,
      },
      {
        'title': 'EQ',
        'subtitle': 'Measure your emotional intelligence',
        'icon': Icons.favorite_outline_rounded,
      },
      {
        'title': 'REBT',
        'subtitle': 'Rational emotive behavior therapy overview',
        'icon': Icons.psychology_alt_outlined,
      },
    ];

    return MedhaScaffold(
      appBar: const MedhaTopBar(title: 'Tests', subtitle: 'Choose your assessment'),
      child: MedhaPageView(
        children: [
          const MedhaHeroCard(
            title: 'Assessment Hub',
            subtitle: 'Start with MMCT or explore upcoming emotional wellness assessments.',
          ),
          const SizedBox(height: 18),
          ...tests.map((test) {
            final isIqTest = test['title'] == 'MMCT';
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: MedhaCard(
                padding: const EdgeInsets.all(14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    MedhaIconTile(icon: test['icon'] as IconData, size: 58, backgroundColor: MedhaColors.hero),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(test['title'] as String, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: MedhaColors.text)),
                          const SizedBox(height: 6),
                          Text(test['subtitle'] as String, style: const TextStyle(fontSize: 14, height: 1.3, color: MedhaColors.text)),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: () => _showInfo(context, test['title'] as String, test['subtitle'] as String),
                            style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(0, 32), tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                            child: const Text('More Info', style: TextStyle(color: MedhaColors.primary, fontWeight: FontWeight.w700)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 108,
                      child: MedhaPrimaryButton(
                        label: 'Start Test',
                        onPressed: () => isIqTest
                            ? _startIqTest()
                            : _showComingSoon(context, test['title'] as String),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  void _showInfo(BuildContext context, String title, String subtitle) {
    if (title == 'MMCT') {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
          title: const Text('MMCT'),
          content: const SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'MMCT stands for Medha Matrix Cognitive Test.',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: MedhaColors.text,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'What is MMCT?',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: MedhaColors.primary,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'MMCT is a standardized test that measures a person\'s intelligence, reasoning, memory, analytical skills, and problem-solving abilities.',
                ),
                SizedBox(height: 8),
                Text(
                  'Medha Matrix Cognitive Test (MMCT) is a test that evaluates the thinking, reasoning, and memory skills of students. With the help of this test, their intellectual abilities can be estimated. As a result, appropriate educational guidance, changes in study methods, and a clear strategy for career choice can be formulated. This test is useful for identifying talented students as well as helping students with special needs.',
                ),
                SizedBox(height: 14),
                Text(
                  'Importance of MMCT',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: MedhaColors.primary,
                  ),
                ),
                SizedBox(height: 8),
                Text('1. Identifying Intellectual Ability:\nMMCT helps to identify the level of intelligence of a person.'),
                SizedBox(height: 8),
                Text('2. Getting Right Guidance:\nMMCT helps students, parents or teachers to guide them in their further educational and professional development. It is possible to choose the right career according to the MMCT level.'),
                SizedBox(height: 8),
                Text('3. Understanding Learning Style & Speed:\nMMCT helps teachers and parents understand whether a student learns quickly or slowly, and what type of education is most beneficial for them.'),
                SizedBox(height: 8),
                Text('4. Identifying gifted or needy students:\nMMCT can help students with high intelligence to move to the next level, while students with low scores can be identified as needing special help.'),
                SizedBox(height: 8),
                Text('5. Enhances decision-making, thinking and logical ability:\nMMCT tests different aspects of thinking. This develops the logical thinking, observational skills and problem-solving skills of the candidates.'),
                SizedBox(height: 8),
                Text('6. Preparation for competitive exams:\nMany competitive exams ask questions of the type MMCT or Mental Ability. Giving an MMCT familiarizes students with that nature.'),
                SizedBox(height: 8),
                Text('7. Helping teachers and parents make the right decisions:\nBased on the MMCT report, teachers and parents can determine the child\'s learning difficulties, speed of progress, and the right direction of study.'),
                SizedBox(height: 16),
                Text(
                  'MMCT म्हणजे काय?',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: MedhaColors.primary,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'MMCT म्हणजे "Medha Matrix Cognitive Test". ही विद्यार्थ्यांची विचारशक्ती, तर्कशक्ती, स्मरणशक्ती, विश्लेषण क्षमता आणि समस्या सोडवण्याची क्षमता यांचे मूल्यमापन करणारी प्रमाणित चाचणी आहे.',
                ),
                SizedBox(height: 8),
                Text(
                  'Medha Matrix Cognitive Test (MMCT) ही विद्यार्थ्यांची विचारशक्ती, तर्कशक्ती, आणि स्मरणशक्ती यांचे मूल्यमापन करणारी चाचणी आहे. या चाचणीच्या मदतीने त्यांच्या बौद्धिक क्षमतेचा अंदाज घेता येतो. परिणामी, योग्य शैक्षणिक मार्गदर्शन, अभ्यास पद्धतीत बदल, आणि करिअर निवडीचे स्पष्ट धोरण तयार करता येते. ही चाचणी प्रतिभावान विद्यार्थी ओळखण्यासाठी तसेच विशेष गरजा असलेल्या विद्यार्थ्यांची मदत करण्यासाठी उपयुक्त आहे.',
                ),
                SizedBox(height: 14),
                Text(
                  'MMCT चे महत्त्व',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: MedhaColors.primary,
                  ),
                ),
                SizedBox(height: 8),
                Text('1. बौद्धिक क्षमता ओळखणे:\nMMCT मधून व्यक्तीची विचारशक्ती, समज, विश्लेषण, आणि समस्या सोडवण्याची क्षमता किती आहे हे समजते. ही चाचणी व्यक्तीचे बुद्धिमत्ता स्तर ओळखण्यास मदत करते.'),
                SizedBox(height: 8),
                Text('2. योग्य मार्गदर्शन मिळवणे:\nMMCT मुळे विद्यार्थी, पालक किंवा शिक्षक यांना पुढील शैक्षणिक आणि व्यावसायिक मार्गदर्शन करण्यास मदत होते. MMCT स्तरानुसार योग्य करिअर निवडणे शक्य होते.'),
                SizedBox(height: 8),
                Text('3. अभ्यास पद्धती आणि गती समजणे:\nMMCT चाचणीने समजते की विद्यार्थी जलद शिकतो की हळू, आणि त्याला कुठल्या प्रकारचे शिक्षण उपयुक्त आहे हे शिक्षक व पालक यांना समजते.'),
                SizedBox(height: 8),
                Text('4. प्रतिभावान किंवा मदतीची गरज असलेल्या विद्यार्थ्यांची ओळख:\nMMCT मुळे उच्च बौद्धिक क्षमता असलेल्या विद्यार्थ्यांना पुढील स्तरावर घेता येते, तर कमी स्कोअर असलेल्या विद्यार्थ्यांना विशेष मदतीची गरज ओळखता येते.'),
                SizedBox(height: 8),
                Text('5. निर्णय क्षमता, विचारपद्धती आणि तार्किक क्षमता वाढवणे:\nMMCT मध्ये विचार करण्याचे वेगवेगळे पैलू तपासले जातात. त्यामुळे परीक्षार्थींची तार्किक विचारशक्ती, निरीक्षण क्षमता आणि समस्यांवर उपाय शोधण्याची कला विकसित होते.'),
                SizedBox(height: 8),
                Text('6. स्पर्धा परीक्षांची पूर्वतयारी:\nबऱ्याच स्पर्धा परीक्षांमध्ये MMCT किंवा Mental Ability या प्रकारातील प्रश्न विचारले जातात. MMCT दिल्याने विद्यार्थ्यांना त्या स्वरूपाशी परिचय होतो.'),
                SizedBox(height: 8),
                Text('7. शिक्षक व पालक यांना योग्य निर्णय घेण्यास मदत:\nMMCT रिपोर्टच्या आधारे शिक्षक किंवा पालक मुलांच्या अभ्यासातील अडचणी, प्रगतीचा वेग, आणि अभ्यासाची योग्य दिशा ठरवू शकतात.'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close', style: TextStyle(color: MedhaColors.primary)),
            ),
          ],
        ),
      );
      return;
    }

    if (title == 'Depression Scale') {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
          title: const Text('Depression Scale'),
          content: const SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'What is a Depression Scale?',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: MedhaColors.primary,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'A depression scale is a psychological test used to assess mental health. It is used to determine whether a person is suffering from depression and its severity.',
                ),
                SizedBox(height: 14),
                Text(
                  'Purpose of the Depression Scale:',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: MedhaColors.primary,
                  ),
                ),
                SizedBox(height: 8),
                Text('To identify whether a person is experiencing symptoms of depression'),
                SizedBox(height: 8),
                Text('To determine whether the depression is mild, moderate or severe.'),
                SizedBox(height: 8),
                Text('To measure the difference before and after treatment.'),
                SizedBox(height: 8),
                Text('To guide mental health counselors and psychiatrists.'),
                SizedBox(height: 14),
                Text(
                  'When should the Depression Scale be used?',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: MedhaColors.primary,
                  ),
                ),
                SizedBox(height: 8),
                Text('If a person is feeling consistently depressed'),
                SizedBox(height: 8),
                Text('Changes in sleep, appetite, mood'),
                SizedBox(height: 8),
                Text('Loss of interest in studies/work'),
                SizedBox(height: 8),
                Text('Thoughts of suicide'),
                SizedBox(height: 14),
                Text(
                  'Who can use it?',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: MedhaColors.primary,
                  ),
                ),
                SizedBox(height: 8),
                Text('Psychiatrists'),
                SizedBox(height: 8),
                Text('Counselors'),
                SizedBox(height: 8),
                Text('Doctors'),
                SizedBox(height: 8),
                Text('Trained mental health workers'),
                SizedBox(height: 14),
                Text(
                  'Important Note:',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: MedhaColors.primary,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'This scale is a guide, not a definitive diagnostic test. If you get a high score, seek professional help from a mental health professional.',
                ),
                SizedBox(height: 16),
                Text(
                  'डिप्रेशन स्केल (Depression Scale) म्हणजे काय?',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: MedhaColors.primary,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'डिप्रेशन स्केल ही मानसिक आरोग्य तपासण्यासाठी वापरली जाणारी एक मानसशास्त्रीय चाचणी आहे. तिचा उपयोग व्यक्ती नैराश्य (depression) ग्रस्त आहे का, त्याचे प्रमाण किती आहे हे ओळखण्यासाठी केला जातो.',
                ),
                SizedBox(height: 14),
                Text(
                  'डिप्रेशन स्केल चा हेतू:',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: MedhaColors.primary,
                  ),
                ),
                SizedBox(height: 8),
                Text('व्यक्तीमध्ये नैराश्याचे लक्षणे आहेत का हे ओळखणे'),
                SizedBox(height: 8),
                Text('नैराश्य किती सौम्य, मध्यम की तीव्र स्वरूपाचे आहे हे ठरवणे'),
                SizedBox(height: 8),
                Text('उपचारपूर्वी आणि उपचारानंतरचा फरक मोजणे'),
                SizedBox(height: 8),
                Text('मानसिक आरोग्य सल्लागार, मानसोपचारतज्ज्ञांना मार्गदर्शन करण्यासाठी'),
                SizedBox(height: 14),
                Text(
                  'Depression Scale कधी वापरावी?',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: MedhaColors.primary,
                  ),
                ),
                SizedBox(height: 8),
                Text('जर व्यक्ती सतत उदास वाटत असेल'),
                SizedBox(height: 8),
                Text('झोप, भूक, मनःस्थितीतील बदल'),
                SizedBox(height: 8),
                Text('अभ्यास/कामात रस न वाटणे'),
                SizedBox(height: 8),
                Text('आत्महत्येचे विचार'),
                SizedBox(height: 14),
                Text(
                  'याचा वापर कोण करू शकतो?',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: MedhaColors.primary,
                  ),
                ),
                SizedBox(height: 8),
                Text('मानसोपचारतज्ज्ञ (Psychiatrists)'),
                SizedBox(height: 8),
                Text('समुपदेशक (Counselors)'),
                SizedBox(height: 8),
                Text('डॉक्टर'),
                SizedBox(height: 8),
                Text('प्रशिक्षित मानसिक आरोग्य कर्मचारी'),
                SizedBox(height: 14),
                Text(
                  'महत्त्वाची सूचना',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: MedhaColors.primary,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'ही स्केल सहाय्यक आहे, निदान करणारी अंतिम चाचणी नाही. उच्च स्कोअर आल्यास व्यावसायिक मानसोपचारतज्ज्ञाची मदत घ्या.',
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close', style: TextStyle(color: MedhaColors.primary)),
            ),
          ],
        ),
      );
      return;
    }

    if (title == 'EQ') {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
          title: const Text('EQ'),
          content: const SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'What is an EQ test?',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: MedhaColors.primary,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'An EQ test is a psychological test that measures a person\'s emotional intelligence. This intelligence gives us the ability to recognize, understand, control, and act appropriately on our own and others\' emotions.',
                ),
                SizedBox(height: 14),
                Text(
                  'Components of EQ (Emotional Quotient):',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: MedhaColors.primary,
                  ),
                ),
                SizedBox(height: 8),
                Text('There are 5 main components of EQ (according to Daniel Goleman):'),
                SizedBox(height: 8),
                Text('Self-awareness:\nKnowing how I am feeling right now.'),
                SizedBox(height: 8),
                Text('Self-regulation:\nControlling anger, stress, anxiety.'),
                SizedBox(height: 8),
                Text('Motivation:\nKeeping yourself motivated to work.'),
                SizedBox(height: 8),
                Text('Empathy:\nUnderstanding the feelings of others.'),
                SizedBox(height: 8),
                Text('Social Skills:\nMaintaining good relationships and communication with others.'),
                SizedBox(height: 14),
                Text(
                  'Why take an EQ test?',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: MedhaColors.primary,
                  ),
                ),
                SizedBox(height: 8),
                Text('To understand yourself better'),
                SizedBox(height: 8),
                Text('To increase emotional control'),
                SizedBox(height: 8),
                Text('To improve relationships'),
                SizedBox(height: 8),
                Text('For leadership and teamwork'),
                SizedBox(height: 8),
                Text('For guidance for students, teachers, counselors'),
                SizedBox(height: 8),
                Text('To maintain good mental health'),
                SizedBox(height: 14),
                Text(
                  'What is in an EQ test?',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: MedhaColors.primary,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'The EQ test asks many questions, which are based on your emotions, responses, and social interactions.',
                ),
                SizedBox(height: 14),
                Text(
                  'Who can take the EQ test?',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: MedhaColors.primary,
                  ),
                ),
                SizedBox(height: 8),
                Text('Students (10 years and above)'),
                SizedBox(height: 8),
                Text('Teachers, Parents'),
                SizedBox(height: 8),
                Text('Youth/Adults'),
                SizedBox(height: 8),
                Text('Mental Health Professionals'),
                SizedBox(height: 8),
                Text('Employees in Organizations'),
                SizedBox(height: 14),
                Text(
                  'Conclusion:',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: MedhaColors.primary,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'The EQ test is not just a test, it shows the path of emotional understanding, social skills, and self-development. In modern times, EQ is considered as important as IQ!',
                ),
                SizedBox(height: 16),
                Text(
                  'EQ टेस्ट म्हणजे काय?',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: MedhaColors.primary,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'EQ टेस्ट ही एक मानसिक चाचणी आहे जी व्यक्तीच्या भावनिक बुद्धिमत्ता (Emotional Intelligence) मोजते. ही बुद्धिमत्ता आपल्याला स्वतःच्या व इतरांच्या भावना ओळखण्याची, समजून घेण्याची, नियंत्रित करण्याची, आणि त्यावर योग्य कृती करण्याची क्षमता देते.',
                ),
                SizedBox(height: 14),
                Text(
                  'EQ (Emotional Quotient) चे घटक:',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: MedhaColors.primary,
                  ),
                ),
                SizedBox(height: 8),
                Text('EQ चे मुख्य 5 घटक असतात (Daniel Goleman च्या मते):'),
                SizedBox(height: 8),
                Text('Self-awareness (स्वतःच्या भावना ओळखणे):\nमी सध्या कसा वाटत आहे हे जाणून घेणे.'),
                SizedBox(height: 8),
                Text('Self-regulation (भावनांचे नियंत्रण):\nराग, तणाव, चिंता यावर नियंत्रण ठेवणे.'),
                SizedBox(height: 8),
                Text('Motivation (स्व-प्रेरणा):\nस्वतःला कार्यासाठी प्रेरित ठेवणे.'),
                SizedBox(height: 8),
                Text('Empathy (सहानुभूती):\nइतरांच्या भावना समजून घेणे.'),
                SizedBox(height: 8),
                Text('Social Skills (सामाजिक कौशल्ये):\nइतरांशी चांगले संबंध ठेवणे, संवाद साधणे.'),
                SizedBox(height: 14),
                Text(
                  'EQ टेस्ट का करावी?',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: MedhaColors.primary,
                  ),
                ),
                SizedBox(height: 8),
                Text('स्वतःला चांगल्या प्रकारे समजून घेण्यासाठी'),
                SizedBox(height: 8),
                Text('भावनिक नियंत्रण वाढवण्यासाठी'),
                SizedBox(height: 8),
                Text('नातेसंबंध सुधारण्यासाठी'),
                SizedBox(height: 8),
                Text('नेतृत्व क्षमता (Leadership) व टीमवर्कसाठी'),
                SizedBox(height: 8),
                Text('विद्यार्थी, शिक्षक, काउंसिलर यांना मार्गदर्शनासाठी'),
                SizedBox(height: 8),
                Text('मानसिक आरोग्य चांगले ठेवण्यासाठी'),
                SizedBox(height: 14),
                Text(
                  'EQ टेस्टमध्ये काय असते?',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: MedhaColors.primary,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'EQ टेस्टमध्ये अनेक प्रश्न विचारले जातात, जे तुमच्या भावना, प्रतिसाद, व सामाजिक संवाद यावर आधारित असतात.',
                ),
                SizedBox(height: 14),
                Text(
                  'EQ टेस्ट कोण करू शकतो?',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: MedhaColors.primary,
                  ),
                ),
                SizedBox(height: 8),
                Text('विद्यार्थी (10 वर्षांपासून पुढे)'),
                SizedBox(height: 8),
                Text('शिक्षक, पालक'),
                SizedBox(height: 8),
                Text('युवक/प्रौढ'),
                SizedBox(height: 8),
                Text('मानसिक आरोग्य तज्ज्ञ'),
                SizedBox(height: 8),
                Text('संघटनांतील कर्मचारी'),
                SizedBox(height: 14),
                Text(
                  'निष्कर्ष:',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: MedhaColors.primary,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'EQ टेस्ट केवळ एक चाचणी नसून, ती भावनिक समज, सामाजिक कौशल्य, आणि स्वविकासाचा मार्ग दर्शवते. आधुनिक काळात EQ हे IQ इतकेच महत्त्वाचे मानले जाते!',
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close', style: TextStyle(color: MedhaColors.primary)),
            ),
          ],
        ),
      );
      return;
    }

    if (title == 'REBT') {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
          title: const Text('REBT'),
          content: const SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'What is the REBT test?',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: MedhaColors.primary,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'The REBT test is a psychological test that detects irrational or unrealistic elements in a person\'s thinking, feelings, and behavior.',
                ),
                SizedBox(height: 8),
                Text(
                  'The test is based on the theory of Rational Emotive Behavior Therapy (REBT) by renowned psychiatrist Dr. Albert Ellis.',
                ),
                SizedBox(height: 14),
                Text(
                  'REBT believes that:',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: MedhaColors.primary,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '"It\'s not the events that bother us, but the thoughts we have about those events that bother us."',
                ),
                SizedBox(height: 14),
                Text(
                  'The main purpose of the REBT test:',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: MedhaColors.primary,
                  ),
                ),
                SizedBox(height: 8),
                Text('To discover a person\'s false or unrealistic beliefs'),
                SizedBox(height: 8),
                Text('To identify the emotional distress or abuse that those thoughts cause'),
                SizedBox(height: 8),
                Text('To teach positive behavior by making logical changes to those thoughts'),
                SizedBox(height: 14),
                Text(
                  'Who is this test useful for?',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: MedhaColors.primary,
                  ),
                ),
                SizedBox(height: 8),
                Text('Students above 12 years'),
                SizedBox(height: 8),
                Text('Youth and adults with stress, anxiety, self-confidence issues'),
                SizedBox(height: 8),
                Text('Teachers/Parents to understand the mental health of students'),
                SizedBox(height: 8),
                Text('Counselors/Therapists for assessment before starting therapy'),
                SizedBox(height: 14),
                Text(
                  'Why take the REBT test?',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: MedhaColors.primary,
                  ),
                ),
                SizedBox(height: 8),
                Text('Becomes aware of your own negative thoughts'),
                SizedBox(height: 8),
                Text('Develops emotional balance and logical thinking'),
                SizedBox(height: 8),
                Text('Corrects false beliefs'),
                SizedBox(height: 8),
                Text('Increases self-confidence and self-control'),
                SizedBox(height: 16),
                Text(
                  'REBT टेस्ट म्हणजे काय?',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: MedhaColors.primary,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'REBT टेस्ट ही एक मानसशास्त्रीय चाचणी आहे जी व्यक्तीच्या विचारपद्धती, भावना आणि वागणुकीतील गैरवाजवी किंवा अवास्तव घटक शोधून काढते.',
                ),
                SizedBox(height: 8),
                Text(
                  'ही चाचणी प्रसिद्ध मानसोपचारतज्ज्ञ डॉ. अल्बर्ट एलिस यांच्या Rational Emotive Behavior Therapy (REBT) या थेरपीच्या सिद्धांतावर आधारित आहे.',
                ),
                SizedBox(height: 14),
                Text(
                  'REBT असं मानते की:',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: MedhaColors.primary,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '"आपल्याला त्रास घटना देत नाहीत, तर त्या घटनांबाबत आपण केलेले विचार आपल्याला त्रास देतात."',
                ),
                SizedBox(height: 14),
                Text(
                  'REBT टेस्टचा मुख्य उद्देश:',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: MedhaColors.primary,
                  ),
                ),
                SizedBox(height: 8),
                Text('व्यक्तीच्या चुकीच्या किंवा अवास्तव विश्वासांचा शोध घेणे'),
                SizedBox(height: 8),
                Text('त्या विचारांमुळे निर्माण होणारे भावनिक त्रास किंवा गैरवर्तन ओळखणे'),
                SizedBox(height: 8),
                Text('त्या विचारांमध्ये तार्किक बदल घडवून सकारात्मक वर्तन शिकवणे'),
                SizedBox(height: 14),
                Text(
                  'ही टेस्ट कोणासाठी उपयुक्त आहे?',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: MedhaColors.primary,
                  ),
                ),
                SizedBox(height: 8),
                Text('१२ वर्षांवरील विद्यार्थी'),
                SizedBox(height: 8),
                Text('युवक व प्रौढ – तणाव, चिंता, आत्मविश्वासाच्या समस्या असलेले'),
                SizedBox(height: 8),
                Text('शिक्षक/पालक – विद्यार्थ्यांचे मानसिक आरोग्य समजून घेण्यासाठी'),
                SizedBox(height: 8),
                Text('समुपदेशक/थेरपिस्ट्स – थेरपी सुरू करण्यापूर्वी मूल्यमापनासाठी'),
                SizedBox(height: 14),
                Text(
                  'REBT टेस्ट का करावी?',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: MedhaColors.primary,
                  ),
                ),
                SizedBox(height: 8),
                Text('स्वतःच्या नकारात्मक विचारांची जाणीव होते'),
                SizedBox(height: 8),
                Text('भावनिक समतोल आणि तार्किक विचार विकसित होतो'),
                SizedBox(height: 8),
                Text('चुकीच्या विश्वासांची दुरुस्ती होते'),
                SizedBox(height: 8),
                Text('आत्मविश्वास आणि आत्मनियंत्रण वाढते.'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close', style: TextStyle(color: MedhaColors.primary)),
            ),
          ],
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: Text(title),
        content: Text('$subtitle\n\nThis assessment helps guide the next step in your MedhaMatrix journey.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close', style: TextStyle(color: MedhaColors.primary)),
          ),
        ],
      ),
    );
  }

  void _showComingSoon(BuildContext context, String title) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
        contentPadding: const EdgeInsets.fromLTRB(24, 18, 24, 8),
        actionsPadding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
        title: Column(
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: MedhaColors.hero,
                shape: BoxShape.circle,
                border: Border.all(color: MedhaColors.primary.withOpacity(0.18)),
              ),
              child: const Icon(
                Icons.auto_awesome_rounded,
                color: MedhaColors.primary,
                size: 34,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Coming Soon',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: MedhaColors.text,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 15,
                  height: 1.5,
                  color: MedhaColors.muted,
                ),
                children: [
                  const TextSpan(text: 'The '),
                  TextSpan(
                    text: title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: MedhaColors.text,
                    ),
                  ),
                  const TextSpan(
                    text: ' assessment is in progress and will be available soon.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: MedhaColors.surfaceAlt,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: MedhaColors.border),
              ),
              child: const Text(
                'You can start MMCT right now while we prepare the remaining assessments.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  fontWeight: FontWeight.w600,
                  color: MedhaColors.text,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close_rounded, size: 18, color: MedhaColors.primary),
            label: const Text(
              'Close',
              style: TextStyle(
                color: MedhaColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
