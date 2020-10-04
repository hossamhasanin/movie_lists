import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:kiwi/kiwi.dart';
import 'package:movie_lists/blocs/contacts_bloc/contacts_bloc.dart';
import 'package:movie_lists/blocs/contacts_bloc/contacts_events.dart';
import 'package:movie_lists/blocs/contacts_bloc/contacts_states.dart';
import 'package:user_repo/user_repo.dart';

class ContactPage extends StatefulWidget {
  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final bloc = KiwiContainer().resolve<ContactsBloc>();
  TextEditingController queryController;
  final tileColors = [Colors.blue , Colors.orange , Colors.pink , Colors.purple];
  final rand = Random();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    queryController = TextEditingController();

    bloc.add(LoadContacts());
    aduStateDecide();

  }

  @override
  void dispose() {
    bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<ContactsBloc>(
        create: (_)=> bloc,
        child: BlocBuilder<ContactsBloc , ContactsState>(
          builder: (context , state){
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: (){
                    if (bloc.adUcontactController.value is! ContactAdding){
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
                          "Add new Contact",
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
                decideState(state)
              ],
            );
          },
        ),
      ),
    );
  }

  Widget decideState(state){
    if (state is ContactsLoading){
      return Center(
        child: CircularProgressIndicator(),
      );
    } else if (state is ContactsLoadFailed){
      return Center(
        child: Text(state.error),
      );
    } else if (state is ContactsLoaded){
      if (state.contacts.isEmpty){
        return Center(
          child: Text("No Contacts"),
        );
      } else {
        return Expanded(
          child: ListView.builder(
            itemCount: state.contacts.length,
            itemBuilder: (context , index){
              return contactTile(state.contacts[index]);
            },
          ),
        );
      }
    } else {
      return Container();
    }
  }

  aduStateDecide(){
    bloc.adUcontactController.listen((state) {
      if (state is ContactAdded){
        Get.snackbar(
          "",
          "ContactA added successfully",
          snackPosition: SnackPosition.BOTTOM
        );
      }
      if (state is ContactAdding){
        Get.snackbar(
          "",
          "Wait till it is done ...",
            snackPosition: SnackPosition.BOTTOM
        );
      }
      if (state is ContactAddFailed){
        Get.snackbar(
          "",
          state.obs.value.error,
            snackPosition: SnackPosition.BOTTOM
        );
      }

      if (state is ContactDeleted){
        Get.snackbar(
          "",
          "Contact deleted successfully",
            snackPosition: SnackPosition.BOTTOM
        );
      }
      if (state is ContactDeleting){
        Get.snackbar(
          "",
          "Wait till it is done ...",
            snackPosition: SnackPosition.BOTTOM
        );
      }
      if (state is ContactDeleteFailed){
        Get.snackbar(
          "",
          state.obs.value.error,
            snackPosition: SnackPosition.BOTTOM
        );
      }
    });
  }

  Widget contactTile(User user){
    final randomColor = tileColors[rand.nextInt(tileColors.length-1)];
    return Dismissible(
      key: ValueKey(user.id),
      background: Container(
        color: Colors.red,
        child: Icon(Icons.delete , color: Colors.white,),
      ),
      onDismissed: (direction){
        bloc.add(DeleteContact(user: user));
      },
      child: Container(
        margin: const EdgeInsets.only(left:8.0 , right: 8.0 , top: 15.0),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 3.0,
            )
          ]
        ),
        child: Row(
          children: [
            Container(
              width: 50.0,
              height: 50.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  color: randomColor
              ),
              child: Center(
                child: Text(
                  user.username[0].toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(width: 20.0,),
            Text(
                user.username,
                style: TextStyle(
                  fontFamily: "Montserrat",
                  fontSize: 18.0,
                ),
            )
          ],
        ),
      ),
    );
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
            TextFormField(
              controller: queryController,
              decoration: InputDecoration(
                  labelText: "Query",
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
            RaisedButton(
              onPressed: (){
                bloc.add(AddContact(query: queryController.text));
                queryController.clear();
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


}
