import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kiwi/kiwi.dart';
import 'package:movie_lists/blocs/movies_bloc/movies_bloc.dart';
import 'package:movie_lists/blocs/movies_bloc/movies_enents.dart';
import 'package:movie_lists/blocs/movies_bloc/movies_states.dart';
import 'package:movie_lists/screens/main_screens/widgets.dart';
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

  final bloc = KiwiContainer().resolve<MovieBloc>();
  FToast fToast;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    fToast = FToast();
    fToast.init(context);

    bloc.add(LoadMovies(listId: widget.list.id));

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
    bloc.addWatcher.close();
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
                  title: Text(widget.list.title),
                  pinned: true,
                  expandedHeight: 200.0,
                  flexibleSpace: flexibleSpace(widget.list),
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


  Widget flexibleSpace(MovieList list){
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/movies_cover.jpg"),
          fit: BoxFit.fill
        )
      ),
      child: Center(
        child: Text(
          list.desc,
          style: TextStyle(
            fontFamily: "Montserrat",
            fontSize: 15.0,
            fontWeight: FontWeight.bold,
            color: Colors.white
          ),
        ),
      ),
    );
  }

}
