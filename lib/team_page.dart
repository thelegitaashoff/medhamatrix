import 'package:flutter/material.dart';
import 'doctor.dart';

class TeamPage extends StatelessWidget {
  final List<Doctor> doctors = [
    Doctor(
      name: "Dr. Sujay Patil",
      specialty: "Consultant Psychiatrist",
      imageUrl: "assets/team/Dr.Sujay_Patil.png",
      education: [
        "MBBS: Government Medical College, Nagpur – 1993",
        "Postgraduate Diploma in Psychological Medicine (DPM): G.S. Medical College & K.E.M. Hospital, Mumbai – 1997",
        "Assistant Lecturer: Government Medical College, Nagpur (1997–1999)"
      ],
      experience: [
        "Started private psychiatric practice in Akola in 1999",
        "Over two decades of experience in treating various mental health conditions and providing psychological counseling",
        "Honored for dedicated service to farmers and underprivileged patients",
        "Private Practice in Akola since 1999"
      ],
      skills: [
        "M.B.B.S. (Nagpur), D.P.M. (Mumbai)",
        "Expert in psychiatric treatment and psychological counseling",
        "Specialized care for farmers and underprivileged communities",
        "Over 25 years of medical practice experience",
        "Committed to accessible mental healthcare"
      ],
      roleDescription: "Dr. Sujay Patil is our lead Consultant Psychiatrist with over 25 years of dedicated service in mental health. His extensive experience in treating various psychiatric conditions, combined with his commitment to serving farmers and underprivileged patients, makes him an invaluable asset to our team and the community.",
      socialContributions: [
        "Former Member – Child Rights Committee",
        "Former Member – State Educational Committee, Government of Maharashtra"
      ]
    ),
    Doctor(
      name: "Dr. Harshavardhan Malokar",
      specialty: "Consultant Obstetrician ",
      imageUrl: "assets/team/Dr.Harshavardhan_Malokar.png",
      education: [
        "MBBS (1991)",
        "DGO (Diploma in Gynaecology and Obstetrics) (1994)",
        "MD (Obstetrics & Gynaecology) (1998)"
      ],
      experience: [
        "Practicing in Akola since 1999",
        "Over 25 years of dedicated practice in women's healthcare",
        "Offering compassionate care to thousands of women throughout their journey of motherhood",
        "Specialized expertise in obstetrics and gynaecology"
      ],
      skills: [
        "MBBS (1991), DGO (1994), MD (Obstetrics & Gynaecology) (1998)",
        "Expert in obstetrics and gynaecological care",
        "Compassionate approach to women's healthcare",
        "25+ years of clinical experience",
        "Accomplished medical author and educator"
      ],
      roleDescription: "Dr. Harshavardhan Malokar is a highly respected Consultant Obstetrician & Gynaecologist with over 25 years of experience. His dedication to women's healthcare and his expertise in guiding women through their pregnancy journey makes him an invaluable member of our medical team.",
      socialContributions: [
        "Author of 'Prasooticha Pravas' (The Journey of Pregnancy) - First Edition: 23rd January 2023",
        "Second Edition of 'Prasooticha Pravas' published in 2025",
        "Hindi Edition of 'Prasooticha Pravas' - Coming Soon",
        "Contributing to medical literature with scientific, sensitive, and practical guidance for pregnancy and childbirth"
      ]
    ),
    Doctor(
      name: "Smita Pande",
      specialty: "Counselor",
      imageUrl: "assets/team/Smita_Pande.png",
      education: [
        "B.A.: YCMOU, Nashik – 2017",
        "M.A. (Psychology): Sant Gadge Baba Amravati University – 2021",
        "CCYN (Counseling Course): Mumbai – 2023"
      ],
      experience: [
        "Working as a Counselor for the past 7 years",
        "Assistant Professor at Shivaji College, Akola for 1 year",
        "Specializes in emotional counseling, student guidance, and strengthening parent-teacher communication"
      ],
      skills: [
        "Dedicated and responsible approach",
        "Strong communication skills",
        "Team-oriented mindset",
        "Positive and empathetic attitude",
        "7 years experienced in Psychology and Teaching"
      ],
      roleDescription: "Smita Pande is an essential part of our counseling department, offering psychological, emotional, and academic support to students. With her balanced experience in teaching and counseling, she plays a vital role in guiding young minds toward growth and stability.",
    ),
    Doctor(
      name: "Mr. Ashish Patil",
      specialty: "Counselor",
      imageUrl: "assets/team/Mr.Ashish_Patil.png",
      education: [
        "D.Ed: Government College of Education, Akola",
        "B.Sc: Mahatma Phule Science College, Sangrampur",
        "M.A (Counselling & Psychotherapy): Sant Gadge Baba Amravati University"
      ],
      experience: [
        "3 years of counseling experience at Patil Hospital",
        "2 years of teaching experience – working closely with students in academic and developmental areas",
        "Experienced in mental health and educational guidance",
        "Specialized in individual, academic, and emotional counseling for students"
      ],
      skills: [
        "Expert in counselling and psychotherapy",
        "Strong background in education and student development",
        "Skilled in individual and group counseling sessions",
        "Experienced in mental health awareness programs",
        "Effective communication with students, parents, and teachers"
      ],
      roleDescription: "Mr. Ashish Patil works with our team as a dedicated counselor, providing comprehensive support through individual, academic, and emotional counseling for students. His combined experience in teaching and counseling makes him uniquely qualified to understand and address the diverse needs of students, parents, and educators.",
      socialContributions: [
        "Conducts guidance sessions for parents and teachers",
        "Organizes awareness programs on mental health and well-being",
        "Promotes mental health literacy in educational settings"
      ]
    ),
    Doctor(
      name: "Pooja Gajanan Kanoje",
      specialty: "Counselor",
      imageUrl: "assets/team/Mrs Pooja wankhade.png",
      education: [
        "B.A. (Psychology): Indirabai Meghe Mahila Mahavidyalaya, Amravati – 2018",
        "M.A. (Psychology): VMV College, Amravati – 2020",
        "Post Graduate Diploma in Psychological Counseling: Dr. Babasaheb Ambedkar Marathwada University, Chhatrapati Sambhajinagar – 2022"
      ],
      experience: [
        "Currently working as a Counselor at Patil Hospital, Akola",
        "Skilled in providing psychological counseling to individuals with empathy and understanding",
        "Known as a wonderful communicator who encourages patients to open up and talk freely",
        "Creative thinker with a positive attitude and strong sense of commitment"
      ],
      skills: [
        "Quick learner and cooperative team member",
        "Committed to patient care and mental wellness",
        "Strong communication and interpersonal skills",
        "Empathetic counseling approach",
        "Creative problem-solving abilities"
      ],
      roleDescription: "Ms. Pooja Kanoje is a valuable part of our mental health support system. As a counselor, she offers emotional, academic, and psychological guidance to students, while also supporting parents and educators through effective and compassionate counseling.",
    ),
    Doctor(
      name: "Rasika Palkar",
      specialty: "Counselor & Psychotherapist",
      imageUrl: "assets/team/Rasika_Palkar.png",
      education: [
        "M.A. in Psychology: Shivaji College, Akola",
        "Sant Gadge Baba Amravati University (2017 to 2019)",
        "Graduated in 2020"
      ],
      experience: [
        "Counselor & Psychotherapist at Patil Hospital, Akola (March 2020 - Present)",
        "5 years of professional experience in counseling and psychotherapy",
        "Providing individual and family counseling",
        "Conducting psychological assessments and therapy sessions",
        "Designing treatment plans and tracking progress",
        "Supporting patients in crisis and collaborating with medical staff"
      ],
      skills: [
        "Effective communication and empathy",
        "Emotional intelligence",
        "Problem-solving and adaptability",
        "Team collaboration and organizational skills",
        "Crisis intervention and client-centered care",
        "Individual and family counseling expertise"
      ],
      roleDescription: "Ms. Rasika Palkar is an integral part of our mental wellness team, working as a counselor and psychotherapist. She provides emotional, academic, and personal guidance to students, supports parent-teacher communication, and actively promotes mental health awareness. Her 5 years of professional experience make her a valuable asset in delivering comprehensive mental health support."
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth;
        bool isTablet = width > 700;
        bool isWide = width > 1100;
        
        // Determine cross axis count based on screen size
        int crossAxisCount;
        if (isWide) {
          crossAxisCount = 4;
        } else if (isTablet) {
          crossAxisCount = 3;
        } else {
          crossAxisCount = 1; // Single column for mobile devices
        }
        
        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 224, 248, 255),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text(
              'Our Team',
              style: TextStyle(
                color: Colors.black87, 
                fontWeight: FontWeight.bold
              ),
            ),
            iconTheme: IconThemeData(color: Colors.black87),
            centerTitle: true,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isWide ? 60 : (isTablet ? 32 : 22), 
                vertical: 18
              ),
              child: Column(
                children: [
                  // Header section
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(isTablet ? 32 : 24),
                    margin: EdgeInsets.only(bottom: 24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 12,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.people,
                          size: isTablet ? 48 : 40,
                          color: Colors.teal,
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Meet Our Expert Team',
                          style: TextStyle(
                            fontSize: isTablet ? 28 : 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Dedicated professionals committed to your growth and success',
                          style: TextStyle(
                            fontSize: isTablet ? 16 : 14,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  
                  // Team members grid
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: doctors.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: isTablet ? 20 : 16,
                      mainAxisSpacing: isTablet ? 20 : 16,
                      childAspectRatio: isWide ? 0.85 : (isTablet ? 0.8 : 1.2),
                    ),
                    itemBuilder: (context, index) {
                      final doctor = doctors[index];
                      return DoctorCard(doctor: doctor, isTablet: isTablet);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class DoctorCard extends StatelessWidget {
  final Doctor doctor;
  final bool isTablet;

  const DoctorCard({required this.doctor, this.isTablet = false});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      child: InkWell(
        onTap: () {
          if (doctor.education != null || doctor.experience != null || doctor.skills != null) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DoctorDetailPage(doctor: doctor),
              ),
            );
          }
        },
        borderRadius: BorderRadius.circular(18),
        child: Card(
        elevation: 8,
        shadowColor: Colors.black26,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(isTablet ? 24 : 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Profile Image with decorative border
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.teal.withOpacity(0.3),
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.teal.withOpacity(0.2),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: doctor.imageUrl.startsWith('http')
                        ? Image.network(
                            doctor.imageUrl,
                            width: isTablet ? 100 : 80,
                            height: isTablet ? 100 : 80,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              width: isTablet ? 100 : 80,
                              height: isTablet ? 100 : 80,
                              color: Colors.grey[200],
                              child: Icon(
                                Icons.person,
                                size: isTablet ? 50 : 40,
                                color: Colors.grey[500],
                              ),
                            ),
                          )
                        : Image.asset(
                            doctor.imageUrl,
                            width: isTablet ? 100 : 80,
                            height: isTablet ? 100 : 80,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              width: isTablet ? 100 : 80,
                              height: isTablet ? 100 : 80,
                              color: Colors.grey[200],
                              child: Icon(
                                Icons.person,
                                size: isTablet ? 50 : 40,
                                color: Colors.grey[500],
                              ),
                            ),
                          ),
                  ),
                ),
                
                SizedBox(height: isTablet ? 16 : 12),
                
                // Name
                Text(
                  doctor.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: isTablet ? 18 : 16,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                
                SizedBox(height: 4),
                
                // Specialty with accent color
                Flexible(
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: isTablet ? 12 : 8,
                      vertical: isTablet ? 8 : 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.teal.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      doctor.specialty,
                      style: TextStyle(
                        color: Colors.teal[700],
                        fontSize: isTablet ? 13 : 11,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                
                // Additional info if available
                if (doctor.additionalInfo != null) ...[
                  SizedBox(height: 8),
                  Flexible(
                    child: Text(
                      doctor.additionalInfo!,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: isTablet ? 13 : 11,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
      ),
    );
  }
}

// Detailed profile page
class DoctorDetailPage extends StatelessWidget {
  final Doctor doctor;

  const DoctorDetailPage({required this.doctor});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth;
        bool isTablet = width > 700;
        bool isWide = width > 1100;
        
        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 224, 248, 255),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text(
              doctor.name,
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
            iconTheme: IconThemeData(color: Colors.black87),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isWide ? 60 : (isTablet ? 32 : 22), 
                vertical: 18
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: isWide ? 800 : double.infinity),
                  child: Column(
                    children: [
                      // Profile Header Card
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(isTablet ? 32 : 24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 12,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Profile Image
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.teal.withOpacity(0.3),
                                  width: 4,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.teal.withOpacity(0.2),
                                    blurRadius: 12,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ClipOval(
                                child: doctor.imageUrl.startsWith('http')
                                    ? Image.network(
                                        doctor.imageUrl,
                                        width: isTablet ? 150 : 120,
                                        height: isTablet ? 150 : 120,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) => Container(
                                          width: isTablet ? 150 : 120,
                                          height: isTablet ? 150 : 120,
                                          color: Colors.grey[200],
                                          child: Icon(
                                            Icons.person,
                                            size: isTablet ? 75 : 60,
                                            color: Colors.grey[500],
                                          ),
                                        ),
                                      )
                                    : Image.asset(
                                        doctor.imageUrl,
                                        width: isTablet ? 150 : 120,
                                        height: isTablet ? 150 : 120,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) => Container(
                                          width: isTablet ? 150 : 120,
                                          height: isTablet ? 150 : 120,
                                          color: Colors.grey[200],
                                          child: Icon(
                                            Icons.person,
                                            size: isTablet ? 75 : 60,
                                            color: Colors.grey[500],
                                          ),
                                        ),
                                      ),
                              ),
                            ),
                            
                            SizedBox(height: 20),
                            
                            // Name
                            Text(
                              doctor.name,
                              style: TextStyle(
                                fontSize: isTablet ? 28 : 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            
                            SizedBox(height: 12),
                            
                            // Specialty
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                horizontal: isTablet ? 20 : 16,
                                vertical: isTablet ? 12 : 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.teal.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                doctor.specialty,
                                style: TextStyle(
                                  color: Colors.teal[700],
                                  fontSize: isTablet ? 16 : 14,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      SizedBox(height: 20),
                      
                      // Role Description
                      if (doctor.roleDescription != null)
                        _buildInfoCard(
                          '🌱 Role in Our Team',
                          [doctor.roleDescription!],
                          isTablet,
                          isWide,
                          Colors.green,
                        ),
                      
                      // Education
                      if (doctor.education != null && doctor.education!.isNotEmpty)
                        _buildInfoCard(
                          '🎓 Educational Qualifications',
                          doctor.education!,
                          isTablet,
                          isWide,
                          Colors.blue,
                        ),
                      
                      // Experience
                      if (doctor.experience != null && doctor.experience!.isNotEmpty)
                        _buildInfoCard(
                          '🧠 Professional Experience',
                          doctor.experience!,
                          isTablet,
                          isWide,
                          Colors.orange,
                        ),
                      
                      // Skills
                      if (doctor.skills != null && doctor.skills!.isNotEmpty)
                        _buildInfoCard(
                          '💡 Personality Highlights',
                          doctor.skills!,
                          isTablet,
                          isWide,
                          Colors.purple,
                        ),
                      
                      // Social Contributions
                      if (doctor.socialContributions != null && doctor.socialContributions!.isNotEmpty)
                        _buildInfoCard(
                          '🏅 Social Contributions',
                          doctor.socialContributions!,
                          isTablet,
                          isWide,
                          Colors.amber,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildInfoCard(String title, List<String> items, bool isTablet, bool isWide, Color accentColor) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(isTablet ? 24 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Row(
            children: [
              Container(
                width: 4,
                height: isTablet ? 28 : 24,
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: isTablet ? 20 : 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          
          SizedBox(height: 16),
          
          // Content Items
          ...items.map((item) => Container(
            margin: EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 8),
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.7),
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item,
                    style: TextStyle(
                      fontSize: isTablet ? 16 : 14,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          )).toList(),
        ],
      ),
    );
  }
}
