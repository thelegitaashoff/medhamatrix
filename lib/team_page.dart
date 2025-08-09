import 'package:flutter/material.dart';
import 'doctor.dart';

class TeamPage extends StatelessWidget {
  final List<Doctor> doctors = [
    Doctor(
      name: "Dr. Aisha Sharma",
      specialty: "Psychologist",
      imageUrl: "https://randomuser.me/api/portraits/women/60.jpg",
    ),
    Doctor(
      name: "Dr. Raj Mehta",
      specialty: "Career Counselor",
      imageUrl: "https://randomuser.me/api/portraits/men/41.jpg",
    ),
    Doctor(
      name: "Mrs. Pooja Wankhade",
      specialty: "Team Member",
      imageUrl: "assets/team/Mrs Pooja wankhade.jpg",
      additionalInfo: "Postgraduation in psychology",
    ),
    // Add more doctors as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Our Counseling Team'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          itemCount: doctors.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Change for screen size
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.8,
          ),
          itemBuilder: (context, index) {
            final doctor = doctors[index];
            return DoctorCard(doctor: doctor);
          },
        ),
      ),
    );
  }
}

class DoctorCard extends StatelessWidget {
  final Doctor doctor;

  const DoctorCard({required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              ClipOval(
                child: doctor.imageUrl.startsWith('http')
                    ? Image.network(
                        doctor.imageUrl,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Icon(Icons.person, size: 80),
                      )
                    : Image.asset(
                        doctor.imageUrl,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            doctor.name,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          if (doctor.additionalInfo != null) ...[
            SizedBox(height: 4),
            Flexible(
              child: Text(
                doctor.additionalInfo!,
                style: TextStyle(color: Colors.black87, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 8),
          ],
          Text(
            doctor.specialty,
            style: TextStyle(color: Color.fromARGB(255, 224, 248, 255), fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
