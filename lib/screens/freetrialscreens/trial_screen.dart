import 'dart:async';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pillpalmobile/screens/freetrialscreens/cpntest/Add_Alarm.dart';
import 'package:pillpalmobile/screens/freetrialscreens/cpntest/Provier.dart';
import 'package:provider/provider.dart';



class FreeTrialScreen extends StatefulWidget {
  const FreeTrialScreen({super.key});
  @override
  State<FreeTrialScreen> createState() => _FreeTrialScreenState();
}

class _FreeTrialScreenState extends State<FreeTrialScreen> {
  bool value = false;

   @override
  void initState() {
    //context.read<alarmprovider>().DeleteData();
    context.read<alarmprovider>().Inituilize(context);
    Timer.periodic(Duration(seconds: 1), (timer) {
      // setState(() {});
    });

    super.initState();
    context.read<alarmprovider>().GetData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEEFF5),
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(
              Icons.menu,
              color: Colors.white,
            ),
          )
        ],
        title: const Text(
          'Alarm Clock ',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Consumer<alarmprovider>(builder: (context, alarm, child) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.7,
              child: ListView.builder(
                  itemCount: alarm.modelist.length,
                  itemBuilder: (BuildContext, index) {
                    return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.1,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          alarm.modelist[index].dateTime!,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Colors.black),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Text("|" +
                                              alarm.modelist[index].label
                                                  .toString()),
                                        ),
                                      ],
                                    ),
                                    CupertinoSwitch(
                                        value:(alarm.modelist[index].milliseconds! < DateTime.now().microsecondsSinceEpoch)? false:alarm.modelist[index].check,
                                        onChanged: (v) {


                                          alarm.EditSwitch(index, v);




                                          alarm.CancelNotification(alarm.modelist[index].id!);

                                        }),
                                  ],
                                ),
                                Text(alarm.modelist[index].when!)
                              ],
                            ),
                          ),
                        ));
                  }),
            );
          }),
          Container(
            height: MediaQuery.of(context).size.height * 0.1,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)),
                color: Colors.deepPurpleAccent),
            child: Center(
                child: GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddAlarm()));
              },
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white, shape: BoxShape.circle),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Icon(Icons.add),
                  )),
            )),
          ),
        ],
      ),
    );
  }
}
