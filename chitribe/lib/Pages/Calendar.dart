import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'CalendarPage.dart';
import "EventsPage.dart";

/**
 * Loads all the data for the events calendar given the filters.
 * This is a seperate widget to allow from data from
 * the user loaded into the inner CalendarPageWidget.
 */
class Calendar extends StatefulWidget{
  Calendar(
    {required this.filters}
  );
  final List<String> filters;
  @override
  CalendarState createState() => CalendarState();
}

class CalendarState extends State<Calendar> {
  //final Map<DateTime, List<EventItem>> _allEvents = getData();
  Map<DateTime, List<EventItem>> getData(List<QueryDocumentSnapshot<Object?>>  dataset) {
    List<EventItem> _events = [];
    for(var i = 0; i < dataset.length; i++){
      _events.add(EventItem.fromFirebase(dataset[i].data() as Map<String, dynamic>));
    }
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
    return StatefulBuilder(
      builder: (context, setState) {
        late Stream<QuerySnapshot> _eventsStream = (widget.filters.isNotEmpty) ? FirebaseFirestore.instance.collection('events').where("categories", arrayContainsAny: widget.filters).snapshots() 
                                                      : FirebaseFirestore.instance.collection('events').orderBy("startDate", descending: true).snapshots();
        return StreamBuilder<QuerySnapshot>(
          stream: _eventsStream,
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
            }

            return CalendarPageWidget(getData(snapshot.data!.docs));
              

          }
            
        );
      }
    );
  }
    
  
}

/**
 * The actual calendar for the calendar page. 
 */
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
    return widget.events?[day] ?? [];
  }

    @override
    /**
     * Opens a new page that displays the details of the event.
     * Also enables users to favorite the event given information 
     * as to if the event has been favorited of not.
     */
   void _pushPost(EventItem event, List<dynamic> favorited) {
    Navigator.of(context).push(
      // Add lines from here...
      MaterialPageRoute<void>(
        builder: (context) {
          bool isFavorited = false;
          if(favorited.contains(event.id)){
            isFavorited =true;
          }
          return StatefulBuilder(
        
            builder: (context, setState) {
                void _showErrorDialog(String title) {
                  showDialog<void>(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(
                          title,
                          style: const TextStyle(fontSize: 24),
                        ),
                        actions: <Widget>[
                          FilterButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              'OK',
                              style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                }
              return Scaffold(
                backgroundColor: Color.fromARGB(255, 246, 243, 200),
                appBar: AppBar(
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back_ios_new_outlined),
                    onPressed:  () async {
                      
                      if(isFavorited && !favorited.contains(event.id)){
                        if(favorited.length == 10){
                          _showErrorDialog("You cannot favorite more than 10 events");
                          return;
                        }else{
                          favorited.add(event.id);
                          FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({'favoritedEvents' : favorited});
                        }
                        

                      }else if(!isFavorited && favorited.contains(event.id)){
                        favorited.remove(event.id);
                        FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({'favoritedEvents' : favorited});
                      }
                      Navigator.of(context).pop();
                    }
                  ),
                  title: Text(
                          "${event.monthName} ${event.day}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold
                          )
                        ),
                  backgroundColor: Colors.red[800],
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.favorite),
                      color: isFavorited ? Colors.pink : Colors.white,
                      onPressed: (){
                        isFavorited = !isFavorited;
                        setState(() {
                          
                        });
                      },
                      tooltip: 'Open Profile',
                      iconSize: 30,
                    ),
                  ],
                ),
                body: Center(
                    child: EventPage(event),
                )
              );
            }
          );
        },
      ), // ...to here.
    );
  }
  @override
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  Widget build(BuildContext context) {

    return  FutureBuilder<DocumentSnapshot>(
      future: users.doc(FirebaseAuth.instance.currentUser!.uid).get(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }
        
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> userData = snapshot.data!.data() as Map<String, dynamic>;
          return Column (
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
                              child: Column(
                                  children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
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
                                    padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
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
                                      _pushPost(value[index], userData["favoritedEvents"]);
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
          return Text("loading");
      }
    );
  }
}

