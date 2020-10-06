import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:kiwi/kiwi.dart';
import 'package:movie_lists/blocs/movie_lists_bloc/movie_lists_bloc.dart';
import 'package:movie_lists/blocs/movie_lists_bloc/movie_lists_event.dart';
import 'package:movie_lists/blocs/movie_lists_bloc/movie_lists_state.dart';
import 'file:///F:/Projects/Android_projects/flutter/projects/movie_lists/lib/screens/widgets/main_widgets.dart';
import 'package:movie_lists/screens/movie_list/movies.dart';
import 'package:movies_lists_repo/movies_lists_repo.dart';
import 'package:user_repo/user_repo.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final scrollController  = ScrollController();
  final bloc = KiwiContainer().resolve<MovieListBloc>();
  final tileColors = [Colors.blue , Colors.orange , Colors.pink , Colors.purple];
  final rand = Random();
  final titleController = TextEditingController();
  final descController = TextEditingController();
  RxList<String> checked = List<String>().obs;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  new GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    bloc.add(FetchList());

    bloc.shareStateController.listen((state) {
      checked.clear();
      if (state is SharingList){
        Get.snackbar("Sharing", "Wait a bit ...");
      }
      if (state is SharedList){
        Get.snackbar("Shared", "The list shared successfully ...");
      }
      if (state is SharedListFailed){
        Get.snackbar("Error", state.error , duration: Duration(seconds: 6));
      }
    });

  }

  @override
  void dispose(){
    bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<MovieListBloc>(
        create: (_)=> bloc,
        child: BlocListener<MovieListBloc , MovieListState>(
          listener: (BuildContext context , MovieListState state){
            if (state is AddingList){
              Scaffold.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(content: Text("Adding the list now ..."),),
                );
            }

            if (state is AddedList){
              Scaffold.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(content: Text("List added successfully ..."),),
                );
            }

            if (state is AddListFailed){
              Scaffold.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                   SnackBar(content: Text(state.error),duration: Duration(seconds: 6),),
                );
            }
          },
          child: BlocBuilder<MovieListBloc , MovieListState>(
            builder: (context , state){
              print(state);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: (){
                      if (state is! AddingList) {
                        showAddListDialog(context);
                      }
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(20.0),
                      margin: EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15.0),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey,
                                blurRadius: 6.0,
                                offset: Offset(0.0, 2.0)
                            )
                          ]
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Make new One",
                            style: TextStyle(
                                fontFamily: "Montserrat",
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          Icon(
                            Icons.add_to_queue,
                            size: 22.0,
                            color: Colors.blue,
                          )
                        ],
                      ),
                    ),
                  ),
                  stateDecide(state)
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget stateDecide(MovieListState state){
    if (state is ListsLoading){
      return Center(
        child: CircularProgressIndicator(),
      );
    } else if (state is ListsLoadFailed){
      return Center(
        child: Text(state.error),
      );
    } else if (state is ListsLoaded) {
      return buildListView(state.lists);
    } else {
      return Container();
    }
  }

  Widget buildListView(List<MovieList> lists){
    return Expanded(
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) => _handelScrollingToTheEndOfTheList(notification , lists.last , lists),
        child: ListView.builder(
          itemCount: lists.length >= LISTS_LIMIT? lists.length + 1 : lists.length,
          controller: scrollController,
          itemBuilder: (context , index){
            if (lists.length >= LISTS_LIMIT){
              return index > lists.length ? Container(child: Center(child: CircularProgressIndicator()))
                  : buildListTile(lists[index]);
            } else {
              return buildListTile(lists[index]);
            }
          },
        ),
      ),
    );
  }

  Widget buildListTile(MovieList list){
    final randomColor = tileColors[rand.nextInt(tileColors.length-1)];
    final width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
          return MoviesPage(list: list,);
        }));
      },
      child: Container(
        width: width,
        padding: EdgeInsets.all(10.0),
        margin: EdgeInsets.only(left: 10.0 , top: 10.0 , right: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 3.0,
              offset: Offset(0.0, 1.0)
            )
          ]
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Icon(
                          Icons.movie,
                          color: randomColor,
                          size: 20.0,
                        ),
                        SizedBox(width: 10.0,),
                        Text(
                          list.title,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                              fontFamily: "Montserrat",
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(icon: Icon(Icons.share , color: Colors.black,), onPressed: (){
                    bloc.add(GetContacts());
                    showShareDialog(context , list);
                  })
                ],
              ),
            ),
            SizedBox(height: 5.0,),
            Container(
              child: Text(
                list.desc,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: TextStyle(
                  fontFamily: "Montserrat",
                  fontSize: 15.0,
                ),
              ),
            ),
            // Divider(color: Colors.grey,thickness: 2.0,)
          ],
        ),
      ),
    );
  }

  bool _handelScrollingToTheEndOfTheList(
      ScrollNotification notification, lastItem , list) {
    if (notification is ScrollEndNotification &&
        scrollController.position.extentAfter == 0 && list.length >= LISTS_LIMIT) {
      bloc.add(FetchMoreLists(lastItem: lastItem));
    }
    return false;
  }

  showAddListDialog(BuildContext context){
    Dialog dialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Add New List",
              style: TextStyle(
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0
              ),
            ),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                  labelText: "Title",
                  labelStyle: TextStyle(
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.bold,
                      color: Colors.grey
                  ),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).primaryColor)
                  )
              ),
            ),
            SizedBox(height: 10.0,),
            TextField(
              controller: descController,
              decoration: InputDecoration(
                  labelText: "Description",
                  labelStyle: TextStyle(
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.bold,
                      color: Colors.grey
                  ),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).primaryColor)
                  )
              ),
            ),
            SizedBox(height: 10.0),
            RaisedButton(
              onPressed: (){
                bloc.add(AddList(title: titleController.text , desc: descController.text));
                Navigator.of(context).pop();
              },
              color: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              child: Text("Add" , style: TextStyle(color: Colors.white),),
            )
          ],
        ),
      ),
    );
    showDialog(context: context , builder: (BuildContext context) => dialog);
  }
  showShareDialog(BuildContext context , MovieList list){
    Dialog dialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Share the list with your contacts",
              style: TextStyle(
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0
              ),
            ),
            Container(
              height: 200.0,
              child: Obx(
                () {
                  if (bloc.shareStateController.value is GettingContacts){
                    return Center(child: CircularProgressIndicator());
                  }else if (bloc.shareStateController.value is GotContactsFailed) {
                    return Center(child: Text((bloc.shareStateController.value as GotContactsFailed).error));
                  } else if (bloc.shareStateController.value is GotContacts) {
                    GotContacts state = bloc.shareStateController.value;
                    if (state.contacts.isEmpty){
                      return Center(
                        child: Text("You don't have approved contacts"),
                      );
                    } else {
                      return CheckedList(contacts: state.contacts , checked: checked,list: list,);
                    }
                  } else {
                    return Container();
                  }
                }
              ),
            ),
            RaisedButton(
              onPressed: (){
                print("koko checked >" + checked[0]);
                bloc.add(ShareList(contacts: checked , list: list));
                Navigator.of(context).pop();
              },
              color: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              child: Text("Share" , style: TextStyle(color: Colors.white),),
            )
          ],
        ),
      ),
    );
    showDialog(context: context , builder: (BuildContext context) => dialog);
  }

}

class CheckedList extends StatefulWidget {

  List<User> contacts;
  List<String> checked;
  MovieList list;

  CheckedList({this.contacts , this.checked , this.list});

  @override
  _CheckedListState createState() => _CheckedListState();
}

class _CheckedListState extends State<CheckedList> {

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.contacts.length,
      itemBuilder: (context , index){
        return CheckboxListTile(
            value: widget.checked.contains(widget.contacts[index].id) ? true : false,
            title: Text(widget.contacts[index].username),
            subtitle: widget.list.members.contains(widget.contacts[index].id) ? Text("Already member")
                : null,
            onChanged: widget.list.members.contains(widget.contacts[index].id) ? null : (bool value){
              print("koko " + widget.list.members.join(","));
              setState(() {
                if (value){
                  widget.checked += [widget.contacts[index].id];
                } else {
                  widget.checked.remove(widget.contacts[index].id);
                }
              });
            }
        );
      },
    );
  }
}

