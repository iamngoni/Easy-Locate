import 'package:date_time_format/date_time_format.dart';
import 'package:easy_locate/api/apiCalls.dart';
import 'package:easy_locate/statics/static.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:toast/toast.dart';

class CommentsView extends StatefulWidget {
  String productId;
  CommentsView(this.productId);
  @override
  _CommentsViewState createState() => _CommentsViewState();
}

class _CommentsViewState extends State<CommentsView> {
  Future<dynamic> _place;
  ApiCalls _api = new ApiCalls();
  final _formKey = GlobalKey<FormState>();
  String _comment;
  var _comments;
  bool _isSending = false;
  @override
  void initState() {
    _place = _api.getActualLocation();
    _comments = _api.getComments(this.widget.productId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Statics _statics = new Statics(context);
    return ModalProgressHUD(
      inAsyncCall: _isSending,
      child: SafeArea(
        child: Scaffold(
          body: Container(
            child: ListView(
              scrollDirection: Axis.vertical,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: InkWell(
                              onTap: () => Navigator.of(context).pop(),
                              child: Icon(
                                Icons.arrow_back,
                                size: 30,
                              ),
                            ),
                          ),
                          SizedBox(width: 5),
                          Text(
                            "Comments",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.location_on,
                            size: 27,
                            color: Colors.grey,
                          ),
                          FutureBuilder(
                            future: _place,
                            // ignore: missing_return
                            builder: (context, snapshot) {
                              while (!snapshot.hasData) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5.0),
                                  child: SizedBox(
                                    height: 18,
                                    width: 18,
                                    child: CircularProgressIndicator(
                                      backgroundColor: _statics.purplish,
                                    ),
                                  ),
                                );
                              }
                              var place = snapshot.data;
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text("${place.name}"),
                                  Text("${place.country}"),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  height: _statics.height * 0.9,
                  width: _statics.width,
                  color: _statics.purplish,
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          height: _statics.height * 0.6,
                          width: _statics.width,
                          child: FutureBuilder(
                            future: _comments,
                            // ignore: missing_return
                            builder: (context, snapshot) {
                              while (!snapshot.hasData) {
                                print("no comments");
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              var comments = snapshot.data;
                              print(comments);
                              if (comments.length == 0 || comments.length < 1) {
                                return Center(
                                  child: Text(
                                    "No comments have been posted on this product",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                );
                              }
                              return ListView.builder(
                                itemCount: comments.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Card(
                                      elevation: 20,
                                      child: Container(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.person_outline,
                                                        size: 18,
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                        comments[index]["user"]
                                                            ["name"],
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Text(
                                                    "${DateTimeFormat.format(DateTime.parse(comments[index]["timestamp"]), format: 'D, M j, H:i')}",
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.email,
                                                    size: 18,
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    comments[index]["comment"],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                      Container(
                        child: Form(
                          key: _formKey,
                          child: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      gapPadding: 1.0,
                                      borderSide: BorderSide(
                                        color: Colors.white,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.white,
                                        width: 1.0,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.white,
                                        width: 1.0,
                                      ),
                                    ),
                                    labelText: "Post A Comment",
                                    labelStyle: TextStyle(
                                      color: Colors.white,
                                    ),
                                    hintText: "I like the product",
                                    hintStyle: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  // ignore: missing_return
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "Comment cannot be empty";
                                    } else {
                                      setState(() {
                                        _comment = value;
                                      });
                                    }
                                  },
                                ),
                              ),
                              Positioned(
                                bottom: 12,
                                right: 10,
                                child: GestureDetector(
                                  onTap: () async {
                                    if (_formKey.currentState.validate()) {
                                      setState(() {
                                        _isSending = true;
                                      });
                                      var res = await _api.postComment(
                                          this.widget.productId, _comment);
                                      if (res) {
                                        setState(() {
                                          _isSending = false;
                                        });
                                        Toast.show(
                                          "Success",
                                          context,
                                          gravity: Toast.BOTTOM,
                                          duration: Toast.LENGTH_SHORT,
                                        );
                                        Navigator.of(context).pop();
                                      } else {
                                        setState(() {
                                          _isSending = false;
                                        });
                                        Toast.show(
                                          "Failed",
                                          context,
                                          gravity: Toast.BOTTOM,
                                          duration: Toast.LENGTH_SHORT,
                                        );
                                      }
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CircleAvatar(
                                      child: Icon(
                                        Icons.send,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
