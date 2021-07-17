import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class Search extends StatefulWidget {
  const Search({ Key? key }) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> with SingleTickerProviderStateMixin{
  //My Variables
  late String _username;
  List<String> _usernames = <String>[];
  List<String> _selectedusernames = <String>[];
  Map<String,bool> _selectedusernamesbool = <String,bool> {};

  //Search Stuff
  static final GlobalKey<ScaffoldState> scaffoldKey =
  new GlobalKey<ScaffoldState>();

  TextEditingController? _searchQuery;
  bool _isSearching = false;
  String searchQuery = "Search query";
  //bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _searchQuery = new TextEditingController();
  }

  void _startSearch() {
    print("open search box");
    ModalRoute
        .of(context)
        !.addLocalHistoryEntry(new LocalHistoryEntry(onRemove: _stopSearching));

    setState(() {
      _isSearching = true;
      //_isLoading = true;
    });
  }

  void _stopSearching() {
    _clearSearchQuery();

    setState(() {
      _isSearching = false;
      //_isLoading = false;
    });
  }

  void _clearSearchQuery() {
    print("close search box");
    setState(() {
      _searchQuery!.clear();
      updateSearchQuery("Search query");
    });
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
            const Text('Seach box'),
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
        hintText: 'Search by username',
        border: InputBorder.none,
        hintStyle: const TextStyle(color: Colors.white30),
      ),
      style: const TextStyle(color: Colors.white, fontSize: 16.0),
      onChanged: updateSearchQuery,
    );
  }

  void updateSearchQuery(String text) {

    int i = 0;
    _usernames.clear();
    FirebaseFirestore.instance
      .collection('users')
      .where('name', isEqualTo: text)
      .get()
      .then((snapshot) {setState(() {
        //_isLoading = true;
        //_isSearching = true;
        snapshot.docs.forEach((element){
          if(element['name'] != _username){
            if(!_usernames.contains(element['name'])){
              _usernames.insert(i, element['name']);
              if(_selectedusernames.contains(element['name'])){
                _selectedusernamesbool.update(
                  element['name'], (value) => true,
                  ifAbsent:  () => true
                );
              } else {
                _selectedusernamesbool.update(
                  element['name'], (value) => false,
                  ifAbsent: () => false,
                );
              }
            } i++;
          }
        });
        //_isLoading = false;
        //_isSearching = false;
      });});

  }

  List<Widget> _buildActions() {

    if (_isSearching) {
      return <Widget>[
        new IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            if (_searchQuery == null || _searchQuery!.text.isEmpty) {
              Navigator.pop(context);
              return;
            }
            _clearSearchQuery();
          },
        ),
      ];
    }

    return <Widget>[
      new IconButton(
        icon: const Icon(Icons.search),
        onPressed: _startSearch,
      ),
    ];
  }

  Widget _buildChip(String label, Color color){
    return Chip(
      labelPadding: EdgeInsets.all(2.0),
      avatar: CircleAvatar(
        backgroundColor: Colors.black,
        child: Text(label[0].toUpperCase()),
      ),
      label : Text(
        label,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      deleteIcon: Icon(
        Icons.close,
      ),
      //onDeleted: () => _deleteselected(label),
      backgroundColor: color,
      elevation: 6.0,
      shadowColor:  Colors.grey[60],
      padding: EdgeInsets.all(8.0),
    );
  }
  
  @override
  Widget build(BuildContext context) {

    //Main Stuff
    return new Scaffold(
      backgroundColor: Colors.blue[100],
      //key: scaffoldKey,

      //appbar
      appBar: new AppBar(
        leading: _isSearching ? const BackButton() : null,
        title: _isSearching ? _buildSearchField() : _buildTitle(context),
        actions: _buildActions(),
      ),

      //floating button
      floatingActionButton: FloatingActionButton(
        onPressed: () {

        },
        child: Icon(Icons.check,
          color: Colors.white,
          size: 30,
        )
      ),


      //body
      body: _isSearching
        ? Center(child: CircularProgressIndicator())
        : 
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(),
              child: Align(
                alignment: Alignment.topLeft,
                child: Wrap(
                  spacing: 6.0,
                  runSpacing: 6.0,
                  children: _selectedusernames
                    .map((item) => _buildChip(item,Color(0xFFff6666)))
                    .toList()
                    .cast<Widget>()
                ),
              ),
            ),

            Divider(thickness:  1.0,),
            // ListView.builder(),
          ],
        )



    );
  }
}