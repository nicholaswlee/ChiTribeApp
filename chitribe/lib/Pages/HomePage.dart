import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import 'PostPage.dart';

 class HomePage extends StatelessWidget{
   const HomePage({Key? key}) : super(key: key);
   //final _htmlContent = '''<p class="has-medium-font-size">Meet Audrey Hutnick of Smallwave Marketing, ChiTribe&#8217;s business of the month. Audrey is originally from Chicago and loves to inspire business growth through attainable and affordable marketing. Smallwave Marketing is a champion for small businesses and nonprofits.&nbsp;They provide&nbsp;customized marketing strategies and expert support. Whether you are looking for a sounding board, a detailed marketing action plan, or help with execution Smallwave Marketing is there for you.</p> <p style="font-size:25px"><strong>Where are you from?</strong></p> <p style="font-size:18px"> Chicago, Illinois</p> <p style="font-size:25px"><strong>What did you do Jewish growing up?</strong></p> <p style="font-size:18px">Growing up, I was active in the conservative Jewish community in Chicago. I began my Jewish education at Shaare Tikvah preschool in the city. It was there that I met some of my best childhood friends. I then went on to attend Solomon Schechter Day School from kindergarten to eighth&nbsp;grade.&nbsp;</p> <p style="font-size:25px"><strong>What do you do for fun?&nbsp;</strong></p> <p style="font-size:18px">Road trip across the country! If you talked to me over this last year, I was likely packing up the car to follow the sun and avoid another winter in Chicago.&nbsp;</p> <p style="font-size:25px"><strong>When did you start your&nbsp;business?</strong></p> <p style="font-size:18px">May of 2020 at the very beginning of the pandemic in the thick of our shelter-in-place.</p> <figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="576" src="https://chitribe.org/wp-content/uploads/2022/06/4-1-1024x576.png" alt="" class="wp-image-51141" srcset="https://chitribe.org/wp-content/uploads/2022/06/4-1-1024x576.png 1024w, https://chitribe.org/wp-content/uploads/2022/06/4-1-300x169.png 300w, https://chitribe.org/wp-content/uploads/2022/06/4-1-768x432.png 768w, https://chitribe.org/wp-content/uploads/2022/06/4-1-1536x864.png 1536w, https://chitribe.org/wp-content/uploads/2022/06/4-1.png 1920w" sizes="(max-width: 1024px) 100vw, 1024px" /></figure> <p style="font-size:25px"><strong>Where is your&nbsp;business&nbsp;located?&nbsp;</strong></p> <p style="font-size:18px">Online! Although our official headquarters are technically in Chicago. We have built our business to be 100% virtual and remote.&nbsp;</p> <figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="576" src="https://chitribe.org/wp-content/uploads/2022/06/2-3-1024x576.png" alt="" class="wp-image-51139" srcset="https://chitribe.org/wp-content/uploads/2022/06/2-3-1024x576.png 1024w, https://chitribe.org/wp-content/uploads/2022/06/2-3-300x169.png 300w, https://chitribe.org/wp-content/uploads/2022/06/2-3-768x432.png 768w, https://chitribe.org/wp-content/uploads/2022/06/2-3-1536x864.png 1536w, https://chitribe.org/wp-content/uploads/2022/06/2-3.png 1920w" sizes="(max-width: 1024px) 100vw, 1024px" /></figure> <p style="font-size:25px"><strong>What products/services does your&nbsp;business&nbsp;offer?</strong></p> <p style="font-size:18px">We support nonprofits and purpose-driven small businesses who are looking to engage with their audience.&nbsp;</p> <p style="font-size:18px">1) We begin with a two hour marketing assessment offered at a pay-what-you-can model&nbsp;</p> <p style="font-size:18px">2) We then create a customized marketing strategy based on our assessment&nbsp;</p> <p>3) In our final phase, we provide the expertise to make it all happen. Our small but mighty team of creatives will take your marketing strategy and bring it to life</p> <p>We also support women business owners who are expectant mothers. It can be so overwhelming to figure out what a small business parental leave looks like and how to make it happen. Our team will work to provide project management and client relations so that mothers can focus on their new bundle of joy.</p> <p style="font-size:25px"><strong>How have you stayed motivated during the Pandemic?</strong></p> <p style="font-size:18px">I have kept my motivation by striving to be very intentional about the life I WANT to live rather than letting the habits and schedules guide the way. I began the pandemic dealing with a layoff, unemployment, and job searching. I found myself constantly upset and discouraged after receiving rejection after rejection for positions I didn&#8217;t really want and ultimately would be miserable at. That&#8217;s when I decided to take the leap and start my own business. Was it scary? Yes. Was it worth it? Absolutely!</p> <p style="font-size:18px">This mindset of staying very intentional also played a part in where I am living today. When it came time to figure out where to live in 2021, the easy answer was to find an apartment in Chicago. Then the ideas started to flow in about all the other beautiful places in this country. So I packed up the car with my husband and dog. We started our nomadic life and began our year long road trip throughout the U.S.</p> <p style="font-size:25px"><strong>What are your goals for your&nbsp;business?</strong></p> <p style="font-size:18px">My main goal is to continue to shape Smallwave Marketing into a business that supports strong and empowered women. I want Smallwave Marketing to be an avenue to support myself, my business partner, and our amazing team who want to work and grow a family.&nbsp;</p> <figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="576" src="https://chitribe.org/wp-content/uploads/2022/06/3-3-1024x576.png" alt="" class="wp-image-51140" srcset="https://chitribe.org/wp-content/uploads/2022/06/3-3-1024x576.png 1024w, https://chitribe.org/wp-content/uploads/2022/06/3-3-300x169.png 300w, https://chitribe.org/wp-content/uploads/2022/06/3-3-768x432.png 768w, https://chitribe.org/wp-content/uploads/2022/06/3-3-1536x864.png 1536w, https://chitribe.org/wp-content/uploads/2022/06/3-3.png 1920w" sizes="(max-width: 1024px) 100vw, 1024px" /></figure> <p style="font-size:25px"><strong>Complete the phrase&#8230; When the Tribe Gathers&#8230;</strong></p> <p style="font-size:18px">We are all better!</p> <p><strong>Include any links to social or websites you want to be included!</strong></p> <p>Website: <a href="https://www.smallwavemarketing.com/">https://www.smallwavemarketing.com/</a></p> <p>Instagram: <a href="https://www.instagram.com/smallwavemarketing/">https://www.instagram.com/smallwavemarketing/</a></p> <p>Linkedin: <a href="https://www.linkedin.com/company/smallwave-marketing/">https://www.linkedin.com/company/smallwave-marketing/</a></p> ''';
   @override
   Widget build(BuildContext context) {
     return PostInfo();/*SingleChildScrollView(
          child: Html(
            data: _htmlContent,
            
          )
        );*/

   }

 } 

 class PostInfo extends StatefulWidget {
  @override
    PostInfoState createState() => PostInfoState();
}

class PostInfoState extends State<PostInfo> {
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('posts').orderBy("date", descending: true).snapshots();

  @override
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
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            
          Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
            return ListTile(
              onTap: (() {
                _pushPost((data["title"] ?? " "), data["category"] ?? "Uncategorized", data["body"] ?? " ", data["image"] ?? "assets/logo.png",
                          "${data["date"].substring(5, 7)}/${data["date"].substring(8, 10)}/${data["date"].substring(0, 4)}");
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
                  height: 200,
                  child: Column(
                      children: <Widget>[
                      Container(
                        padding: EdgeInsets.fromLTRB(16, 16, 0, 0),
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.red[800],
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: Text(data["category"] ?? "Uncategorized",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold
                                )
                        )
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                        height: 148,
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
                                    data["title"],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold
                                    )
                                  ),
                                  Text(
                                    "${data["date"].substring(5, 7)}/${data["date"].substring(8, 10)}/${data["date"].substring(0, 4)}",
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
                                  data["image"] ?? "assets/logo.png", 
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