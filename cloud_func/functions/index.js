const fetch = require("node-fetch");
const functions = require("firebase-functions");

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

// The Firebase Admin SDK to access Firestore.
const admin = require('firebase-admin');
admin.initializeApp();

function createTimeRange(startHR, endHR, startMin, endMin){
    start_label = "AM";
    end_label = "AM";
    if (Number(startHR) >= 12){
        start_label = "PM";
    }
    if (Number(endHR) >= 12){
        end_label = "PM";
    }
    startHR = String(Number(startHR) > 12 ? (Number(startHR) - 12) : Number(startHR));
    endHR = String(Number(endHR) > 12 ? (Number(endHR) - 12) : Number(endHR));
    return startHR + ":" + startMin + start_label + " - " + endHR +":" + endMin + end_label;
}
function getCategories(category_list){
    categories = [];
    for(var i = 0; i < category_list.length; i++){
        categories.push(category_list[i].name);
    }
    return categories;
}
function remove_unicode(str){
    if(str.includes("&amp;")){
      str = str.replaceAll("&amp;", "&");
    }
    if(str.includes("&#8211;")){
      str = str.replaceAll("&#8211;", "-");
    }
    if(str.includes("&#8217;")){
        str = str.replaceAll("&#8217;", "\'");
    }
    return str;
}

exports.updatePosts = functions.firestore.document('/updatedPosts/{documentId}')
    .onCreate(
    async (snap, context) => {
        const updatedData = snap.data();
        writeResult = await admin.firestore().collection("posts").doc(context.params.documentId).set({
            date: updatedData.date,
            body: updatedData.body,
            description: updatedData.description,
            title: updatedData.title,
            image: updatedData.image
        });
        admin.firestore().collection('updatedPosts').doc(context.params.documentId).delete();
    }
)


exports.getEvents = functions.pubsub.schedule('0 23 * * *')
    .timeZone('America/Chicago') 
    .onRun( async (context) => {
      const day = new Date();
      const year = String(day.getFullYear());
      const month = String(day.getMonth() + 1); 
      const date = String(day.getDate());
    
      const eventsRef = admin.firestore().collection('events');
      const snapshot = await eventsRef.get();
      await snapshot.forEach(doc => {
        data = doc.data();
        start_date = new Date(data["startDate"].split(" ")[0]);
        if(day <= start_date){
            admin.firestore().collection('events').doc(doc.id).delete();
        }
      });

      const options = {
        method: 'GET',
        headers: {
            'User-Agent': 'ANYTHING_WILL_WORK_HERE'
          }
      };

        for(var j = 1; j <= 4; j++){
            response = await fetch('https://chitribe.org/wp-json/tribe/events/v1/events?page=' + String(j) + '&per_page=200&start_date=' + year + '-' + month + "-" + date, options)
            calendarObj = await response.json()
            for(var i = 0; i < calendarObj.events.length; i++){
                item = calendarObj.events[i];
                functions.logger.log(i);
                functions.logger.log(String(item.id));
                writeResult = await admin.firestore().collection("events").doc(String(item.id)).set({
                                                                                    id: item.id,
                                                                                    title: remove_unicode(item.title), 
                                                                                    description: item.description,
                                                                                    siteUrl: item.website,
                                                                                    startDate: item.start_date,
                                                                                    endDate: item.end_date,
                                                                                    imgUrl: (item.image.url == undefined) ? "" : item.image.url,
                                                                                    organizer: (item.organizer.length == 0) ? "No organizer" : remove_unicode(item.organizer[0].organizer),
                                                                                    year: item.start_date_details.year,
                                                                                    month: item.start_date_details.month,
                                                                                    day: item.start_date_details.day,
                                                                                    time_range : createTimeRange(
                                                                                        item.start_date_details.hour,
                                                                                        item.end_date_details.hour,
                                                                                        item.start_date_details.minutes,
                                                                                        item.end_date_details.minutes,
                                                                                    ),
                                                                                    categories: getCategories(item.categories)
                                                                                });
                
            }
        }   
    }
);