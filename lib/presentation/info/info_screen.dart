import 'package:flutter/material.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF4361EE);

    return Scaffold(
      appBar: AppBar(
        title: const Text('À Propos'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 60,
                backgroundColor: primaryColor,
                child: Icon(Icons.person, size: 60, color: Colors.white),
                // backgroundImage: AssetImage('assets/images/developer_photo.png'), // Décommentez pour utiliser une photo
              ),
              const SizedBox(height: 24),
              const Text(
                'Severin TCHEITCHA', 
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Développeur Flutter & Passionné de Technologie',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 32),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.email_outlined, color: primaryColor), 
                  SizedBox(width: 8), 
                  Text('severin.tcheitcha@example.com', style: TextStyle(fontSize: 16)),
                ],
              ),
              const SizedBox(height: 12),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.link_outlined, color: primaryColor),
                  SizedBox(width: 8),
                  Text('github.com/severin-tcheitcha', style: TextStyle(fontSize: 16)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
