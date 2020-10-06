import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kiwi/kiwi.dart';
import 'package:movie_lists/blocs/movies_bloc/movies_bloc.dart';
import 'package:movie_lists/blocs/movies_bloc/movies_enents.dart';
import 'package:movie_lists/blocs/movies_bloc/movies_states.dart';
import 'file:///F:/Projects/Android_projects/flutter/projects/movie_lists/lib/screens/widgets/main_widgets.dart';
import 'package:movies_lists_repo/movies_lists_repo.dart';
import 'package:movies_repo/movies_repo.dart';

class MoviesPage extends StatefulWidget {

  final MovieList list;

  const MoviesPage({this.list});

  @override
  _MoviesPageState createState() => _MoviesPageState();
}

class _MoviesPageState extends State<MoviesPage> {
  final urlController = TextEditingController();
  final tileColors = [Colors.blue , Colors.orange , Colors.pink , Colors.purple];
  final rand = Random();
  final bloc = KiwiContainer().resolve<MovieBloc>();
  FToast fToast;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    fToast = FToast();
    fToast.init(context);

    bloc.add(CheckIfRegistered(listId: widget.list.id));

    bloc.addWatcher.stream.listen((state) {
      if (state is AddingMovie){
        _showToast("Adding the movie now ...", Icons.sync, 4);
      }
      if (state is AddedMovie){
        _showToast("The movie is added successfully",
            Icons.check, 4);
      }
      if (state is AddMovieFailed){
        _showToast(state.error,
            Icons.error, 6);
      }
    });

  }

  @override
  void dispose(){
    bloc.close();
    super.dispose();
  }

  _showToast(String mess , IconData icon , int duration) {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.greenAccent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon),
          SizedBox(
            width: 12.0,
          ),
          Text(mess),
        ],
      ),
    );


    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: duration),
    );
  }


  showAddMovieDialog(BuildContext context){
    Dialog dialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Add New Movie",
              style: TextStyle(
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0
              ),
            ),
            SizedBox(height: 10.0,),
            TextField(
              controller: urlController,
              decoration: InputDecoration(
                  labelText: "Imdb Link",
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
                bloc.add(AddMovie(url: urlController.text , listId: widget.list.id));
                urlController.clear();
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
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          showAddMovieDialog(context);
        },
        child: Icon(Icons.add , color: Colors.white,),
      ),
      body: BlocProvider(
        create: (_) => bloc,
        child: BlocBuilder<MovieBloc , MoviesState>(
          builder: (context , state){
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  elevation: 10.0,
                  automaticallyImplyLeading: false,
                  leading: IconButton(
                      icon: Icon(Icons.arrow_back , color: Colors.white,),
                      onPressed: (){
                        Navigator.of(context).pop();
                      }
                  ),
                  expandedHeight: state is LoadedMovies? state.movies.isEmpty ? MediaQuery.of(context).size.height : MediaQuery.of(context).size.height*0.6 : MediaQuery.of(context).size.height*0.6,
                  flexibleSpace: flexibleSpace(widget.list , state),
                ),
                stateDecide(state),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget stateDecide(MoviesState state){
    if (state is LoadedMovies){

      return sliverList(state);
    } else if (state is LoadingMovies){
      return SliverList(delegate: SliverChildListDelegate(
        [
          Center(child: CircularProgressIndicator(),)
        ]
      ));
    } else if (state is LoadMoviesFailed){
      return SliverList(delegate: SliverChildListDelegate(
        [
          Center(child: Text(state.error),)
        ]
      ));
    } else {
      return SliverList(delegate: SliverChildListDelegate(
          [
            Container()
          ]
      ));
    }
  }

  Widget sliverList(LoadedMovies state){
    return SliverList(
      delegate: SliverChildBuilderDelegate(
          (BuildContext context , int index){
            return listItem(state.movies[index], index);
          },
        childCount: state.movies.length
      ),
    );
  }

  Widget gridList(LoadedMovies state){
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: 5.0 ,
          crossAxisCount: 2 ,
          childAspectRatio: 1.0 ,
          mainAxisSpacing: 15.0),
      delegate: SliverChildBuilderDelegate((context , index){
        return gridItem(state.movies[index] , index);
      },
          childCount: state.movies.length
      ),
    );
  }

  Widget gridItem(Movie movie , int index){
    print("TITLE ${movie.title}");
    return Padding(
      padding: !index.isEven ? EdgeInsets.only(right: 5.0 , top: 5.0): EdgeInsets.only(left: 5.0 , top: 5.0),
      child: Stack(
        children:[ Container(
          padding: EdgeInsets.all(20.0),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(movie.img),
                  fit: BoxFit.cover
              ),
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey,
                    blurRadius: 7.0
                )
              ]
          ),
        ),
      Padding(
        padding: const EdgeInsets.only(bottom:8.0),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Text(
              movie.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                   fontFamily: "Montserrat",
                   fontSize: 18.0,
                color: Colors.white
          ),
          ),
        ),
      )
      ]
      ),
    );
  }

  Widget listItem(Movie movie , int index){
    return Container(
      margin: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColorDark,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 7.0,
            spreadRadius: 2.0
          )
        ]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left:8.0),
                  child: Text(
                    movie.title,
                    style: TextStyle(
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 30.0,),
                Padding(
                  padding: const EdgeInsets.only(left:8.0),
                  child: Text(
                    movie.story,
                    maxLines: 6,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: "Quicksand",
                      fontSize: 14.0,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 50.0,)
              ],
            ),
          ),
          SizedBox(width: 20.0,),
          Expanded(
            child: AspectRatio(
              aspectRatio: 0.71,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      movie.img
                    ),
                    fit: BoxFit.fill
                  ),
                  borderRadius: BorderRadius.circular(15.0)
                ),
              ),
            ),
          )
        ],
      ),
    );
  }


  Widget flexibleSpace(MovieList list , MoviesState state){
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/background.jpg"),
          fit: BoxFit.fill
        )
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(flex: 2,),
          Expanded(
            child: Text(
              list.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: Colors.blue,
                      blurRadius: 16.0,
                    )
                  ]
              ),
            ),
          ),
          Expanded(
            child: Text(
              list.desc,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontStyle: FontStyle.italic,
                  fontFamily: "Quicksand",
                  shadows: [
                    Shadow(
                      color: Colors.blue,
                      blurRadius: 14.0,
                    )
                  ]
              ),
            ),
          ),
          showEmptyMovieMessage(state),
          Spacer()
        ],
      ),
    );
  }

  Widget showEmptyMovieMessage(MoviesState state){
    if (state is LoadedMovies){
      if (state.movies.isEmpty){
        return Expanded(
          child: Text(
              "There is no movies yet !",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontStyle: FontStyle.italic,
                  fontFamily: "Quicksand",
                  shadows: [
                    Shadow(
                      color: Colors.blue,
                      blurRadius: 14.0,
                    )
                  ]
              ),
        )
        );
      }
      return Container();
    } else {
      return Container();
    }
  }

}
