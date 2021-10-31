import 'package:election_exit_poll_07590493/name_item.dart';
import 'package:election_exit_poll_07590493/platform_aware_asset_image.dart';
import 'package:flutter/material.dart';

import 'api.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({
    Key? key,
  }) : super(key: key);

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  late Future<List<NameItem>> listCanVote;
  bool _isLoading = false;

  Future<List<NameItem>> _loadListName() async {
    List list = await Api().fetch('exit_poll/result');
    // print("res $list");
    var listName = list.map((item) => NameItem.fromJson(item)).toList();
    print("res $listName");
    return listName;
  }

  @override
  initState() {
    super.initState();
    listCanVote = _loadListName();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
        body: Container(
            padding: EdgeInsets.only(top: 40),
            decoration: BoxDecoration(
              image: const DecorationImage(
                  image: const AssetImage("assets/images/bg.png"),
                  fit: BoxFit.fill),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 130,
                  height: 130,
                  child: PlatformAwareAssetImage(
                    assetPath: 'assets/images/vote_hand.png',
                  ),
                ),
                Container(
                  child: Text(
                    "EXIT POLL",
                    style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.w700,
                        fontSize: 24),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  child: Text(
                    "RESULT",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 400,

                  child :
                  FutureBuilder<List<NameItem>>(
                    future: listCanVote,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState != ConnectionState.done) {
                        return Center(
                          child: CircularProgressIndicator(color: Colors.white60,),
                        );
                      }
                      if (snapshot.hasError) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('ผิดพลาด: ${snapshot.error}'),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    listCanVote = _loadListName();
                                  });
                                },
                                child: Text('RETRY'),
                              ),
                            ],
                          ),
                        );
                      }
                      if (snapshot.hasData == true) {
                        return ListView.builder(
                          padding: EdgeInsets.all(15),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (BuildContext context, int index) {
                            var item = snapshot.data![index];
                            return Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child : InkWell(

                                onTap: () {
                                  print("${item.number}");
                                },
                                child: Container(
                                  height: 45,
                                  decoration:
                                  BoxDecoration(color: Colors.white70),
                                  child: Row(

                                    children: [
                                      Align( alignment: Alignment.bottomCenter,
                                        child :
                                        Container(
                                          padding: EdgeInsets.only(top: 8),
                                          width: 45,
                                          height: 45,
                                          decoration:
                                          BoxDecoration(color: Colors.green),
                                          child: Text("${item.number}",style: TextStyle(color: Colors.white,fontSize: 24),textAlign: TextAlign.center,),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(left: 20),
                                        child: Text("${item.displayName}",style: TextStyle(fontSize: 16),),
                                      ),
                                      Expanded(child: Align(alignment: Alignment.centerRight,child :
                                      Container(
                                        padding: EdgeInsets.only(right: 10),
                                        child: Text("${item.score}",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700),),
                                      )
                                      ))
                                    ],
                                  ),
                                ),
                              ),
                            );

                          },);
                      }
                      return SizedBox.shrink();
                    },
                  ),
                ),

              ],
            )));
  }
}
