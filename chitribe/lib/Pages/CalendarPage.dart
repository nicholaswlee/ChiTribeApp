import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'Calendar.dart';

/**
 * Displays the full calendar page.
 */
class CalendarPage extends StatefulWidget{
  @override
  CalendarPageState createState() => CalendarPageState();
}

class CalendarPageState extends State<CalendarPage> {
  List<String> filtered = [];
  List<String> filteredApplied = [];
  final filterOptions = [
    "Antisemitism",
    "Book Club",
    "City",
    "Climate",
    "Comedy",
    "Events",
    "Food",
    "Game Night",
    "Happy Hour",
    "Holiday Event",
    "Holocaust",
    "Israel Event",
    "Jewish Genetics",
    "Learning",
    "LGBTQ",
    "Music",
    "Native Americans",
    "Networking",
    "Passover Event",
    "Racial Justice",
    "Russian Speaking",
    "Shabbat Event",
    "Socially Distanced",
    "Special Needs",
    "Sports",
    "Suburb",
    "Travel Opportunity",
    "Virtual",
    "Volunteering",
    "Women",
    "Yoga",
    "Young Family"
  ];
  /**
   * Sets the state with the filters
   */
  void setFilters(){
    filteredApplied = filtered;
    setState((){});
    Navigator.of(context).pop();
  }
  /**
   * Shows an error page.
   */
  void _showErrorDialog(BuildContext context, String title) {
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
  /**
   * Shows the filters in a pop up the a user can filter through.
   */
  void showFilters() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    20.0,
                  ),
                ),
              ),
              contentPadding: EdgeInsets.only(
                top: 10.0,
              ),
              title: Text(
                "Filter Categories",
                style: TextStyle(fontSize: 24.0),
              ),
              content: Container(
                height: 600,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
              flex: 5, 
              child: Container(
                width: double.maxFinite,
                 margin:  EdgeInsets.fromLTRB(20, 0, 20, 10),
                 decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,  // red as border color
                        ),
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.blue
                ),
                child: ListView.builder(
                shrinkWrap: true,
                itemCount: filterOptions.length,
                  padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                    itemBuilder: (context, int index) {
                      final alreadyFiltered = filtered.contains(filterOptions[index]);
                      return Padding(
                          padding: EdgeInsets.fromLTRB(20, 8, 20, 8),
                          child: Container(
                            margin:  EdgeInsets.fromLTRB(0, 0, 0, 0),
                            decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black,  // red as border color
                                    ),
                                    borderRadius: BorderRadius.circular(20.0),
                                    color: Colors.red[800]
                            ),
                            child: ListTile(
                            title: Text(
                              filterOptions[index],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              )
                            ),
                            enableFeedback: true,
                            trailing: Icon(    //Creates an icon
                              alreadyFiltered ? Icons.star : Icons.star_border, //if saved do filled, else just border
                              color: alreadyFiltered ? Colors.yellow : null,
                              semanticLabel: alreadyFiltered ? 'Remove from filtered' : 'Filter',
                            ), 
                            onTap: () { //Allows the tile to become interactive 
                              setState(() {
                                if (alreadyFiltered) {
                                  filtered.remove(filterOptions[index]);
                                } else {
                                  filtered.add(filterOptions[index]);
                                }
                              });               
                            },
                            )
                          )
                      );
                      
                        
                },
              ),

              )
              
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 0, 16),
                  child: FilterButton(
                  child: Text(
                    "Filter",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: (){
                    /**
                     * Prevents a user from filtering more than 10 items
                     */
                    if(filtered.length <= 10){
                      setFilters();
                    }else{
                      _showErrorDialog(context, "Please select up to 10 filters");
                    }
                    
                  },
              ),
                ),
              ],
            )
            
                    ],
                  ),
              )
            );
          }
        );
      });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
          child: Column(
            children: <Widget>[
              Container(
                color: Colors.blue,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text("The Events Calendar",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                    FilterButton(
                      child: Text("Filter",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      onPressed:(){
                        showFilters(

                        );
                      },
                    ),
                  ],
                ),
              ),
              
              Expanded(
                child: Calendar(
                  filters: (filteredApplied.length == 0) ? [] : filteredApplied
                      )
              )
              
            ]
          )
      );
  }

}

/**
 * The button that allows a user to filter
 */
class FilterButton extends StatelessWidget {
  const FilterButton({required this.child, required this.onPressed, super.key});
  final Widget child;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) => OutlinedButton(
        style: ButtonStyle(
            side: MaterialStateProperty.all(BorderSide(color: Colors.black)),
            backgroundColor: MaterialStateProperty.all(Colors.red[800]),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0))),
          ),
        onPressed: onPressed,
        child: child,
      );
}