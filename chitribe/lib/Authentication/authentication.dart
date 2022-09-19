import 'package:chitribe/Authentication/skipAccount.dart';
import 'package:flutter/material.dart';
import '../Pages/CalendarPage.dart';
import '../Pages/FavoritedPage.dart';
import '../Pages/HomePage.dart';
import '../Pages/Settings.dart';
import 'auth_widgets.dart';

/**
 * Defines the different login states that can occur.
 */
enum ApplicationLoginState {
  loggedOut,
  emailAddress,
  register,
  password,
  loggedIn,
  skipAccount,
}
/**
 * Defines how the login/registration process works for a user. Displays different
 * pages depending on the loginState.
 */
class Authentication extends StatelessWidget {
  const Authentication({
    required this.loginState,
    required this.email,
    required this.startLoginFlow,
    required this.verifyEmail,
    required this.signInWithEmailAndPassword,
    required this.cancelRegistration,
    required this.registerAccount,
    required this.signOut,
    required this.deleteAccount,
    required this.skipAccountCreation,
    super.key,
  });

  final ApplicationLoginState loginState;
  final String? email;
  final void Function() startLoginFlow;
  final void Function() skipAccountCreation;
  final void Function(
    String email,
    void Function(Exception e) error,
  ) verifyEmail;
  final void Function(
    String email,
    String password,
    void Function(Exception e) error,
  ) signInWithEmailAndPassword;
  final void Function() cancelRegistration;
  final void Function(
    String email,
    String displayName,
    String password,
    void Function(Exception e) error,
  ) registerAccount;
  final void Function() signOut;
  final void Function() deleteAccount;

  @override
  Widget build(BuildContext context) {
    switch (loginState) {
      case ApplicationLoginState.loggedOut:
        return Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset('assets/logo.png', height: 200, fit: BoxFit.fitWidth),
                Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: StyledButton(
                    onPressed: () {
                      startLoginFlow();
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
            Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: StyledButton(
                    onPressed: () {
                      skipAccountCreation();
                    },
                    child: const Text(
                            '  Skip Account Creation  ',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                            ),),
                  ),
                ),
              ],
            )
          )
        );
      case ApplicationLoginState.emailAddress:
        return Scaffold(
          backgroundColor: Colors.white,
          body: Center( 
            child: EmailForm(
            callback: (email) => verifyEmail(
                email, 
            
            (e) => _showErrorDialog(context, 'Invalid email', e)), 
            cancel : (){signOut();},))
        );
      case ApplicationLoginState.password:
        return Scaffold (
          backgroundColor: Colors.white,
          body: Center ( 
            child: PasswordForm(
              email: email!,
              login: (email, password) {
                signInWithEmailAndPassword(email, password,
                    (e) => _showErrorDialog(context, 'Failed to sign in', e));
              },
            )
          )
        );
      case ApplicationLoginState.register:
        return Scaffold (
          backgroundColor: Colors.white,
          body: Center(
            
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
              RegisterForm(
                  email: email!,
                  cancel: () {
                    cancelRegistration();
                  },
                  registerAccount: (
                    email,
                    displayName,
                    password,
                  ) {
                    registerAccount(
                        email,
                        displayName,
                        password,
                        (e) =>
                            _showErrorDialog(context, 'Failed to create account', e));
                  },
                )
              ],
            )
          )
        );
        
      case ApplicationLoginState.loggedIn:
        return MyStatefulWidget(signOut: (){signOut();}, deleteAccount: (){deleteAccount();});
      case ApplicationLoginState.skipAccount:
          return NoAccount(startLoginFlow: startLoginFlow);
      default:
        return Scaffold(
          backgroundColor: Color.fromARGB(255, 246, 243, 200),
          body: Center(
            child: Row(
              children: const [
                Text("Internal error, this shouldn't happen..."),
              ],
            )
          )
      );
    }
  }

  void _showErrorDialog(BuildContext context, String title, Exception e) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            title,
            style: const TextStyle(fontSize: 24),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  '${(e as dynamic).message}',
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            StyledButton(
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
}
/**
 * Defines the frame of the app, meaning tab navigation and and access to the settings
 * page. The skeleton of the actual app.
 */
class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget(
    {
      required this.signOut,
      required this.deleteAccount
    }
  );
  final void Function() signOut;
  final void Function() deleteAccount;
  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    CalendarPage(),
    FavoritedPage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Settings(signOut: widget.signOut, deleteAccount: widget.deleteAccount),
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Image.asset('assets/logo.png', height: AppBar().preferredSize.height, fit: BoxFit.fitWidth),
        backgroundColor: Colors.black,
        
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.red[700],
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home,size:30),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month ,size:30),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite, size:30),
            label: 'Favorited',
          ),
        ],
        currentIndex: _selectedIndex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }
}
/**
 * Displays a form that asks for the users email to determine
 * to register a user or show them the login page.
 */
class EmailForm extends StatefulWidget {
  const EmailForm({required this.callback, required this.cancel, super.key});
  final void Function(String email) callback;
  final void Function() cancel;
  @override
  State<EmailForm> createState() => _EmailFormState();
}

class _EmailFormState extends State<EmailForm> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_EmailFormState');
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Header('What is your email?'),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: TextFormField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Enter your email',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter your email address to continue';
                      }
                      return null;
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: widget.cancel,
                      child: Text(
                        'CANCEL', 
                        style: TextStyle(
                          color: Colors.red[800],
                          fontWeight: FontWeight.bold,
                        ),
                        ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 30),
                      child: StyledButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            widget.callback(_controller.text);
                          }
                        },
                        child: const Text(
                          'NEXT',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/**
 * The form that allows a new user to register
 */
class RegisterForm extends StatefulWidget {
  const RegisterForm({
    required this.registerAccount,
    required this.cancel,
    required this.email,
    super.key,
  });
  final String email;
  final void Function(String email, String displayName, String password)
      registerAccount;
  final void Function() cancel;
  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_RegisterFormState');
  final _emailController = TextEditingController();
  final _displayNameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.email;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Header('Create account'),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      hintText: 'Enter your email',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter your email address to continue';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: TextFormField(
                    controller: _displayNameController,
                    decoration: const InputDecoration(
                      hintText: 'Full Name',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter your full name';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      hintText: 'Password',
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter your password';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: widget.cancel,
                        child: Text(
                          'CANCEL', 
                          style: TextStyle(
                            color: Colors.red[800],
                            fontWeight: FontWeight.bold,
                          ),
                          ),
                      ),
                      const SizedBox(width: 16),
                      StyledButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            widget.registerAccount(
                              _emailController.text,
                              _displayNameController.text,
                              _passwordController.text,
                            );
                          }
                        },
                        child: const Text(
                          'SAVE',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        
                        ),
                      ),
                      const SizedBox(width: 30),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/**
 * The form that allows a returning user to enter their password.
 */
class PasswordForm extends StatefulWidget {
  const PasswordForm({
    required this.login,
    required this.email,
    super.key,
  });
  final String email;
  final void Function(String email, String password) login;
  @override
  State<PasswordForm> createState() => _PasswordFormState();
}

class _PasswordFormState extends State<PasswordForm> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_PasswordFormState');
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.email;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Header('Sign in'),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      hintText: 'Enter your email',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter your email address to continue';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      hintText: 'Password',
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter your password';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const SizedBox(width: 16),
                      StyledButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            widget.login(
                              _emailController.text,
                              _passwordController.text,
                            );
                          }
                        },
                        child: const Text(
                          'SIGN IN', 
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      ),
                      const SizedBox(width: 30),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}