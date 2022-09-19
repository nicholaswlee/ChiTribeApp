import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../Authentication/auth_widgets.dart';
import 'Calendar.dart';

/**
 * Shows the fake event page for when a user is not logged in. This is for the apple requirement
 */
class FakeEventPage extends StatefulWidget{
  const FakeEventPage({
    required this.startLoginFlow,
  });
  final void Function() startLoginFlow;
  @override
  FakeEventPageState createState() => FakeEventPageState();
}

class FakeEventPageState extends State<FakeEventPage> {

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
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: Text("To access the calendar, you must create an account.",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            
                          ),
                        textAlign: TextAlign.center,
                      ),
                    ),
              Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: StyledButton(
                    onPressed: () {
                      widget.startLoginFlow();
                    },
                    child: const Text(
                            'Sign In / Create Account',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                            ),),
                  ),
                ),
                  ],
                ),
              ),

              
              
            ]
          )
      );
  }

}

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