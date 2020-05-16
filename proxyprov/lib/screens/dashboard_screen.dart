import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proxyprov/providers/app_config.dart';
import 'package:proxyprov/providers/auth.dart';
import 'package:proxyprov/providers/get_data.dart';
import 'package:proxyprov/screens/login_screen.dart';

class DashboardScreen extends StatefulWidget {
  static const String routeName = '/dashboard';

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    _getData();
  }

  _getData() async {
    await Provider.of<GetDataProvider>(context, listen: false).getData();
  }

  @override
  Widget build(BuildContext context) {
    final mode = Provider.of<AppConfig>(context);
    final message = Provider.of<GetDataProvider>(context).message;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          mode.buildFlavor == 'dev' ? 'Dev Dashboard' : 'Prod Dashboard',
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () async {
              await Provider.of<AuthProvider>(
                context,
                listen: false,
              ).logout();
              Navigator.of(context).pushNamedAndRemoveUntil(
                LoginScreen.routeName,
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Text(
          'Message Received: $message',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
