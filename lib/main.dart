import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import 'constant/colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: IndividualPages(),
    );
  }
}

class IndividualPages extends StatefulWidget {
  const IndividualPages({Key? key}) : super(key: key);

  @override
  State<IndividualPages> createState() => _IndividualPagesState();
}

class _IndividualPagesState extends State<IndividualPages>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  bool buttonStatus = false;


  List _items = [];

// Fetch content from the json file
  readJson() async {
    final String response = await rootBundle.loadString('local_json/data.json');
    final data = await json.decode(response);
    setState(() {
      // print(data[0]);
      _items = data as List;
      print(_items);
    });
  }

  @override
  void initState() {

    _tabController = TabController(length: 2, vsync: this);
    readJson();
    super.initState();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: ConstantColor.buttonColor,
      appBar: AppBar(
        backgroundColor: ConstantColor.buttonColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: ConstantColor.iconColor,
          ),
          onPressed: () {},
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(0),
        child: Column(
          children: [
            TabBar(
              controller: _tabController,
              physics: const BouncingScrollPhysics(),
              indicatorSize: TabBarIndicatorSize.label,
              indicator: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: ConstantColor.grayColor,
                  ),
                ),
              ),
              // labelColor: Colors.white,
              unselectedLabelColor: ConstantColor.grayColor.withOpacity(0.3),
              automaticIndicatorColorAdjustment: true,
              labelStyle: const TextStyle(
                  fontWeight: FontWeight.w800, fontFamily: "Avenir"),
              tabs: [
                Tab(
                  child: tabTitle('Admin Room'),
                ),
                Tab(
                  text: 'Hall',
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                physics: const BouncingScrollPhysics(),
                controller: _tabController,
                children: [
                  /// First Screen...................................
                  Stack(
                    children: [
                      ///Image Container
                      Positioned(
                        top: height * 0.02,
                        left: 0,
                        right: 0,
                        child: Container(
                            height: height * 0.25,
                            decoration: BoxDecoration(),
                            child: Image.asset(
                              'assets/admin_room.png',
                              fit: BoxFit.fill,
                            )),
                      ),

                      ///Button Container
                      Positioned(
                        top: height * 0.25,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: height * 0.99,
                          decoration: const BoxDecoration(
                            color: ConstantColor.backgroundColor,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                          child: GridView.builder(
                                  itemCount: _items.length,
                                  physics: const BouncingScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 2 / 2.3,
                                    crossAxisSpacing: 0,
                                    mainAxisSpacing: 20,
                                  ),
                                  itemBuilder: (
                                    BuildContext context,
                                    index,
                                  ) {
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _items[index]['Device_Status'] = !_items[index]['Device_Status'];
                                          print(buttonStatus);
                                        });
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.all(15),
                                        decoration: const BoxDecoration(
                                          color: ConstantColor.buttonColor,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(20),
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            AutoSizeText(
                                              _items[index]['Device_Name'],
                                              style: TextStyle(
                                                  fontSize: height * 0.025,
                                                  color:
                                                      ConstantColor.grayColor),
                                            ),
                                            _items[index]['Device_Status'] ==
                                                    true
                                                ? Image.asset(
                                                    'assets/switch_On.png',
                                                    scale: 4.0,
                                                  )
                                                : Image.asset(
                                                    'assets/switch_Off.png',
                                                    scale: 4.0,
                                                  ),
                                            AutoSizeText(
                                              _items[index]['Device_Status'] ==
                                                      true
                                                  ? 'ON'
                                                  : 'OFF',
                                              style: TextStyle(
                                                  fontSize: height * 0.025,
                                                  color:
                                                      ConstantColor.grayColor),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                        ),

                    ],
                  ),

                  ///Second Screen...................................
                  Column(
                    children: [
                      ElevatedButton(
                        child: const Text('Load Data'),
                        onPressed: (){
                          setState(() {
                            readJson();
                          });
                        },
                      ),

                      // Display the data loaded from sample.json
                       Container(
                        height: 500,
                            child: ListView.builder(
                              itemCount: _items.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: (){
                                    setState(() {
                                      _items[index]["Device_Status"] = !_items[index]["Device_Status"];
                                      print( _items[index]["Device_Status"]);
                                    });
                                  },
                                  child: Card(
                                    margin: const EdgeInsets.all(10),
                                    child: ListTile(
                                      // leading: Text('id : ${_items[index]["id"].toString()}'),
                                      title: Text('Name :${_items[index]["Device_Name"]}'),
                                      subtitle: Text('Status : ${_items[index]["Device_Status"]}'),
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget tabTitle(String name) {
    return Text(name, style: TextStyle(color: ConstantColor.grayColor));
  }
}
