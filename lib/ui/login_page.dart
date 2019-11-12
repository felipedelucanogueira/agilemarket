import 'package:authenticator/authenticator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'dart:convert';

import 'checkout_page.dart';


class Login_Page extends StatefulWidget {
  @override
  _Login_PageState createState() => _Login_PageState();
}

class _Login_PageState extends State<Login_Page> {
  final fbLogin = FacebookLogin();
  var auth = Authenticator();

  @override

  Widget build(BuildContext context) {

    return Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Color(0Xff7888F0),
        body: Stack(
          children: <Widget>[
            Container(
              child: FlareActor(
                "assets/Flow_background.flr",
                animation: "Flow",
                fit: BoxFit.fill,
              ),
            ),
            Container(
                child: Padding(
                    padding: EdgeInsets.only(
                        top: 110, bottom: 110, left: 40, right: 40),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: Container(
                        color: Colors.blue[50],
                        child: Stack(
                          children: <Widget>[
                            Center(
                              child: Column(
                                children: <Widget>[
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Text(
                                    "LOGIN",
                                    textScaleFactor: 1.5,
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Column(
                                      children: <Widget>[
                                        Divider(
                                          color: Colors.blueAccent,
                                        ),
                                        Divider(
                                          color: Colors.transparent,
                                        ),
                                        TextField(
                                          decoration: InputDecoration(
                                              filled: true,
                                              prefixIcon: Icon(Icons.person),
                                              hintText: "Email",
                                              fillColor: Colors.transparent,
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                borderSide: BorderSide(
                                                    width: 1,
                                                    color: Colors.blue),
                                              )),
                                        ),
                                        Divider(
                                          color: Colors.transparent,
                                          height: 32,
                                        ),
                                        TextField(
                                          decoration: InputDecoration(
                                              filled: true,
                                              prefixIcon: Icon(Icons.lock),
                                              hintText: "Senha",
                                              fillColor: Colors.transparent,
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                borderSide: BorderSide(
                                                    width: 1,
                                                    color: Colors.blue),
                                              )),
                                        ),
                                        Divider(
                                          color: Colors.transparent,
                                        ),
                                        RaisedButton(
                                          color: Colors.blue[50],
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              side: BorderSide(
                                                  color: Colors.blue)),
                                          onPressed: () {
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => Checkout()));
                                          },
                                          child: SizedBox(
                                            width: 100,
                                            child: Center(
                                              child: Text(
                                                "Login",
                                                style: TextStyle(
                                                    color: Colors.blue,
                                                    fontSize: 20),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  FacebookSignInButton(
                                    onPressed: ()  async {
                                      final facebooklogin = FacebookLogin();
                                      final result = await facebooklogin.logIn(['email','public_profile']);
                                      final FacebookAccessToken accessToken = result.accessToken;
                                      AuthCredential credential = FacebookAuthProvider.getCredential(accessToken: accessToken.token);
                                      switch(result.status){
                                        case FacebookLoginStatus.loggedIn:
                                          FirebaseAuth.instance.signInWithCredential(credential).then((signedInUser) {
                                            print('Logado como ${signedInUser.user}',
                                            );
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => Checkout()));
                                          });
                                          break;
                                        case FacebookLoginStatus.cancelledByUser:
                                        // TODO: Handle this case.
                                          break;
                                        case FacebookLoginStatus.error:
                                        // TODO: Handle this case.
                                          break;
                                      }




                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )))
          ],
        ));
  }
}
// teste
