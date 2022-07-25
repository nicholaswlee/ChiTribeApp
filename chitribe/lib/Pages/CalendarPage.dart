import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import "EventsPage.dart";

class CalendarPage extends StatefulWidget{
  @override
  CalendarPageState createState() => CalendarPageState();
}
class CalendarPageState extends State<CalendarPage> {
  //final Map<DateTime, List<EventItem>> _allEvents = getData();
  Future<Map<DateTime, List<EventItem>>> getData() async {
    print("hello");
    var response = await http.get(
      Uri.parse("https://chitribe.org/wp-json/tribe/events/v1/events?per_page=20&start_date=${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}&end_date=2022-12-01"),
    );
    if(response.statusCode == 200){
      print("Success");
    }
    print("Hello 1");
    final data = json.decode(response.body) as Map<String, dynamic>;
    List<EventItem> _events = [];
    print("Hello 2");
    print(data["events"].length);
    for(var i = 0; i < data["events"].length; i++){
      print(i);
      _events.add(EventItem.fromJson(data["events"][i]));
      print("Added");
    }
    print("Hello");
    Map<DateTime, List<EventItem>> mappedEvents = {};
    for(var j = 0; j < _events.length; j++){
      if(mappedEvents[_events[j].getDay()] == null){
        mappedEvents[_events[j].getDay()] = [_events[j]];
      }else{
        mappedEvents[_events[j].getDay()]?.add(_events[j]);
      }
    }
    return mappedEvents;
  }

  @override
  Widget build(BuildContext context) {
      return FutureBuilder<Map<DateTime, List<EventItem>>>(
        future: getData(),
        builder: (context, eventsSnap) {
          if (eventsSnap.connectionState == ConnectionState.none &&
              eventsSnap.hasData == null) {
            //print('project snapshot data is: ${projectSnap.data}');
            return Container();
          }else{
            return CalendarPageWidget(eventsSnap.data);
          }
          
        },
      );
  }
}

 class CalendarPageWidget extends StatefulWidget {
   final Map<DateTime, List<EventItem>>? events;
   CalendarPageWidget(this.events);
  @override
  CalendarPageWidgetState createState() => CalendarPageWidgetState();
}

class CalendarPageWidgetState extends State<CalendarPageWidget> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  late final ValueNotifier<List<EventItem>> _selectedEvents;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  List<EventItem> _getEventsForDay(DateTime day) {
    // Implementation exampl
    return widget.events?[day] ?? [];
  }
    @override
   void _pushPost(EventItem event) {
    Navigator.of(context).push(
      // Add lines from here...
      MaterialPageRoute<void>(
        builder: (context) {
          return Scaffold(
            backgroundColor: Color.fromARGB(255, 246, 243, 200),
            appBar: AppBar(
              title: Text(
                      event.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold
                      )
                    ),
              backgroundColor: Colors.red[800],
            ),
            body: Center(
                child: EventPage(event),
            )
          );
        },
      ), // ...to here.
    );
  }
  @override
  Widget build(BuildContext context) {
    return  Column (
      children: <Widget>[
        TableCalendar(
          firstDay: DateTime.utc(2010, 10, 16),
          lastDay: DateTime.utc(2030, 3, 14),
          focusedDay: _focusedDay,
          calendarFormat: _calendarFormat,
          eventLoader: _getEventsForDay,
          availableCalendarFormats:  const {CalendarFormat.month : 'Week', CalendarFormat.twoWeeks : 'Month', CalendarFormat.week : 'Two Weeks'},
          selectedDayPredicate: (day) {
            // Use `selectedDayPredicate` to determine which day is currently selected.
            // If this returns true, then `day` will be marked as selected.

            // Using `isSameDay` is recommended to disregard
            // the time-part of compared DateTime objects.
            return isSameDay(_selectedDay, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            if (!isSameDay(_selectedDay, selectedDay)) {
              // Call `setState()` when updating the selected day
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            }
            _selectedEvents.value = _getEventsForDay(selectedDay);
          },
          onFormatChanged: (format) {
            if (_calendarFormat != format) {
              // Call `setState()` when updating calendar format
              setState(() {
                _calendarFormat = format;
              });
            }
          },
          onPageChanged: (focusedDay) {
            // No need to call `setState()` here
            _focusedDay = focusedDay;
          },
        ),
        const SizedBox(height: 8.0),
          Expanded(
            child: Container(
              margin: EdgeInsets.fromLTRB(16, 0, 16, 8),
              //padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
              decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.black,  // red as border color
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          /*borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                          ),*/
              ),
              child: ValueListenableBuilder<List<EventItem>>(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {
                return ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                      return Container(

                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.black,  // red as border color
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Colors.blue
                        ),
                        height: 170,
                        child: Column(
                            children: <Widget>[
                            Container(
                              padding: EdgeInsets.fromLTRB(16, 16, 0, 0),
                              height: 60,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.red[800],
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                              child: Text(value[index].name,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      )
                              )
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                              height: 108,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.black,  // red as border color
                                ),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                ),
                                color: Colors.white
                              ),
                              child: ListTile(
                              onTap:(() {
                                _pushPost(value[index]);
                              } ),
                              title: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Expanded(
                                          flex: 1,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                                    Text(
                                                      "Organizer: ${value[index].organizer}",
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.bold
                                                      )
                                                    ),
                                                    Text(
                                                      value[index].timeRange,
                                                      style: TextStyle(
                                                        fontSize: 12
                                                      )
                                                    )
                                                  ]
                                                )
                                                )
                                                ,
                                        Expanded(
                                          flex: 1,
                                          child: Image.network(
                                            value[index].imgUrl ?? "assets/logo.png", 
                                            height: 80, 
                                            width: 100,
                                            fit: BoxFit.contain
                                          )
                                        ),
                                      ],
                                    )
                              
                                
                            ),
                            )
                        ]
                    )
                      );
                  },
                );
              },
            ),
            )
          ),

      ]
    );
  }
}

