library catalog_tree;
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:image_form_field/image_form_field.dart';
import 'package:thumbnails/thumbnails.dart';
import 'dart:io';
import 'dart:ui' as Ui;
import 'package:flutter/foundation.dart';
import 'dart:typed_data';


part 'view/home_view.dart';
part 'view/splash.dart';
part 'view/node/node_form.dart';
part 'auth/authentication.dart';
part 'data/db.dart';
part 'graph/icons.dart';
part 'model/acl.dart';
part 'model/node.dart';
part 'model/node-container.dart';
part 'model/video.dart';
part 'view/node/which_leaf.dart';
part 'util/form/file_picker.dart';
part 'util/video_thumbnail.dart';
part 'util/video_input_adapter.dart';

class Landing extends StatefulWidget {
  Landing({Key key, this.title, this.childrenNodes}) : super(key: key);
  final List<NodeContainer> childrenNodes;

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  final String title;

  @override
  _LandingState createState() {
    var homeState =  _LandingState();
    homeState.childrenNodes = childrenNodes;
    return homeState;
  }
}

class _LandingState extends State<Landing> {

  List<NodeContainer> childrenNodes;


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Forest',
      home: new SplashPage(),
      routes: <String, WidgetBuilder>{
        '/root':(BuildContext context) => new NodeView(childrenNodes: new List<NodeContainer>(), isRoot: true)
      },
    );
  }
}