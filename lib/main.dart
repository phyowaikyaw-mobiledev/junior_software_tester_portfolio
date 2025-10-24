import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Portfolio_4_Software_Tester',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF667eea),
        scaffoldBackgroundColor: const Color(0xFF0f172a),
        fontFamily: 'Poppins',
      ),
      home: const PortfolioHome(),
    );
  }
}

class PortfolioHome extends StatefulWidget {
  const PortfolioHome({super.key});

  @override
  State<PortfolioHome> createState() => _PortfolioHomeState();
}

class _PortfolioHomeState extends State<PortfolioHome> with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _homeKey = GlobalKey();
  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _skillsKey = GlobalKey();
  final GlobalKey _experienceKey = GlobalKey();
  final GlobalKey _projectsKey = GlobalKey();
  final GlobalKey _educationKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();

    _scrollController.addListener(() {
      if (_scrollController.offset > 100 && !_isScrolled) {
        setState(() => _isScrolled = true);
      } else if (_scrollController.offset <= 100 && _isScrolled) {
        setState(() => _isScrolled = false);
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSection(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _launchUrl(String url) async {
    if (url.contains('mailto')) {
      // Show email in a dialog instead of trying to launch email app
      _showEmailDialog();
    } else {
      // For other URLs (GitHub, Facebook) - they work fine
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      }
    }
  }

  void _showEmailDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFF1e293b),
        title: Text('Email Me', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('phyowaikyawdeveloper@gmail.com',
                style: TextStyle(color: Color(0xFF667eea), fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('Copy this email to contact me directly',
                style: TextStyle(color: Colors.white70)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK', style: TextStyle(color: Color(0xFF667eea))),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                _buildHeroSection(),
                _buildProfileSection(),
                _buildSkillsSection(),
                _buildExperienceSection(),
                _buildProjectsSection(),
                _buildEducationSection(),
                _buildContactSection(),
                _buildFooter(),
              ],
            ),
          ),
          _buildModernNavBar(),
        ],
      ),
    );
  }

  Widget _buildModernNavBar() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 70,
      decoration: BoxDecoration(
        color: _isScrolled ? const Color(0xFF0f172a).withOpacity(0.7) : Colors.transparent,
        boxShadow: _isScrolled
            ? [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 3),
          ),
        ]
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 900) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () => _scrollToSection(_homeKey),
                    child: ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [Color(0xFF667eea), Color(0xFFf093fb)],
                      ).createShader(bounds),
                      child: const Text(
                        'PWK',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.menu, color: Colors.white),
                    onSelected: (value) {
                      switch (value) {
                        case 'home':
                          _scrollToSection(_homeKey);
                          break;
                        case 'profile':
                          _scrollToSection(_aboutKey);
                          break;
                        case 'skills':
                          _scrollToSection(_skillsKey);
                          break;
                        case 'experience':
                          _scrollToSection(_experienceKey);
                          break;
                        case 'projects':
                          _scrollToSection(_projectsKey);
                          break;
                        case 'education':
                          _scrollToSection(_educationKey);
                          break;
                        case 'contact':
                          _scrollToSection(_contactKey);
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(value: 'home', child: Text('Home')),
                      const PopupMenuItem(value: 'profile', child: Text('Profile')),
                      const PopupMenuItem(value: 'skills', child: Text('Skills')),
                      const PopupMenuItem(value: 'experience', child: Text('Experience')),
                      const PopupMenuItem(value: 'projects', child: Text('Projects')),
                      const PopupMenuItem(value: 'education', child: Text('Education')),
                      const PopupMenuItem(value: 'contact', child: Text('Contact')),
                    ],
                  ),
                ],
              );
            }
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () => _scrollToSection(_homeKey),
                  child: ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Color(0xFF667eea), Color(0xFFf093fb)],
                    ).createShader(bounds),
                    child: const Text(
                      'PWK',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    _modernNavButton('Home', () => _scrollToSection(_homeKey)),
                    _modernNavButton('Profile', () => _scrollToSection(_aboutKey)),
                    _modernNavButton('Skills', () => _scrollToSection(_skillsKey)),
                    _modernNavButton('Experience', () => _scrollToSection(_experienceKey)),
                    _modernNavButton('Projects', () => _scrollToSection(_projectsKey)),
                    _modernNavButton('Education', () => _scrollToSection(_educationKey)),
                    _modernNavButton('Contact', () => _scrollToSection(_contactKey)),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _modernNavButton(String text, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      key: _homeKey,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF667eea),
            Color(0xFF764ba2),
            Color(0xFF0f172a),
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 100,
            left: 50,
            child: _buildAnimatedCircle(200, Colors.purple.withOpacity(0.3)),
          ),
          Positioned(
            bottom: 100,
            right: 50,
            child: _buildAnimatedCircle(250, Colors.pink.withOpacity(0.3)),
          ),
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [Color(0xFF667eea), Color(0xFFf093fb)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF667eea).withOpacity(0.5),
                            blurRadius: 30,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                      child: Center(
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/phyo.jpg',
                            width: 148,
                            height: 148,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              // Try alternative paths
                              return Image.asset(
                                'images/phyo.jpg',
                                width: 148,
                                height: 148,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 148,
                                    height: 148,
                                    color: Colors.grey,
                                    child: const Icon(Icons.person, size: 50, color: Colors.white),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        double fontSize = constraints.maxWidth < 600 ? 32 : 48;
                        return ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [Color(0xFF667eea), Color(0xFFf093fb)],
                          ).createShader(bounds),
                          child: Text(
                            'PHYO WAI KYAW',
                            style: TextStyle(
                              fontSize: fontSize,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        double fontSize = constraints.maxWidth < 600 ? 18 : 24;
                        return Text(
                          'Junior Software Tester',
                          style: TextStyle(
                            fontSize: fontSize,
                            color: Colors.white70,
                            fontWeight: FontWeight.w300,
                          ),
                          textAlign: TextAlign.center,
                        );
                      },
                    ),
                    const SizedBox(height: 40),
                    Wrap(
                      spacing: 20,
                      runSpacing: 10,
                      alignment: WrapAlignment.center,
                      children: [
                        _contactChip(Icons.email, 'phyowaikyawdeveloper@gmail.com'),
                        _contactChip(Icons.phone, '+66 18098313'),
                        _contactChip(Icons.location_on, 'Bangkok, Thailand'),
                      ],
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () => _scrollToSection(_contactKey),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF667eea),
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 10,
                      ),
                      child: const Text(
                        'Get In Touch',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Center(
              child: IconButton(
                onPressed: () => _scrollToSection(_aboutKey),
                icon: const Icon(Icons.keyboard_arrow_down, size: 40),
                color: Colors.white70,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedCircle(double size, Color color) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(seconds: 2),
      builder: (context, double value, child) {
        return Container(
          width: size * value,
          height: size * value,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        );
      },
    );
  }

  Widget _contactChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              text,
              style: const TextStyle(fontSize: 12, color: Colors.white),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
    return Container(
      key: _aboutKey,
      padding: const EdgeInsets.only(top: 80, left: 20, right: 20, bottom: 40),
      child: Column(
        children: [
          _sectionTitle('Profile'),
          const SizedBox(height: 40),
          Container(
            constraints: const BoxConstraints(maxWidth: 900),
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF667eea).withOpacity(0.3)),
            ),
            child: const Text(
              'Junior Software Tester with hands-on experience in mobile application testing, web application testing, API testing and bug reporting through professional work and personal projects. Strong foundation in Flutter development, HTML, CSS and JavaScript with practical knowledge of manual testing, bug reporting, and API testing. Quick learner passionate about software quality and eager to contribute in a professional testing environment.',
              style: TextStyle(
                fontSize: 16,
                height: 1.8,
                color: Colors.white70,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillsSection() {
    return Container(
      key: _skillsKey,
      padding: const EdgeInsets.only(top: 80, left: 20, right: 20, bottom: 40),
      color: Colors.white.withOpacity(0.02),
      child: Column(
        children: [
          _sectionTitle('Technical Skills'),
          const SizedBox(height: 40),
          LayoutBuilder(
            builder: (context, constraints) {
              double cardWidth = constraints.maxWidth < 800 ? constraints.maxWidth - 40 : 350;
              return Wrap(
                spacing: 20,
                runSpacing: 20,
                alignment: WrapAlignment.center,
                children: [
                  _skillCategory('Testing & QA', [
                    'Manual Testing',
                    'Functional Testing',
                    'Regression Testing',
                    'Smoke Testing',
                    'Mobile App Testing',
                    'Bug Reporting/Tracking',
                    'Test Case Design',
                    'UAT',
                    'Cross-Browser Testing',
                    'SDLC & STLC',
                    'Agile/Scrum'
                  ], cardWidth),
                  _skillCategory('Development & Tools', [
                    'Flutter & Dart',
                    'Git & GitHub',
                    'Firebase',
                    'RESTful API Testing',
                    'Postman',
                    'Swagger',
                    'Android Studio',
                    'VS Code',
                    'Jira',
                    'Trello'
                  ], cardWidth),
                  _skillCategory('Programming Languages', [
                    'Dart',
                    'Flutter',
                    'HTML/CSS/JavaScript',
                    'SQL',
                    'Visual Basic.NET'
                  ], cardWidth),
                  _skillCategory('Soft Skills', [
                    'Attention to Detail',
                    'Analytical Thinking',
                    'Problem Solving',
                    'Quick Learner',
                    'Team Collaboration',
                    'Strong Communication',
                    'Documentation Skills',
                    'Time Management'
                  ], cardWidth),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _skillCategory(String title, List<String> skills, double cardWidth) {
    return Container(
      width: cardWidth,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFF667eea).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF667eea),
            ),
          ),
          const SizedBox(height: 15),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: skills.map((skill) => _skillChip(skill)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _skillChip(String skill) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF667eea).withOpacity(0.2),
            const Color(0xFFf093fb).withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF667eea).withOpacity(0.5)),
      ),
      child: Text(
        skill,
        style: const TextStyle(fontSize: 12, color: Colors.white),
      ),
    );
  }

  Widget _buildExperienceSection() {
    return Container(
      key: _experienceKey,
      padding: const EdgeInsets.only(top: 80, left: 20, right: 20, bottom: 40),
      child: Column(
        children: [
          _sectionTitle('Experience'),
          const SizedBox(height: 40),
          _experienceCard(
            'Junior Quality Assurance',
            'Techno-Wave Software House',
            'Feb 2024 - Sept 2025',
            [
              'Execute comprehensive test cases for mobile and web applications',
              'Identify, document and track bugs using Jira and Trello',
              'Perform functional testing, regression testing, and cross-browser testing',
              'Work within Agile/Scrum methodologies with development teams',
              'Test LMS (Learning Management System) application',
              'Test Clinic Application (Patient Record System)',
              'Test Electronics Shop Internal Management System (Employee Management System)',
              'Conduct User Acceptance Testing (UAT) and smoke testing'
            ],
          ),
          const SizedBox(height: 20),
          _experienceCard(
            'Mobile Application Developer & Tester',
            'Independent Project-Based Learning',
            '2023 - Present',
            [
              'Developed Flutter mobile applications with focus on clean code and testability',
              'Performed comprehensive testing including functional and UI testing',
              'Identified and fixed bugs during development phase',
              'Gained hands-on experience with Firebase and REST API integration',
              'Continuously learning mobile development best practices'
            ],
          ),
          const SizedBox(height: 20),
          _experienceCard(
            'Tech Content Creator & Page Admin',
            'Learners Gateway - Facebook Page',
            '2023 - Present',
            [
              'Operate Facebook page dedicated to programming knowledge and AI trends',
              'Create and share content about developer roadmaps and technical guides',
              'Engage with tech community through educational content',
              'Demonstrate passion for continuous learning and knowledge sharing'
            ],
          ),
        ],
      ),
    );
  }

  Widget _experienceCard(String title, String company, String period, List<String> points) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 900),
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF667eea).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 600) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      company,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF667eea),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      period,
                      style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.5)),
                    ),
                  ],
                );
              }
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          company,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFF667eea),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    period,
                    style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.5)),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 15),
          ...points.map((point) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('▸ ', style: TextStyle(color: Color(0xFFf093fb))),
                Expanded(
                  child: Text(
                    point,
                    style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.7)),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildProjectsSection() {
    return Container(
      key: _projectsKey,
      padding: const EdgeInsets.only(top: 80, left: 20, right: 20, bottom: 40),
      color: Colors.white.withOpacity(0.02),
      child: Column(
        children: [
          _sectionTitle('Projects'),
          const SizedBox(height: 40),
          _modernProjectCard(
            'Portfolio Website',
            'Flutter Web, Vercel',
            'Developed personal portfolio using Flutter Web. Continuously updating with new projects and skills. Deployed on Vercel with responsive design.',
            Icons.web,
            const Color(0xFF667eea),
          ),
          const SizedBox(height: 20),
          _modernProjectCard(
            'Facebook Page Website',
            'Flutter Web, Firebase',
            'Built website for technical content sharing. Regularly updating with new content and features. Deployed on Firebase hosting.',
            Icons.language,
            const Color(0xFF8A63D2),
          ),
          const SizedBox(height: 20),
          _modernProjectCard(
            'E-Commerce Mobile App',
            'Flutter, GetX, BLoC, Firebase',
            'Collaborating with mentor on ongoing development. Regularly updating with new features and improvements. Implementing cart functionality with state management and MVC architecture using controllers.',
            Icons.shopping_cart,
            const Color(0xFFf093fb),
          ),
          const SizedBox(height: 20),
          _modernProjectCard(
            'Flutter Learning Applications',
            'Flutter, Dart, State Management',
            'Collection of practice apps: Roll Dice, Note, Music, Quiz, Movie, etc. Continuously improving code quality and adding features. All projects maintained and updated on GitHub.',
            Icons.apps,
            const Color(0xFF667eea),
          ),
        ],
      ),
    );
  }

  Widget _modernProjectCard(String title, String tech, String description, IconData icon, Color accentColor) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isSmall = constraints.maxWidth < 600;
        return Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 900),
          padding: EdgeInsets.all(isSmall ? 20 : 30),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.08),
                Colors.white.withOpacity(0.03),
              ],
            ),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: accentColor.withOpacity(0.4), width: 2),
            boxShadow: [
              BoxShadow(
                color: accentColor.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: isSmall
              ? Column(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [accentColor, accentColor.withOpacity(0.6)]),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(icon, size: 30, color: Colors.white),
              ),
              const SizedBox(height: 15),
              Text(
                title,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: accentColor.withOpacity(0.5)),
                ),
                child: Text(
                  tech,
                  style: TextStyle(fontSize: 12, color: accentColor, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                description,
                style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.8), height: 1.6),
                textAlign: TextAlign.center,
              ),
            ],
          )
              : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [accentColor, accentColor.withOpacity(0.6)]),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(icon, size: 35, color: Colors.white),
              ),
              const SizedBox(width: 25),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: accentColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: accentColor.withOpacity(0.5)),
                      ),
                      child: Text(
                        tech,
                        style: TextStyle(fontSize: 13, color: accentColor, fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      description,
                      style: TextStyle(fontSize: 15, color: Colors.white.withOpacity(0.8), height: 1.6),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEducationSection() {
    return Container(
      key: _educationKey,
      padding: const EdgeInsets.only(top: 80, left: 20, right: 20, bottom: 40),
      child: Column(
        children: [
          _sectionTitle('Education & Certifications'),
          const SizedBox(height: 40),
          LayoutBuilder(
            builder: (context, constraints) {
              bool isSmall = constraints.maxWidth < 700;
              return Container(
                width: double.infinity,
                constraints: const BoxConstraints(maxWidth: 900),
                padding: EdgeInsets.all(isSmall ? 20 : 35),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF667eea).withOpacity(0.1),
                      const Color(0xFFf093fb).withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: const Color(0xFF667eea).withOpacity(0.5), width: 2),
                ),
                child: isSmall
                    ? Column(
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [Color(0xFF667eea), Color(0xFF764ba2)]),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(Icons.school, size: 35, color: Colors.white),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Computer University, Mandalay',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Computer Science Major (2nd Year Completed)',
                      style: TextStyle(fontSize: 16, color: Color(0xFF667eea), fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '2019 - 2022',
                      style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.6)),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 15),
                    Text(
                      'Completed foundational courses in Computer Science including Data Structures, Algorithms, Database Management, and Software Engineering principles. Transitioned to self-directed learning in mobile application development following university closure.',
                      style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.8), height: 1.6),
                      textAlign: TextAlign.center,
                    ),
                  ],
                )
                    : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [Color(0xFF667eea), Color(0xFF764ba2)]),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(Icons.school, size: 40, color: Colors.white),
                    ),
                    const SizedBox(width: 25),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Computer University, Mandalay',
                            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Computer Science Major (2nd Year Completed)',
                            style: TextStyle(fontSize: 18, color: Color(0xFF667eea), fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            '2019 - 2022',
                            style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.6)),
                          ),
                          const SizedBox(height: 15),
                          Text(
                            'Completed foundational courses in Computer Science including Data Structures, Algorithms, Database Management, and Software Engineering principles. Transitioned to self-directed learning in mobile application development following university closure.',
                            style: TextStyle(fontSize: 15, color: Colors.white.withOpacity(0.8), height: 1.6),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 40),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 800) {
                return Column(
                  children: [
                    _certificationCard('Software Testing', 'Studying Fundamentals & Active Learner', Icons.bug_report, const Color(0xFF667eea)),
                    const SizedBox(height: 15),
                    _certificationCard('Computer System & Networking', 'Practical A+ Course Certificate', Icons.computer, const Color(0xFF764ba2)),
                    const SizedBox(height: 15),
                    _certificationCard('Information Technology', 'Visual Basic.NET Certificate', Icons.code, const Color(0xFFf093fb)),
                    const SizedBox(height: 15),
                    _certificationCard('API Testing with Postman', 'Self-taught through practice', Icons.api, const Color(0xFF667eea)),
                  ],
                );
              }
              return Wrap(
                spacing: 20,
                runSpacing: 20,
                alignment: WrapAlignment.center,
                children: [
                  _certificationCard('Software Testing', 'Studying Fundamentals & Active Learner', Icons.bug_report, const Color(0xFF667eea)),
                  _certificationCard('Computer System & Networking', 'Practical A+ Course Certificate', Icons.computer, const Color(0xFF764ba2)),
                  _certificationCard('Information Technology', 'Visual Basic.NET Certificate', Icons.code, const Color(0xFFf093fb)),
                  _certificationCard('API Testing with Postman', 'Self-taught through practice', Icons.api, const Color(0xFF667eea)),
                ],
              );
            },
          ),
          const SizedBox(height: 30),
          _languageCard(),
        ],
      ),
    );
  }

  Widget _certificationCard(String title, String description, IconData icon, Color color) {
    return Container(
      width: 280,
      constraints: const BoxConstraints(maxWidth: 400),
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color.withOpacity(0.2), color.withOpacity(0.05)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5), width: 2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [color, color.withOpacity(0.7)]),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(icon, size: 30, color: Colors.white),
          ),
          const SizedBox(height: 15),
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.7)),
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _languageCard() {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 600),
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFf093fb).withOpacity(0.3), width: 2),
      ),
      child: Column(
        children: [
          const Icon(Icons.language, size: 40, color: Color(0xFFf093fb)),
          const SizedBox(height: 15),
          const Text(
            'Languages',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 20),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 400) {
                return Column(
                  children: [
                    _languageItem('Burmese (Myanmar)', 'Native Fluency'),
                    const SizedBox(height: 15),
                    Container(height: 2, width: 100, color: Colors.white.withOpacity(0.2)),
                    const SizedBox(height: 15),
                    _languageItem('English', 'Working Proficiency'),
                  ],
                );
              }
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _languageItem('Burmese (Myanmar)', 'Native Fluency'),
                  Container(width: 2, height: 40, color: Colors.white.withOpacity(0.2)),
                  _languageItem('English', 'Working Proficiency'),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _languageItem(String language, String proficiency) {
    return Column(
      children: [
        Text(
          language,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 5),
        Text(
          proficiency,
          style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.6)),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildContactSection() {
    return Container(
      key: _contactKey,
      padding: const EdgeInsets.only(top: 80, left: 20, right: 20, bottom: 40),
      color: Colors.white.withOpacity(0.02),
      child: Column(
        children: [
          _sectionTitle('Let\'s Connect'),
          const SizedBox(height: 20),
          const Text(
            'I\'m actively seeking opportunities as a Junior Software Tester.\nLet\'s work together!',
            style: TextStyle(fontSize: 16, color: Colors.white70),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            alignment: WrapAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () => _launchUrl('mailto:phyowaikyawdeveloper@gmail.com'),
                icon: const Icon(Icons.email, color: Colors.white),
                label: const Text('Email Me', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF667eea),
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _launchUrl('https://github.com/phyowaikyaw-mobiledev'),
                icon: const Icon(Icons.code, color: Colors.white),
                label: const Text('GitHub', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF764ba2),
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _launchUrl('https://www.facebook.com/learnersgateway30'),
                icon: const Icon(Icons.facebook, color: Colors.white),
                label: const Text('Facebook Page', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFf093fb),
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.1))),
      ),
      child: const Text(
        '© 2025 Phyo Wai Kyaw. Designed with Passion.',
        style: TextStyle(color: Colors.white54, fontSize: 12),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double fontSize = constraints.maxWidth < 600 ? 28 : 36;
        return ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Color(0xFF667eea), Color(0xFFf093fb)],
          ).createShader(bounds),
          child: Text(
            title,
            style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }
}