import 'package:election_exit_poll_07590493/name_item.dart';
import 'package:election_exit_poll_07590493/platform_aware_asset_image.dart';
import 'package:election_exit_poll_07590493/result_vote.dart';
import 'package:flutter/material.dart';

import 'api.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<NameItem>> listCanVote;
  bool _isLoading = false;

  Future<List<NameItem>> _loadListName() async {
    List list = await Api().fetch('exit_poll');
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

    void _showMaterialDialog(String title, String msg,List number) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text("$msg $number" , style: Theme.of(context).textTheme.bodyText2),
            actions: [
              // ปุ่ม OK ใน dialog
              TextButton(
                child: const Text('OK',style: TextStyle(color: Colors.purple),),
                onPressed: () {
                  // ปิด dialog
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    Future<bool?> _onVote(int number) async {
      try {
        setState(() {
          _isLoading = true;
        });

        List isSuccessVote = (await Api().submit('exit_poll', {'candidateNumber': number,}));
        if(isSuccessVote != null)
        {
          print("$isSuccessVote");
          _showMaterialDialog('SUCCESS','บันทึกข้อมูลำเร็จ',isSuccessVote);
        }
      } catch (e) {
        print(e);

        return null;
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
    return Scaffold(
        body:
        Stack( children : [
        Container(
            padding: EdgeInsets.only(top: 40),
            decoration: BoxDecoration(
              image: const DecorationImage(
                  image: const AssetImage("assets/images/bg.png"),
                  fit: BoxFit.fill),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
                    "เลือกตั้ง อบต.",
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
                  child: Text(
                    "รายชื่อผู้สมัครรับเลือกตั้ง",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
                Container(
                  child: Text(
                    "นายกองค์การบริหารส่วนตำบลเขาพระ",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
                Container(
                  child: Text(
                    "อำเภอเมืองนครนายก จังหวัดนตรนายก",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
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
                        child: CircularProgressIndicator(),
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
                                  _onVote(item.number);
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
                                      child: Text("${item.number}",style: TextStyle(color: Colors.white,fontSize: 24,fontWeight: FontWeight.w700),textAlign: TextAlign.center,),
                                    ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(left: 20),
                                      child: Text("${item.displayName}",style: TextStyle(fontSize: 16),),
                                    )

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
                Expanded(
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(primary: Colors.purple),
                            onPressed: () {
                              //Api().fetch("exit_poll");
                              Navigator.push(context, MaterialPageRoute(builder: (context) => ResultPage()));
                              print(listCanVote);
                            },
                            child: Text("ดูผล"),
                          ),
                        )))
              ],
            ),
        ),
          if(_isLoading)
            Container(
              color: Colors.black.withOpacity(0.35),
              child: Center(
                child: SizedBox(child:
                CircularProgressIndicator(color: Colors.white60,),
                ),
              ),
            )
    ]
        )
    );
  }
}
