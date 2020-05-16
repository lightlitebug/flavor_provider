import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proxyprov/providers/auth.dart';
import 'package:proxyprov/screens/dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _submitting = false;
  bool _checkingLoggedIn = true;

  @override
  void initState() {
    super.initState();
    _checkLoggedIn();
  }

  _checkLoggedIn() async {
    try {
      final bool isLoggedIn = await Provider.of<AuthProvider>(
        context,
        listen: false,
      ).tyrAutoLogin();

      if (isLoggedIn) {
        Navigator.of(context).pushReplacementNamed(
          DashboardScreen.routeName,
        );
      } else {
        setState(() => _checkingLoggedIn = false);
      }
    } catch (e) {
      print(e);
      setState(() => _checkingLoggedIn = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_checkingLoggedIn) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Flavor & Provider'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Flavor & Provider'),
      ),
      body: Center(
        child: _submitting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : RaisedButton(
                child: Text(
                  'LOGIN',
                  style: TextStyle(fontSize: 20.0),
                ),
                onPressed: () async {
                  try {
                    setState(() => _submitting = true);

                    await Provider.of<AuthProvider>(
                      context,
                      listen: false,
                    ).login();

                    setState(() => _submitting = false);
                    Navigator.of(context).pushReplacementNamed(
                      DashboardScreen.routeName,
                    );
                  } catch (e) {
                    print(e);
                    setState(() => _submitting = false);
                  }
                },
              ),
      ),
    );
  }
}
