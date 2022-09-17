import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../Authentication/auth_widgets.dart';
import 'Calendar.dart';

class FakeFavoritedPage extends StatefulWidget{
  const FakeFavoritedPage({
    required this.startLoginFlow,
  });
  final void Function() startLoginFlow;
  @override
  FakeFavoritedPageState createState() => FakeFavoritedPageState();
}

class FakeFavoritedPageState extends State<FakeFavoritedPage> {

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
                    Text("Favorites Page",
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
                      child: Text("To access the favorites page, you must create an account",
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