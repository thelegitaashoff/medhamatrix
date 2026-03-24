import 'package:flutter/material.dart';
import 'doctor.dart';
import 'medha_ui.dart';

class TeamPage extends StatelessWidget {
  TeamPage({super.key});

  final List<Doctor> doctors = [
    Doctor(
      name: 'Dr. Sujay Patil',
      specialty: 'Consultant Psychiatrist',
      imageUrl: 'assets/team/Dr.Sujay_Patil.png',
      education: [
        'MBBS: Government Medical College, Nagpur - 1993',
        'Postgraduate Diploma in Psychological Medicine (DPM): G.S. Medical College & K.E.M. Hospital, Mumbai - 1997',
        'Assistant Lecturer: Government Medical College, Nagpur (1997-1999)',
      ],
      experience: [
        'Started private psychiatric practice in Akola in 1999',
        'Over two decades of experience in treating mental health conditions and providing counseling',
        'Honored for dedicated service to farmers and underprivileged patients',
        'Private practice in Akola since 1999',
      ],
      skills: [
        'M.B.B.S. (Nagpur), D.P.M. (Mumbai)',
        'Expert in psychiatric treatment and psychological counseling',
        'Specialized care for farmers and underprivileged communities',
        'Over 25 years of medical practice experience',
        'Committed to accessible mental healthcare',
      ],
      roleDescription:
          'Dr. Sujay Patil is our lead Consultant Psychiatrist with over 25 years of dedicated service in mental health and community care.',
      socialContributions: [
        'Former Member - Child Rights Committee',
        'Former Member - State Educational Committee, Government of Maharashtra',
      ],
    ),
    Doctor(
      name: 'Dr. Harshavardhan Malokar',
      specialty: 'Consultant Obstetrician',
      imageUrl: 'assets/team/Dr.Harshavardhan_Malokar.png',
      education: [
        'MBBS (1991)',
        'DGO - Diploma in Gynaecology and Obstetrics (1994)',
        'MD - Obstetrics & Gynaecology (1998)',
      ],
      experience: [
        'Practicing in Akola since 1999',
        'Over 25 years of dedicated practice in women\'s healthcare',
        'Offering compassionate care throughout pregnancy and motherhood',
        'Specialized expertise in obstetrics and gynaecology',
      ],
      skills: [
        'Expert in obstetrics and gynaecological care',
        'Compassionate approach to women\'s healthcare',
        '25+ years of clinical experience',
        'Accomplished medical author and educator',
      ],
      roleDescription:
          'Dr. Harshavardhan Malokar is a highly respected Consultant Obstetrician & Gynaecologist with decades of experience.',
      socialContributions: [
        "Author of 'Prasooticha Pravas' (The Journey of Pregnancy)",
        'Contributing to practical guidance for pregnancy and childbirth',
      ],
    ),
    Doctor(
      name: 'Smita Pande',
      specialty: 'Counselor',
      imageUrl: 'assets/team/Smita_Pande.png',
      education: [
        'B.A.: YCMOU, Nashik - 2017',
        'M.A. (Psychology): Sant Gadge Baba Amravati University - 2021',
        'CCYN (Counseling Course): Mumbai - 2023',
      ],
      experience: [
        'Working as a Counselor for the past 7 years',
        'Assistant Professor at Shivaji College, Akola for 1 year',
        'Specializes in emotional counseling and student guidance',
      ],
      skills: [
        'Dedicated and responsible approach',
        'Strong communication skills',
        'Team-oriented mindset',
        'Positive and empathetic attitude',
      ],
      roleDescription:
          'Smita Pande supports students with psychological, emotional, and academic guidance backed by teaching and counseling experience.',
    ),
    Doctor(
      name: 'Mr. Ashish Patil',
      specialty: 'Counselor',
      imageUrl: 'assets/team/Mr.Ashish_Patil.png',
      education: [
        'D.Ed: Government College of Education, Akola',
        'B.Sc: Mahatma Phule Science College, Sangrampur',
        'M.A (Counselling & Psychotherapy): Sant Gadge Baba Amravati University',
      ],
      experience: [
        '3 years of counseling experience at Patil Hospital',
        '2 years of teaching experience',
        'Experienced in mental health and educational guidance',
      ],
      skills: [
        'Expert in counselling and psychotherapy',
        'Strong background in education and student development',
        'Experienced in individual and group counseling sessions',
      ],
      roleDescription:
          'Mr. Ashish Patil provides individual, academic, and emotional counseling for students and families.',
      socialContributions: [
        'Conducts guidance sessions for parents and teachers',
        'Organizes mental health awareness programs',
      ],
    ),
    Doctor(
      name: 'Pooja Gajanan Kanoje',
      specialty: 'Counselor',
      imageUrl: 'assets/team/Mrs Pooja wankhade.png',
      education: [
        'B.A. (Psychology): Indirabai Meghe Mahila Mahavidyalaya, Amravati - 2018',
        'M.A. (Psychology): VMV College, Amravati - 2020',
        'Post Graduate Diploma in Psychological Counseling - 2022',
      ],
      experience: [
        'Currently working as a Counselor at Patil Hospital, Akola',
        'Skilled in psychological counseling with empathy and understanding',
        'Known as a strong communicator who helps patients open up freely',
      ],
      skills: [
        'Quick learner and cooperative team member',
        'Committed to patient care and mental wellness',
        'Creative problem-solving abilities',
      ],
      roleDescription:
          'Ms. Pooja Kanoje offers emotional, academic, and psychological guidance to students while supporting parents and educators.',
    ),
    Doctor(
      name: 'Rasika Palkar',
      specialty: 'Counselor & Psychotherapist',
      imageUrl: 'assets/team/Rasika_Palkar.png',
      education: [
        'M.A. in Psychology: Shivaji College, Akola',
        'Sant Gadge Baba Amravati University (2017 to 2019)',
        'Graduated in 2020',
      ],
      experience: [
        'Counselor & Psychotherapist at Patil Hospital, Akola (March 2020 - Present)',
        '5 years of professional experience in counseling and psychotherapy',
        'Provides individual and family counseling',
        'Conducts psychological assessments and therapy sessions',
      ],
      skills: [
        'Effective communication and empathy',
        'Emotional intelligence',
        'Problem-solving and adaptability',
        'Crisis intervention and client-centered care',
      ],
      roleDescription:
          'Ms. Rasika Palkar is an integral part of our mental wellness team, supporting students, parents, and teachers.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return MedhaScaffold(
      appBar: const MedhaTopBar(title: 'Our Team', subtitle: 'Meet the experts behind MedhaMatrix'),
      child: MedhaPageView(
        children: [
          const MedhaHeroCard(
            leading: MedhaIconTile(icon: Icons.groups_2_outlined, size: 74, backgroundColor: Colors.white),
            title: 'Meet Our Expert Team',
            subtitle: 'Dedicated professionals committed to student growth, guidance, and well-being.',
          ),
          const SizedBox(height: 18),
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final crossAxisCount = width > 980
                  ? 3
                  : width > 680
                      ? 2
                      : 1;
              final aspectRatio = width > 980
                  ? 1.05
                  : width > 680
                      ? 0.96
                      : 1.35;

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: doctors.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: aspectRatio,
                ),
                itemBuilder: (context, index) => DoctorCard(doctor: doctors[index]),
              );
            },
          ),
        ],
      ),
    );
  }
}

