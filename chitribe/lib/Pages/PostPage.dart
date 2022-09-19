import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

/**
 * Displays the post page when someone clicks on an indiviudal post.
 */
class PostPage extends StatefulWidget {
  const PostPage(
    this.title,
    this.body,
    this.img,
    this.date
  );
  final String title;
  final String body;
  final String img;
  final String date;
  @override
    PostPageState createState() => PostPageState();
}

class PostPageState extends State<PostPage> {
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
                        widget.title,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          
                        ),
                      ),
              
              ),
              
              Image.network(widget.img),
              Container(
                width: double.infinity,
                child: Text(
                          " Date Posted: ${widget.date}",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
              ),
              Html(
                data: widget.body,
                //Allows for links on the page to be opened
                  onLinkTap: (url, _, __, ___) async {
                      if (await canLaunchUrl(Uri.parse(url!))) {
                        await launchUrl(
                          Uri.parse(url),
                        );
                      } 
                    },
              )
            ],
          )
      )
    );
    
  }
}