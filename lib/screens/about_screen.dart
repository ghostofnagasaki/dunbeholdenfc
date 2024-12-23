import 'package:flutter/material.dart';
import '../constants/colors.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Dunbeholden FC',
            style: TextStyle(color: Colors.white, fontSize: 20)),
        backgroundColor: AppColors.primaryBlue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'History of Dunbeholden FC',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Image.asset(
              'assets/images/dunbeholden.png',
              height: 150,
            ),
            const SizedBox(height: 16),
            const Text(
              'The club was founded in 1992 by Donovan Witter. Since its inception the club competed exclusively in the South Central Confederation regional leagues until gaining promotion to the Jamaica Premier League.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 16),
            const Text(
              'Promotion to Premier League',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Dunbeholden defeated Wadadah F.C. 4-0 in the 2017-18 Magnum/Charley\'s JB Promotion Playoffs to gain promotion to Jamaica\'s premier football competition. After a hard start to the first season of premier league football, Dunbeholden dug deep to lift themselves out of the relegation zone and remain in the top flight.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 16),
            const Text(
              'Recent Achievements',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'In the 2022 Jamaica Premier League season, Dunbeholden finished runners-up in their first ever JPL finals appearance to mark their best premier league finish to date. The runners-up result sealed Dunbeholden a spot in the inaugural 2023 CONCACAF Caribbean Cup.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 16),
            const Text(
              'International Debut',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'The kick-off to the 2023 CONCACAF Caribbean Cup marked an historic occasion for Dunbeholden Football Club, it being the club\'s first ever appearance in an international competition and the first time a CONCACAF Caribbean Cup kicked-off in Jamaica between two Jamaican clubs.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
