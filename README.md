# About the ChiTribeApp
The ChiTribe App was created by me to bring the site https://chitribe.org to a mobile application. The app was created by solely by myself using Flutter and backend through Google Firebase.
![Apple iPhone 11 Pro Max Presentation-2](https://user-images.githubusercontent.com/92129167/190951075-56548a07-d5a4-4581-a1bf-a72465c1b4e8.png)

## ChiTribe
This directory contains all the code for the actual application. The code written in dart that the app is composed of is in the lib directory. The ChiTribe app has three core pages: Posts, Events, and Favorites. 

### Posts

### Events

### Favorites

## Cloud Functions
We use google cloud functions to enable our app to have a backend. Currently there are two cloud functions that are in use to retrieve API Event data and updating our posts.

### updatePosts
This allows our posts on the app to become updated after they have been published. We use zapier to send wordpress posts to firebase, and zapier cannot edit existing firebase documents. Instead this function allows those documents to be edited by creating a new document in a seperate updatedPosts collection in firebase. 

### getEvents
This retrieves up to 200 events from The Events Calendar REST API endpoint. We send a GET request to the endpoint https://chitribe.org/wp-json/tribe/events/v1/events retrieve all the events from The ChiTribe Events Calendar. These events are then processed and then documents are created to store these events. These events are refresehd daily to be as updated as possible.
