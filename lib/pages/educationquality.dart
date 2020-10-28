import 'package:flutter/material.dart';
import 'package:tarccaring_app/pages/lecturerlist.dart';
import 'package:tarccaring_app/users/user/pages/feedback_history.dart';
import 'package:tarccaring_app/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:tarccaring_app/widgets/size_config.dart';
import 'package:tarccaring_app/router/constant_route.dart';
import 'package:tarccaring_app/utils/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EducationQuality extends StatefulWidget {
  EducationQuality({this.lecturer_id, this.name, this.image,});
  final String lecturer_id;
  final String name;
  final String image;
  @override
  State<StatefulWidget> createState() { return new _EducationQuality();}
}

class _EducationQuality extends State<EducationQuality> {
  String _user;

  @override
  void initState() {
    super.initState();
    getID();
  }

  getID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _user = prefs.getString('id') ?? '';
    });
  }

  Future<void> _submit(BuildContext context) async{
    print(isSwitched);
    print(_comment.text.toString());
    print(_user);
    if(_comment.text.toString().trim() != null){
      var data = {
        'user_id' : _user,
        'lecturer_id' : widget.lecturer_id,
        'anonymous' : isSwitched,
        'comment' : _comment.text.toString(),
        'feedback_type' : 3,
      };
      var result = await APIService().postMethod(data, 'submit');
      var message = json.decode(result.body);
      if(message['success'] == true){
        showDialog(
          context: context,
          builder: (BuildContext  context) {
            return SimpleDialog(
              title: Text("Submit Successful!"),
              children: <Widget>[
                SimpleDialogOption(
                  onPressed: (){
                    Navigator.of(context).pushReplacementNamed(ManagementNavigationRoute);
                  },
                  child: const Text('OK')
                ),
              ],
            );
          },
        );
      } else{
        showDialog(
          context: context,
          builder: (BuildContext  context) {
            return AlertDialog(
              title: Text("Submit Failed!"),
              content: Text("Something goes wrong...."),
            );
          },
        );
      }
    } else{
      showDialog(
        context: context,
        builder: (BuildContext  context) {
          return AlertDialog(
            title: Text("Invalid Action."),
            content: Text("Please fill the comment."),
          );
        },
      );
    }
  }

  @override
  void dispose(){
    _comment.dispose();
    super.dispose();
  }

  bool isSwitched = false;
  final _comment = TextEditingController();
  File _image;

  @override
  Widget build(BuildContext context) {
    String todo = ModalRoute.of(context).settings.arguments;

    SizeConfig().init(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      backgroundColor: primaryColor,
      appBar: AppBar(
        elevation: 0,
        title: Text('Education Quality'),
        backgroundColor: primaryColor,
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Stack(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 0.5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 1),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Switch(
                            value: isSwitched,
                            onChanged: (value) {
                              setState(() {
                                isSwitched = value;
                                print(isSwitched);
                              });
                            },
                            activeTrackColor: Colors.lightGreenAccent,
                            activeColor: Colors.green,
                          ),
                        ),
                        Expanded(
                            flex: 3,
                            child: Text(
                              'ANONYMOUSLY',
                              style: new TextStyle(
                                fontSize: 13.0,
                                color: Colors.grey,
                              ),
                              textAlign: TextAlign.left,
                            )),
                        Expanded(
                            flex: 3,
                            child: Text(
                              '',
                              textAlign: TextAlign.center,
                            )),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(
                        defaultPadding * 1.5, SizeConfig.blockSizeVertical * 6, defaultPadding * 1.5, 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(),
                    ),
                    child: Stack(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.fromLTRB(
                              defaultPadding / 2, SizeConfig.blockSizeVertical * 19, defaultPadding / 2, 0),
                          //margin: EdgeInsets.all(defaultPadding / 2),
                          child: Column(children: <Widget>[
                            Expanded(
                              child: TextField(
                                controller: _comment,
                                keyboardType: TextInputType.multiline,
                                maxLines: 12,
                                style: TextStyle(fontSize: 15),
                                decoration: new InputDecoration(
                                    hintText: "Type your comment here....",
                                    hintStyle: TextStyle(fontSize: 15),
                                    contentPadding: const EdgeInsets.symmetric(vertical: 15,horizontal: 10),
                                    border: new OutlineInputBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                        bottomLeft: Radius.circular(20),
                                        bottomRight: Radius.circular(20),
                                      ),
                                      borderSide: new BorderSide(
                                          color: Colors.grey[100]),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white),
                              ),
                            ),
                          ]),
                        ),
                        Positioned(
                          top: SizeConfig.blockSizeVertical * 1.2,
                          left: SizeConfig.blockSizeVertical * 3,
                          right: SizeConfig.blockSizeVertical * 3,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: InkWell(
                                  onTap: () =>
                                      Navigator.of(context)
                                          .pushReplacementNamed(LecturerListRoute),
                                  child: Container(
                                    width: SizeConfig.blockSizeVertical * 1,
                                    height: SizeConfig.blockSizeVertical * 12,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: new DecorationImage(
                                        fit: BoxFit.cover,
                                        image: new NetworkImage(
                                            'http://10.0.2.2:8000/images/user/'+ widget.image),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: SizedBox(),
                              ),
                              Expanded(
                                  flex: 5,
                                  child: Text(
                                    widget.name,
                                    style: new TextStyle(
                                      fontSize: 20.0,
                                      color: Colors.black,
                                    ),
                                    textAlign: TextAlign.left,
                                  )),
                            ],
                          ),
                        ),
                        Positioned(
                          top: SizeConfig.blockSizeVertical * 15.5,
                          left: SizeConfig.blockSizeVertical * 2,
                          right: SizeConfig.blockSizeVertical * 2,
                          child: Text('Comment:'),
                        ),
                        /*Positioned(
                          top: SizeConfig.blockSizeVertical * 42.5,
                          left: SizeConfig.blockSizeVertical * 2,
                          right: SizeConfig.blockSizeVertical * 2,
                          child: Text('Attachment:'),
                        ),
                        Positioned(
                          top: SizeConfig.blockSizeVertical * 44.5,
                          left: SizeConfig.blockSizeVertical * 2,
                          right: SizeConfig.blockSizeVertical * 2,
                          child: Text(
                              '(optional)',
                            style: TextStyle(color: Colors.grey[500]),
                          ),
                        ),
                        Positioned(
                            top: SizeConfig.blockSizeVertical * 48,
                            left: SizeConfig.blockSizeVertical * 2,
                            right: SizeConfig.blockSizeVertical * 2,
                            child: FlatButton(
                              child: Text(
                                'UPLOAD VIDEO',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              color: primaryColor,
                              onPressed: () {},
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            )),*/
                        Positioned(
                          bottom: 50.0,
                          left: 10.0,
                          right: 10.0,
                          child: FlatButton(
                            child: Text(
                              'SUBMIT',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold),
                            ),
                            color: primaryColor,
                            onPressed: () {
                              _submit(context);
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
