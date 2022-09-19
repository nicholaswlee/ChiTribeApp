# About the ChiTribeApp
The ChiTribe App was created by me to bring the site https://chitribe.org to a mobile application. The app was created by solely by myself using Flutter and backend through Google Firebase. It can be found on the app store [here](https://apps.apple.com/app/chitribe/id1643074096).
![Apple iPhone 11 Pro Max Presentation-2](https://user-images.githubusercontent.com/92129167/190951075-56548a07-d5a4-4581-a1bf-a72465c1b4e8.png)

## ChiTribe Page
This directory contains all the code for the actual application. The code written in dart that the app is composed of is in the lib directory. The ChiTribe app has three core pages: Posts, Events, and Favorites. 

### Posts Page
The posts page displays all of the wordpress posts that are published on the ChiTribe site. These posts are sent to our Firebase Firestore database through Zapier. 

### Events Page
The Events Page displays our events calendar and up to 200 events that are on the ChiTrbe calendar. These events are stored in Firebase Firestore and are retrieved through our Google Cloud Function getEvents(). This event page is also filterable by up to 10 categories by using Firebase Firestore queries. 

### Favorites Page
The Favorites Page displays all the events that a user has favorited. This is done by storing all the unique event ids to every user to ensure maximum efficiency for the app. 

## Cloud Functions
We use Google Cloud Functions to enable our app to have a backend. Currently there are two cloud functions that are in use to retrieve API Event data and updating our posts.

### updatePosts
This allows our posts on the app to become updated after they have been published. We use zapier to send wordpress posts to firebase, and zapier cannot edit existing firebase documents. Instead this function allows those documents to be edited by creating a new document in a seperate updatedPosts collection in firebase. 

### getEvents
This retrieves up to 200 events from The Events Calendar REST API endpoint. We send a GET request to the endpoint https://chitribe.org/wp-json/tribe/events/v1/events retrieve all the events from The ChiTribe Events Calendar. These events are then processed and then documents are created to store these events. These events are refresehd daily to be as updated as possible.
