import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  // Palette de couleurs cohérente
  static const Color primaryColor = Color(0xFF4361EE);
  static const Color secondaryColor = Color(0xFF3A0CA3);
  static const Color accentColor = Color(0xFF4CC9F0);
  static const Color backgroundColor = Color(0xFFF8F9FA);
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color onSurfaceColor = Color(0xFF212529);

  Future<void> _launchEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'nzomutchawilfrid@gmail.com',
      query: 'subject=BayamSalam App&body=Bonjour Tafforzore,',
    );

    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    }
  }

  Future<void> _launchPhone() async {
    final Uri phoneLaunchUri = Uri(
      scheme: 'tel',
      path: '+237651881464',
    );

    if (await canLaunchUrl(phoneLaunchUri)) {
      await launchUrl(phoneLaunchUri);
    }
  }

  Future<void> _launchGitHub() async {
    final Uri githubLaunchUri = Uri(
      scheme: 'https',
      path: 'github.com/tafforzore',
    );

    if (await canLaunchUrl(githubLaunchUri)) {
      await launchUrl(githubLaunchUri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          'À Propos',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: primaryColor,
        foregroundColor: surfaceColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Section Profil
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [primaryColor.withOpacity(0.1), accentColor.withOpacity(0.05)],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  // Avatar avec effet
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [primaryColor, secondaryColor],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: primaryColor.withOpacity(0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Stack(
                      children: [
                        // Effet de brillance
                        Positioned(
                          top: 15,
                          right: 15,
                          child: CircleAvatar(
                            radius: 10,
                            backgroundColor: Colors.white30,
                          ),
                        ),
                        // Icône principale
                        Center(
                          child: Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Tafforzore',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: onSurfaceColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Développeur Fullstack & Passionné de Technologie',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Section Contact
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Text(
                    'ME CONTACTER',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey.shade500,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Carte Email
                  _buildContactCard(
                    icon: Icons.email_outlined,
                    title: 'Email',
                    subtitle: 'nzomutchawilfrid@gmail.com',
                    color: primaryColor,
                    onTap: _launchEmail,
                  ),

                  const SizedBox(height: 16),

                  // Carte Téléphone
                  _buildContactCard(
                    icon: Icons.phone_rounded,
                    title: 'Téléphone',
                    subtitle: '+237 651 881 464',
                    color: Colors.green,
                    onTap: _launchPhone,
                  ),

                  const SizedBox(height: 16),

                  // Carte GitHub
                  _buildContactCard(
                    icon: Icons.code_rounded,
                    title: 'GitHub',
                    subtitle: 'github.com/tafforzore',
                    color: Colors.black,
                    onTap: _launchGitHub,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Section Description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.info_outline_rounded,
                            color: primaryColor,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'À propos de cette application',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: onSurfaceColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'BayamSalam est une application de gestion complète conçue pour vous aider à suivre vos produits, ventes et dépenses en toute simplicité. Développée avec Flutter, elle offre une expérience utilisateur moderne et intuitive.',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey.shade600,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(Icons.verified_rounded, color: primaryColor, size: 16),
                        const SizedBox(width: 8),
                        Text(
                          'Interface moderne et responsive',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.verified_rounded, color: primaryColor, size: 16),
                        const SizedBox(width: 8),
                        Text(
                          'Gestion en temps réel',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.verified_rounded, color: primaryColor, size: 16),
                        const SizedBox(width: 8),
                        Text(
                          'Sécurité des données',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: onSurfaceColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: color,
                  size: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}