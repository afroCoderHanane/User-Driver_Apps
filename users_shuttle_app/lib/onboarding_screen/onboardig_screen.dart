import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:users_app/authentication/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _onboardingData = [    {      "title": "Welcome to Shuttle App",      "text": "Get access to convenient shuttle services around your campus",      "image": "images/onboarding_2.png",    },    {      "title": "Track your ride",      "text": "Know the estimated time of arrival and the shuttle's location",      "image": "images/onboarding_1.png",    },    {      "title": "Get notifications",      "text": "Receive updates on shuttle schedules and delays",      "image": "images/onboarding_3.png",    },  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
          Expanded(
          child: PageView.builder(
          controller: _pageController,
            itemCount: _onboardingData.length,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.2,
                  ),
                  Image.asset(
                    _onboardingData[index]["image"]!,
                    height: MediaQuery.of(context).size.height * 0.2,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                  Text(
                    _onboardingData[index]["title"]!,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Text(
                      _onboardingData[index]["text"]!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _onboardingData.length,
                (index) => buildDot(index, context),
          ),
        ),
        SizedBox(
          height: 40,
        ),
        Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
    child: SizedBox(
    width: double.infinity,
    height: 50,
      child: ElevatedButton(
        onPressed: () async {
          SharedPreferences prefs =
          await SharedPreferences.getInstance();
          prefs.setBool("onboarding_completed", true);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => LoginScreen(),
            ),
          );
        },
        child: Text(
          _currentPage == _onboardingData.length - 1
              ? "Get Started"
              : "Next",
          style: TextStyle(fontSize: 18),
        ),
        style: ElevatedButton.styleFrom(
          primary: Colors.red.shade900,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          padding: EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    ),
        ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
    );
  }

  AnimatedContainer buildDot(int index, BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      margin: EdgeInsets.only(right: 10),
      height: 10,
      width: _currentPage == index ? 30 : 10,
      decoration: BoxDecoration(
        color: _currentPage == index
            ? Colors.red.shade900
            : Colors.grey.shade600,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}
