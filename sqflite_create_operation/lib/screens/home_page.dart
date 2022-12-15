import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../database/data_model.dart';
import '../database/sqflite_database.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DB db = DB();
  TextEditingController nameController = TextEditingController();
  List<DataModel> datas = [];

  int ? index;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    db = DB();
    getData();
  }

  getData() async {
    datas = await db.getData();
    // log(datas.toString());
  }

  resetTextField() {
    nameController.clear();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      appBar: createAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
        child: ListView(shrinkWrap: true,
            // physics: NeverScrollableScrollPhysics(),
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  child: insertDataField(),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: MediaQuery.of(context).size.height,
                child: buildUserList(),
              ),
            ]),
      ),
    );
  }



  AppBar createAppBar() {
    return AppBar(
      title: Text('Daily Todo'),
      backgroundColor: Colors.green,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Icon(Icons.more_vert_outlined),
        )
      ],
    );
  }

  insertDataField() {
    return Column(
      children: [
        TextFormField(
          controller: nameController,
          decoration: InputDecoration(
              focusedBorder:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              hintText: "Enter Your Note",
              labelText: "Note",
              labelStyle: TextStyle(fontSize: 22, color: Colors.green),
              border: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(12))),
        ),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                textStyle:
                    TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            onPressed: () {
              db.insertData(DataModel, DataModel(name: nameController.text));
              // log(nameController.toString());
              resetTextField();
            },
            child: Text('Add Todo'))
      ],
    );
  }

  buildUserList() {
    return CustomScrollView(
      physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate([
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
              child: Container(
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: datas.length,
                  
                  // separatorBuilder: (context, index) => Divider(
                  //   color: Colors.grey,
                  // ),
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Card(
                          elevation: 12,
                          child: ListTile(
                            leading: Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: InkWell(
                                  onTap: () {
                                    //Edit function execute here.
                                
                                  },
                                  child: IconButton(
                                      onPressed: () {
                                        editValue(index);
                                      },
                                      icon: Icon(Icons.edit))),
                            ),
                            title: Text(
                              datas[index].name,
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            subtitle: Text(
                                DateFormat.yMMMMEEEEd().format(DateTime.now())),
                            trailing: InkWell(
                              onTap: () {
                                //Delete function will be there
                              },
                              child: Icon(
                                Icons.delete_rounded,
                                color: Colors.red,
                                size: 25,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ]),
        ),
      ],
    );
  }

  void editValue(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit"),
          content: TextFormField(
            controller: nameController,
            decoration: InputDecoration(
                focusedBorder:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                hintText: "Edit Your Note",
                labelStyle: TextStyle(fontSize: 22, color: Colors.green),
                ),
          ),
        );
      },
    );
  }
}
