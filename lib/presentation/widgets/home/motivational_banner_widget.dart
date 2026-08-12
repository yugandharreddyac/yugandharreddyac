import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class MotivationalBannerWidget extends StatefulWidget {
  const MotivationalBannerWidget({super.key});

  // Statically select ONE quote per app session so it remains static until restart
  static final String _sessionQuote = _getRandomQuote();

  static String _getRandomQuote() {
    final random = Random();
    return _allQuotes[random.nextInt(_allQuotes.length)];
  }

  @override
  State<MotivationalBannerWidget> createState() => _MotivationalBannerWidgetState();
}

class _MotivationalBannerWidgetState extends State<MotivationalBannerWidget> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      height: 46,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [
                  Colors.white.withAlpha(35),
                  Colors.white.withAlpha(15),
                ]
              : [
                  Colors.white.withAlpha(45),
                  Colors.white.withAlpha(20),
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withAlpha(60),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 20 : 10),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.auto_awesome_rounded,
            color: Colors.amberAccent,
            size: 17,
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              MotivationalBannerWidget._sessionQuote,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms, curve: Curves.easeOut);
  }
}

/// Comprehensive pool of English, Telugu, and Hindi motivational quotes
const List<String> _allQuotes = [
  // --- ENGLISH QUOTES ---
  'Learn today, lead tomorrow.',
  'Every chapter brings you closer to success.',
  'Small steps create big achievements.',
  'Stay curious. Keep learning.',
  'Knowledge is your greatest investment.',
  'Consistency creates excellence.',
  'Success begins with one lesson.',
  'Learn with purpose, grow with confidence.',
  'Dream big, study smart.',
  'Every expert started as a student.',
  'Progress is made one topic at a time.',
  'Believe in your potential.',
  'Study hard, achieve greatness.',
  'Your future is built by today\'s learning.',
  'Great minds never stop learning.',
  'Turn your efforts into achievements.',
  'One concept today, endless opportunities tomorrow.',
  'Excellence is earned through practice.',
  'Keep learning, keep growing.',
  'Education opens every door.',
  'Every expert was once a beginner.',
  'Knowledge is the key to every opportunity.',
  'Small progress is still progress.',
  'One lesson today, endless possibilities tomorrow.',
  'Success starts with consistent learning.',
  'Every chapter brings you closer to your dreams.',
  'Great things begin with a single concept.',
  'Learn with passion, achieve with confidence.',
  'Build your future, one subject at a time.',
  'Education empowers every dream.',
  'Think. Learn. Grow.',
  'Your future is shaped by today\'s efforts.',
  'Every page you read builds your future.',
  'Learn something new every day.',
  'Smart work begins with smart learning.',
  'Believe in your ability to learn.',
  'Progress beats perfection.',
  'Study smart, succeed faster.',
  'Every question answered is a step forward.',
  'Keep learning. Keep improving.',
  'Knowledge grows when shared.',
  'Learning never goes out of style.',
  'Your dedication defines your destination.',
  'Success is earned, not given.',
  'Learning is your superpower.',
  'Dream big. Learn bigger.',
  'Excellence begins with curiosity.',
  'Every achievement starts with education.',
  'Stay focused. Stay determined.',
  'Every concept mastered is a victory.',
  'Learning today creates opportunities tomorrow.',
  'Confidence comes from preparation.',
  'Your effort today is your success tomorrow.',
  'Every hour of study is an investment.',
  'Curiosity is the first step to innovation.',
  'Learn deeply, achieve greatly.',
  'A strong foundation builds a bright future.',
  'Keep moving, keep growing.',
  'Every milestone starts with a first step.',
  'Success belongs to those who never stop learning.',
  'Education is the bridge to success.',
  'Your potential has no limits.',
  'Turn knowledge into wisdom.',
  'Learn continuously, grow endlessly.',
  'Every challenge is a chance to learn.',
  'Today\'s learning shapes tomorrow\'s success.',

  // --- TELUGU QUOTES (తెలుగు) ---
  'విద్యే నిజమైన సంపద.',
  'ఈ రోజు చదువు, రేపు నాయకత్వం వహించు.',
  'ప్రతి రోజు ఒక కొత్త విషయం నేర్చుకో.',
  'జ్ఞానం ఎప్పటికీ నీతోనే ఉంటుంది.',
  'కష్టపడితే విజయం నీదే.',
  'చదువు భవిష్యత్తుకు బలమైన పునాది.',
  'కలలను నిజం చేసేది విద్య.',
  'నేర్చుకోవడం ఎప్పుడూ ఆపొద్దు.',
  'విజయం సాధించాలంటే పట్టుదల అవసరం.',
  'ప్రతి పాఠం ఒక కొత్త అవకాశం.',
  'జ్ఞానం విజయానికి తొలి అడుగు.',
  'చదువే నీ భవిష్యత్తుకు మార్గం.',
  'ప్రతి రోజు నేర్చుకోవడం ఒక విజయం.',
  'శ్రమించినవారికే ఫలితం లభిస్తుంది.',
  'లక్ష్యాన్ని చేరే వరకు ఆగొద్దు.',
  'విజయం నీ కష్టానికి ప్రతిఫలం.',
  'ప్రతి సమస్య ఒక కొత్త పాఠం.',
  'మంచి ఆలోచనలు గొప్ప విజయాలకు దారి తీస్తాయి.',
  'విద్య మనిషిని ఉన్నత స్థాయికి తీసుకెళ్తుంది.',
  'కలలు కనండి... వాటిని నిజం చేసుకోండి.',

  // --- HINDI QUOTES (हिन्दी) ---
  'ज्ञान सबसे बड़ी शक्ति है।',
  'हर दिन कुछ नया सीखो।',
  'मेहनत सफलता की पहली सीढ़ी है।',
  'शिक्षा जीवन की सबसे बड़ी पूंजी है।',
  'सीखना कभी मत छोड़ो।',
  'आज की मेहनत कल की सफलता है।',
  'सपने वही पूरे होते हैं जो मेहनत करते हैं।',
  'हर अध्याय सफलता की ओर एक कदम है।',
  'सीखते रहो, आगे बढ़ते रहो।',
  'शिक्षा सफलता की कुंजी है।',
  'सफलता मेहनत का परिणाम है।',
  'हर दिन बेहतर बनने का अवसर है।',
  'सीखना जीवन भर की यात्रा है।',
  'आत्मविश्वास सफलता की शुरुआत है।',
  'अपने सपनों पर विश्वास रखो।',
  'निरंतर प्रयास ही असली जीत है।',
  'हर चुनौती एक नया अवसर है।',
  'मेहनत कभी व्यर्थ नहीं जाती।',
  'ज्ञान सफलता का सबसे मजबूत आधार है।',
  'आगे बढ़ते रहो, कभी हार मत मानो।',
];
