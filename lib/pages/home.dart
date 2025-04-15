import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final Map<String, dynamic> args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    final user = args['user'];
    final token = args['token'];

    Future <void> logout(BuildContext context) async {
      final localStorage = await SharedPreferences.getInstance();
      await localStorage.clear();
      Navigator.pushNamed(context, '/login');
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Image.asset('assets/images/logo.png',width: 50,),
        actions: [
          IconButton(onPressed: (){

          }, icon: Icon(Icons.notifications)),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await logout(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Text('Hello',style: TextStyle(fontSize: 24),),
                  SizedBox(width: 10,),
                  Text('${user['name']}',style: TextStyle(fontSize: 24,color: Colors.blue,fontWeight: FontWeight.bold),)
                ],
              ),
              Text('You are logged in REF')
            ],
          ),
        ),
      ),
    );
  }
}
