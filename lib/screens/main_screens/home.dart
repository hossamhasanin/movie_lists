import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiwi/kiwi.dart';
import 'package:movie_lists/blocs/movie_lists_bloc/movie_lists_bloc.dart';
import 'package:movie_lists/blocs/movie_lists_bloc/movie_lists_event.dart';
import 'package:movie_lists/blocs/movie_lists_bloc/movie_lists_state.dart';
import 'package:movie_lists/screens/main_screens/widgets.dart';
import 'package:movie_lists/screens/movie_list/movies.dart';
import 'package:movies_lists_repo/movies_lists_repo.dart';

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


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    bloc.add(FetchList());
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
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          Icon(
                            Icons.add_to_queue,
                            size: 25.0,
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
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold
                    ),
                  ),
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

}
