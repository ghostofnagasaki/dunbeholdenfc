import 'package:flutter_riverpod/flutter_riverpod.dart';

class Event {
  final String title;
  final String time;
  final DateTime date;

  Event({required this.title, required this.time, required this.date});
}

class EventNotifier extends StateNotifier<Map<DateTime, List<Event>>> {
  EventNotifier() : super({});

  void addEvent(Event event) {
    state = {
      ...state,
      event.date: [...(state[event.date] ?? []), event],
    };
  }

  void removeEvent(Event event) {
    state = {
      ...state,
      event.date: (state[event.date] ?? [])..removeWhere((e) => e == event),
    };
  }

  List<Event> getEventsForDay(DateTime day) {
    return state[day] ?? [];
  }

  void loadDummyEvents() {
    final now = DateTime.now();
    state = {
      now.subtract(const Duration(days: 2)): [
        Event(
            title: 'Weekly sales meeting',
            time: '02:00 PM - 03:00 PM',
            date: now.subtract(const Duration(days: 2)))
      ],
      now: [
        Event(
            title: 'Marketing review with Sarah',
            time: '08:40 AM - 10:00 AM',
            date: now)
      ],
      now.add(const Duration(days: 4)): [
        Event(
            title: 'Retrospective',
            time: '10:00 AM - 11:00 AM',
            date: now.add(const Duration(days: 4)))
      ],
    };
  }
}

final eventProvider = StateNotifierProvider<EventNotifier, Map<DateTime, List<Event>>>((ref) => EventNotifier());
