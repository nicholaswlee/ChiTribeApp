import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import 'PostPage.dart';

/**
 * Defines the home page of the site, which displays all the difference posts
 */
class HomePage extends StatelessWidget{
   const HomePage({Key? key}) : super(key: key);
   @override
   Widget build(BuildContext context) {
     return PostInfo();
   }
} 
/**
 * Displays all the posts from the firebase post collection. Each post is clickable
 */
 class PostInfo extends StatefulWidget {
  @override
  PostInfoState createState() => PostInfoState();
}

class PostInfoState extends State<PostInfo> {
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('posts').orderBy("date", descending: true).snapshots();

  @override
  /**
   * Opens a post page given the post data.
   */
   void _pushPost(String title, String category, String body, String img, String date) {
    Navigator.of(context).push(
      // Add lines from here...
      MaterialPageRoute<void>(
        builder: (context) {
          return Scaffold(
            backgroundColor: Color.fromARGB(255, 246, 243, 200),
            appBar: AppBar(
              title: Text(
                      category,
                      style: TextStyle(
                        fontWeight: FontWeight.bold
                      )
                    ),
              backgroundColor: Colors.red[800],
            ),
            body: Center(
                child: PostPage(title, body, img, date),
            )
          );
        },
      ), // ...to here.
    );
  }
  /**
   * Converts the firebase doc data into a post data type.
   */
  List<Post> convertToPost(List<QueryDocumentSnapshot<Object?>> data){
    List<Post> posts = [];
    for(var i = 0; i < data.length; i++){
      Map<String, dynamic> document = data[i].data() as Map<String, dynamic>;
      if(document["category"] != null || document["description"] != null){
        if(document["category"] == null){
          document["category"] = "Uncategorized";
        }
        
        posts.add(Post.fromMap(document));
      }
    }
    return posts;
  }
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        return ListView(
          children: convertToPost(snapshot.data!.docs).map((Post data) {
            return ListTile(
              onTap: (() {
                _pushPost((data.title), data.category, data.body, data.img,
                          "${data.date.substring(5, 7)}/${data.date.substring(8, 10)}/${data.date.substring(0, 4)}");
              }),
              title: Container(

                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
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
                        child: Text(data.category,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold
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
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              /*Container(
                                padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
                                width: 200,*/
                              Expanded(
                                flex: 1,
                                child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    data.title,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold
                                    )
                                  ),
                                  Text(
                                    "${data.date.substring(5, 7)}/${data.date.substring(8, 10)}/${data.date.substring(0, 4)}",
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
                                  data.img, 
                                  height: 100, 
                                  width: 100,
                                  fit: BoxFit.contain
                                )
                              ),
                            ],
                        )
                      )
                    ]
                  
                  )
              )


            );
          }).toList(),
        );
      },
    );
  }
}
/**
 * Will try to give uncateogrized posts a category based on title.
 */
determineUncategorized(String category, String title){
  if(category == "Uncategorized"){
    if(title.contains("Jewish Person of the Week")){
      category = "Jewish Person of The Week";
    }else if(title.contains("Business of the Month")){
      category = "Business of the Month";
    }
  }
  return category;
}
/**
 * Defines a Post class, which stores all necessary post data.
 */
class Post{
  final String title;
  final String img;
  final String description;
  final String category;
  final String date;
  final String body;
  Post(
    {
    required this.title, 
    required this.img, 
    required this.description, 
    required this.category, 
    required this.date, 
    required this.body, 
  });
  factory Post.fromMap(Map<String, dynamic> map){
    return Post(
      title: map["title"], 
      img: map["image"], 
      description: map["description"] ?? "", 
      category: determineUncategorized(map["category"], map["title"]), 
      date: map["date"], 
      body: map["body"]
    );
  }
}