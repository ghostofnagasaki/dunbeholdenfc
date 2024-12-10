import 'package:flutter/material.dart';
// import 'package:schoolapp/widgets/school_events_widget.dart';
// import 'package:schoolapp/widgets/school_posts_widget.dart';
// import 'package:schoolapp/widgets/school_calendar_widget.dart';

class SchoolInfoScreen extends StatelessWidget {
  const SchoolInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // const SchoolEventsWidget(),
          // const SchoolPostsWidget(),
          // const SchoolCalendarWidget(),
          ElevatedButton(
            onPressed: () {
              // Navigate to a detailed school info page
            },
            child: const Text('About Our School'),
          ),
        ],
      ),
    );
  }
}
