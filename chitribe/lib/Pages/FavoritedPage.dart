import 'package:chitribe/Pages/EventsPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

 class FavoritedPage extends StatefulWidget{
   const FavoritedPage({Key? key}) : super(key: key);

  @override
  State<FavoritedPage> createState() => _FavoritedPageState();
}

class _FavoritedPageState extends State<FavoritedPage> {
  final Stream<DocumentSnapshot<Map<String, dynamic>>> users = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).snapshots(includeMetadataChanges: true);
   @override
  Widget build(BuildContext context) {
    
      return  StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: users,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return Text("Document does not exist");
          }
          if(snapshot.connectionState == ConnectionState.done || snapshot.connectionState == ConnectionState.active){
            Map<String, dynamic> userData = snapshot.data!.data() as Map<String, dynamic>;
            return Column(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.blue
                  ),
                  child: Text(
                    "Your Favorited Events",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 24,
                      
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child:
                  FavoritedView(userData["favoritedEvents"])
                ),
              ],
            );
          }
          return Text("Loading");

        }
      );
   }
}

class FavoritedView extends StatefulWidget{
  final List<dynamic> ids;
  const FavoritedView(this.ids);
  @override
  State<FavoritedView> createState() => FavoritedViewState();
}

class FavoritedViewState extends State<FavoritedView> {
    @override
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
              return Scaffold(
                backgroundColor: Color.fromARGB(255, 246, 243, 200),
                appBar: AppBar(
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back_ios_new_outlined),
                    onPressed:  () async {
                      if(isFavorited && !favorited.contains(event.id)){
                        favorited.add(event.id);
                        FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({'favoritedEvents' : favorited});

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
  List<QueryDocumentSnapshot<Object?>> sortByDate(List<QueryDocumentSnapshot<Object?>> docs){
    docs.sort((a, b) {
          return a["startDate"].compareTo(b["startDate"]);
        });
    return docs;
  }
  @override
   Widget build(BuildContext context) {
     late Stream<QuerySnapshot<Map<String, dynamic>>> _eventsStream = (widget.ids.isNotEmpty) ? FirebaseFirestore.instance.collection('events').where("id", whereIn: widget.ids).snapshots() 
                                                : FirebaseFirestore.instance.collection('users').where("id", isEqualTo: FirebaseAuth.instance.currentUser!.uid).snapshots() ;
      return  StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _eventsStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if(widget.ids.isEmpty){
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                      child: Text(
                              "You currently do not have any favorited events",
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 18
                              ),
                            )
                    ),
            );
          }
          if (snapshot.hasError) {
              return Text('Something went wrong');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading ${widget.ids}");
            }
            return ListView(
              children: sortByDate(snapshot.data!.docs).map((DocumentSnapshot document) {  
                Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                EventItem event = new EventItem.fromFirebase(data);
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
                        child: Text(event.name,
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
                                      _pushPost(event, widget.ids);
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
                                                  "Organizer: ${event.organizer}",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold
                                                  )
                                                ),
                                                Text(
                                                  "${event.monthName} ${event.day}, ${event.timeRange}",
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
                                      event.imgUrl ?? "https://chitribe.org/wp-content/uploads/2019/02/51376315_10157313150659924_4463146571655020544_o.jpg",
                                        height: 80, 
                                        width: 100,
                                        fit: BoxFit.contain
                                      )
                                    ),
                                  ],
                                )
                        ),
                      ),
                    ],
                  ),
                );
              }
            ).toList()
            );

        }
      );
   }
}