class DoctorCard extends StatelessWidget {
  final Doctor doctor;

  const DoctorCard({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(26),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => DoctorDetailPage(doctor: doctor)),
        );
      },
      child: MedhaCard(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: MedhaColors.heroStrong, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: MedhaColors.primary.withOpacity(0.10),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.asset(
                  doctor.imageUrl,
                  width: 92,
                  height: 92,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 92,
                    height: 92,
                    color: MedhaColors.surfaceAlt,
                    child: const Icon(Icons.person_outline_rounded, size: 44, color: MedhaColors.muted),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              doctor.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: MedhaColors.text),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: MedhaColors.hero.withOpacity(0.65),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                doctor.specialty,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: MedhaColors.primary),
              ),
            ),
            if (doctor.additionalInfo != null) ...[
              const SizedBox(height: 10),
              Text(
                doctor.additionalInfo!,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 13, color: MedhaColors.muted),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class DoctorDetailPage extends StatelessWidget {
  final Doctor doctor;

  const DoctorDetailPage({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return MedhaScaffold(
      appBar: MedhaTopBar(title: doctor.name, subtitle: doctor.specialty),
      child: MedhaPageView(
        children: [
          MedhaCard(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: MedhaColors.heroStrong, width: 4),
                    boxShadow: [
                      BoxShadow(
                        color: MedhaColors.primary.withOpacity(0.12),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      doctor.imageUrl,
                      width: 132,
                      height: 132,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 132,
                        height: 132,
                        color: MedhaColors.surfaceAlt,
                        child: const Icon(Icons.person_outline_rounded, size: 62, color: MedhaColors.muted),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  doctor.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: MedhaColors.text),
                ),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  decoration: BoxDecoration(
                    color: MedhaColors.hero.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    doctor.specialty,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: MedhaColors.primary),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          if (doctor.roleDescription != null)
            _buildInfoCard('Role in Our Team', [doctor.roleDescription!], Colors.green),
          if (doctor.education != null && doctor.education!.isNotEmpty)
            _buildInfoCard('Educational Qualifications', doctor.education!, Colors.blue),
          if (doctor.experience != null && doctor.experience!.isNotEmpty)
            _buildInfoCard('Professional Experience', doctor.experience!, Colors.orange),
          if (doctor.skills != null && doctor.skills!.isNotEmpty)
            _buildInfoCard('Personality Highlights', doctor.skills!, Colors.purple),
          if (doctor.socialContributions != null && doctor.socialContributions!.isNotEmpty)
            _buildInfoCard('Social Contributions', doctor.socialContributions!, Colors.amber),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, List<String> items, Color accentColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: MedhaCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 4,
                  height: 24,
                  decoration: BoxDecoration(color: accentColor, borderRadius: BorderRadius.circular(2)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800, color: MedhaColors.text),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            ...items.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 7),
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(color: accentColor.withOpacity(0.8), shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        item,
                        style: const TextStyle(fontSize: 15, height: 1.5, color: MedhaColors.muted),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
