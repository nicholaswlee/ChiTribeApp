import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher_string.dart';

class EventPage extends StatefulWidget {
  const EventPage(
    this.event
  );
  final EventItem event;
  @override
  EventPageState createState() => EventPageState();
}

class EventPageState extends State<EventPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(10, 8, 10, 8),
                color: Colors.blue,
                width: double.infinity,
                child: Text(
                        textAlign: TextAlign.center,
                        widget.event.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          
                        ),
                      ),
              
              ),
              
              Image.network(widget.event.imgUrl ?? "https://chitribe.org/wp-content/uploads/2019/02/51376315_10157313150659924_4463146571655020544_o.jpg"),
              Container(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Organizer: ${widget.event.organizer}",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          Text(
                            "${widget.event.monthName} ${widget.event.day} @${widget.event.timeRange}",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text("Website: ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            )
                          ),
                          GestureDetector(
                            child: Text(
                              "Website: ${widget.event.siteUrl}",
                              style: TextStyle(
                                  color: Colors.blue, 
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.bold,
                              ),
                            ),
                            onTap: () async {
                              try {
                                await launchUrlString(widget.event.siteUrl);
                              } catch (err) {
                                debugPrint('Something bad happened');
                              }
                            },
                          ),

                          
                          Text(
                            "Categories: ${widget.event.categories}",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                )
              ),
              Html(
                data: widget.event.htmlDesc,
              )
            ],
          )
      )
    );
    
  }
}

String createTimeRange(
  String startHR,
  String endHR,
  String startMin,
  String endMin,
){
  String start_label = "AM";
  String end_label = "AM";
  if (int.parse(startHR) >= 12){
    start_label = "PM";
  }
  if (int.parse(endHR) >= 12){
    end_label = "PM";
  }
  startHR = (int.parse(startHR) > 12 ? int.parse(startHR) - 12 : int.parse(startHR)).toString();
  endHR = (int.parse(endHR) > 12 ? int.parse(endHR) - 12 : int.parse(endHR)).toString();
  return "$startHR:$startMin $start_label - $endHR:$endMin $end_label";
}
check_organizer(Map<String, dynamic> json){
  print(json["organizer"]);
  return "No organizer";
}

find_month(int month){
  final months = ["January", "Februauy", "March", "April", "May", "June", "July", "August", 
                  "September", "October", "November", "December"];
  return months[month - 1];
}

remove_unicode(String str){
  print(str);
  if(str.contains("&amp;")){
    str = str.replaceAll("&amp;", "&");
  }
  if(str.contains("&#8211;")){
    str = str.replaceAll("&#8211;", "-");
  }
  return str;
}

get_categories(Map<String, dynamic> json){
  final json_cat_list = json["categories"];
  print("HERE");
  List<String> categories= [];
  print("HERE 1");
  for(var i = 0; i < json_cat_list.length; i++){
    print(json_cat_list[i]["name"]);
    categories.add(json_cat_list[i]["name"]);
  }
  return categories;
}
class EventItem{
  final String name;
  final String startDate;
  final String endDate;
  final int id;
  final String? imgUrl;
  final String organizer;
  final String htmlDesc;
  final String siteUrl;
  final String year;
  final String month;
  final String monthName;
  final String day;
  final String timeRange;
  final List<String> categories;
  EventItem({
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.id,
    required this.imgUrl,
    required this.organizer,
    required this.htmlDesc,
    required this.siteUrl,
    required this.year,
    required this.month,
    required this.monthName,
    required this.day,
    required this.timeRange,
    required this.categories
  });
  getDay(){
    return DateTime.utc(
      int.parse(year),
      int.parse(month),
      int.parse(day)
    );
  }

  factory EventItem.fromJson(Map<String, dynamic> json){
    return EventItem(
      name: remove_unicode(json["title"]), 
      startDate: json["start_date"], 
      endDate: json["end_date"], 
      id: json["id"], 
      imgUrl: (json["image"] == false) ? "https://chitribe.org/wp-content/uploads/2019/02/51376315_10157313150659924_4463146571655020544_o.jpg":  json["image"]["url"], 
      organizer: (json["organizer"].length == 0) ? "ChiTribe" : remove_unicode(json["organizer"][0]["organizer"]), 
      htmlDesc: json["description"],
      siteUrl: json["website"],
      year: json["utc_start_date_details"]["year"],
      month: json["utc_start_date_details"]["month"],
      monthName: find_month(int.parse(json["utc_start_date_details"]["month"])),
      day: json["utc_start_date_details"]["day"],
      timeRange: createTimeRange(
                  json["start_date_details"]["hour"],
                  json["end_date_details"]["hour"],
                  json["start_date_details"]["minutes"],
                  json["end_date_details"]["minutes"],
                ),
      categories: get_categories(json)
    );
    
  }
  
  factory EventItem.fromMap(Map<String, dynamic> json){
    return EventItem(
      name: remove_unicode(json["title"]), 
      startDate: json["start_date"], 
      endDate: json["end_date"], 
      id: json["id"], 
      imgUrl: json["image"]["url"], 
      organizer: (json["organizer"].length == 0) ? "ChiTribe" : remove_unicode(json["organizer"][0]["organizer"]), 
      htmlDesc: json["description"],
      siteUrl: json["website"],
      year: json["utc_start_date_details"]["year"],
      month: json["utc_start_date_details"]["month"],
      monthName: find_month(int.parse(json["utc_start_date_details"]["month"])),
      day: json["utc_start_date_details"]["day"],
      timeRange: createTimeRange(
                  json["start_date_details"]["hour"],
                  json["end_date_details"]["hour"],
                  json["start_date_details"]["minutes"],
                  json["end_date_details"]["minutes"],
                ),
      categories: get_categories(json)
    );
  }

}