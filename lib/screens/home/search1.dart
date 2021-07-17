import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:live_locator/models/user.dart';
import 'package:live_locator/services/database.dart';
import 'package:live_locator/shared/constants.dart';
import 'package:provider/provider.dart';

String? _myName = "";

List<String> _usernames = <String>[];
List<String> _selectedusernames = <String>[];
Map<String, bool> _selectedusernamesbool = <String, bool>{};

class Search extends StatefulWidget {
  const Search({ Key? key }) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}


class _SearchState extends State<Search> with SingleTickerProviderStateMixin {

  static final GlobalKey<ScaffoldState> scaffoldKey =
      new GlobalKey<ScaffoldState>();

  late TextEditingController _searchQuery;

  bool isSearching = false;
  String searchQuery = "Search query";
  String? _groupName;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _searchQuery = new TextEditingController();
  }

 
  void _startSearch() {
    print("open search box");
    ModalRoute.of(context)!
        .addLocalHistoryEntry(new LocalHistoryEntry(onRemove: _stopSearching));

    setState(() {
      isSearching = true;
    });
  }

  void _stopSearching() {
    _clearSearchQuery();

    setState(() {
      isSearching = false;
    });
  }

  void _clearSearchQuery() {
    print("close search box");
    setState(() {
      _searchQuery.clear();
      updateSearchQuery("Search query");
    });
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      searchQuery = newQuery;
    });
    print("search query " + newQuery);
  }



  Widget _buildTitle(BuildContext context) {
    var horizontalTitleAlignment =
        Platform.isIOS ? CrossAxisAlignment.center : CrossAxisAlignment.start;

    return new InkWell(
      onTap: () => scaffoldKey.currentState!.openDrawer(),
      child: new Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: horizontalTitleAlignment,
          children: <Widget>[
             const Text('Search names for Group'),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return new TextField(
        controller: _searchQuery,
        autofocus: true,
        decoration: const InputDecoration(
          hintText: 'Search by name',
          border: InputBorder.none,
          hintStyle: const TextStyle(color: Colors.white30),
        ),
        style: const TextStyle(color: Colors.white, fontSize: 16.0),
        onChanged: (text) {
          int i = 0;
          _usernames.clear();
          FirebaseFirestore.instance
              .collection('users')
              .where('name', isEqualTo: text)
              .get()
              .then((snapshot) {
            setState(() {
              snapshot.docs.forEach((element) {
                //print(element['name']);
                if (true) {
                  if (!_usernames.contains(element['name'])) {
                    _usernames.insert(i, element['name']);
                    if (_selectedusernames.contains(element['name'])) {
                      _selectedusernamesbool.update(
                          element['name'], (value) => true,
                          ifAbsent: () => true);
                    } else {
                      _selectedusernamesbool.update(
                          element['name'], (value) => false,
                          ifAbsent: () => false
                      );
                    }
                    isSearching = false;
                  }
                  i++;
                }
              });
              
            });
          });
        });
  }

   //cross icon button
  List<Widget> _buildActions() {
    if (isSearching) {
      return <Widget>[
        new IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            if (_searchQuery == null || _searchQuery.text.isEmpty) {
              Navigator.pop(context);
              return;
            }
            _clearSearchQuery();
          },
        ),
      ];
    }

    //main search function search
    return <Widget>[
      new IconButton(
        icon: const Icon(Icons.search),
        onPressed: _startSearch,
      ),
    ];
  }

  void _deleteselected(String label) {
    setState(
      () {
        _selectedusernames.removeAt(_selectedusernames.indexOf(label));
      },
    );
  }


  Widget _buildChip(String label, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 5.0),
      child: Chip(
        labelPadding: EdgeInsets.all(2.0),
        avatar: CircleAvatar(
          backgroundColor: Colors.black,
          child: Text(label[0].toUpperCase()),
        ),
        label: Text(
          "  " + label + " ",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        deleteIcon: Icon(
          Icons.close,
        ),
        onDeleted: () => _deleteselected(label),
        backgroundColor: color,
        elevation: 6.0,
        shadowColor: Colors.grey[60],
        padding: EdgeInsets.all(8.0),
      ),
    );
  }

  

  @override
  Widget build(BuildContext context) {
    final currUser = Provider.of<MyUser?>(context);

    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: currUser!.uid).userData,
      builder: (context, snapshot) {
        UserData? userData = snapshot.data;

        //Create a group
  Future<void> createCollectiongroup() async {
    _selectedusernames.insert(_selectedusernames.length, userData!.name ?? "Me" );
    Map<String,dynamic> mapgroups = {
      'groupname' : _groupName,
      'users': _selectedusernames,
    };
    try {

      await FirebaseFirestore.instance.collection('groups').add(mapgroups);
      ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Group Created")));
      setState((){
        _selectedusernames.clear();
        _selectedusernamesbool.clear();
      });

    } catch(e){
      ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Failed : $e")));
    }
  }

  //Take name of group
  void _showSettingsPanel(){
    showModalBottomSheet(context: context, builder: (context){
      return Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 60),
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              //Prompt
              SizedBox(height: 40),
              Text("Please Enter The Group's Name"),
              SizedBox(height: 10),

              //Form Field
              TextFormField(
                decoration: textInputDecoration2.copyWith(hintText: "Group Name"),
                validator: (val){
                  if(val == null || val.isEmpty)
                    return "Please Enter Group Name";
                  else
                    return null;
                },
                onChanged: (val) => setState(() => _groupName = val),
              ),

              //Submit Button
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if(_formKey.currentState!.validate()){
                    await createCollectiongroup();
                    Navigator.pop(context);
                  }
                  
                }, 
                child: Text("Create Group",
                  style: TextStyle(fontSize: 15),
                ),
                style : ElevatedButton.styleFrom(
                  primary: Colors.pink[400],
                  onPrimary: Colors.white,
                )
              )
            ],
          ),
        ),
      );
    });
  }
        
        return Scaffold(

          //appbar
          appBar: new AppBar(
            leading: isSearching ? const BackButton() : null,
            title: isSearching ? _buildSearchField() : _buildTitle(context),
            actions:_buildActions(),
          ),

          //body
          body: isSearching
             ? Center(child: CircularProgressIndicator())
             :
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
              
                    Padding(
                      padding: const EdgeInsets.symmetric(),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Wrap(
                          spacing: 6.0,
                          runSpacing: 6.0,
                          children: _selectedusernames
                              .map((item) => _buildChip(item, Color(0xFFFF6666)))
                              .toList()
                              .cast<Widget>(),
                        ),
                      ),
                    ),
                    Divider(thickness: 1.2),
                   // Text(_username!.displayName),
                   
                    Expanded(
                      child: ListView.builder(
                        itemCount: _usernames.length,
                        itemBuilder: (context, index) {
                          
                          if(_usernames[index] != _myName){
                            return GestureDetector(
                              onTap: (){
                                setState(() {
                                  if(!_selectedusernames.contains(_usernames[index])){
                                    _selectedusernames.add(_usernames[index]);
                                  }
                                });
                              },
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListTile(
                                    leading: Container(
                                      width: 50,
                                      height: 53,
                                      child: Stack(
                                        children: [
                                          CircleAvatar(
                                            child: Text(_usernames[index][0].toUpperCase(),
                                              style: TextStyle(
                                                fontSize: 30,
                                              ),
                                            ),
                                            radius: 25,
                                            backgroundColor: Colors.grey[800],
                                          ),
                                          
                                        ],
                                      ),
                                    ),
                                    title: Text(
                                      _usernames[index],
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      ),

                                    ),
                                ),
                              ),
                            );
                          }else {
                            return Text("");
                          }
                        },
                      ),
                    ),
                  ],
              ),

          //Flaoting Action
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              _showSettingsPanel();
            },
            child: Icon(Icons.add,
              color: Colors.white,
              size: 30,
            )
          ),

        );
      }
    );
  }
}