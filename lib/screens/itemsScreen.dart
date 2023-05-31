import 'package:boardgm/bloc/person_bloc.dart';
import 'package:boardgm/model/event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../apiclient/persons_api_client.dart';
import '../model/item.dart';
import '../repositories/persons_repository.dart';
import '../widgets/NameWidget.dart';

class ItemsScreen extends StatefulWidget {

  ItemsScreen({super.key});

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {

  final formKey = GlobalKey<FormState>();
  final itemController = TextEditingController();
  List<Item> items = [];
  final bloc =  PersonBloc(
      personRepository: PersonsRepository(
          apiClient: PersonsApiClient()));

  @override
  void dispose() {
    itemController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final event = (ModalRoute.of(context)?.settings.arguments) as Event;

    return BlocProvider<PersonBloc>(
      create: (context) => bloc..add(LoadEventForPerson(event.id!)),
      child: Scaffold(
        appBar: AppBar(
          title:
              Text("Предметы", style: TextStyle(fontSize: 24),),
          //
          centerTitle: true,
          backgroundColor: Color(0xff50bc55),
        ),
        backgroundColor: Color(0xff292929),
        body: BlocBuilder<PersonBloc, PersonState> (
          builder: (context, state) {
            if (state is EventForPersonLoaded ) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  items = state.items;
                });
              });
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Expanded(
                      flex: 9,
                      child: ListView.builder(
                        //shrinkWrap: true,
                          itemCount: items.length,
                          itemBuilder: (_, index) =>
                              Card(
                                color: Colors.white,
                                child: ListTile(
                                    title: Text(items[index].name),
                                    trailing: IconButton(icon: Icon(Icons.dangerous), onPressed: () {
                                      setState(() {
                                        items.removeAt(index);
                                      });
                                    },),
                                ),
                              )
                      ),
                    ),
                    const SizedBox(height: 16,),
                    Center(
                      child: Form(
                        key: formKey,
                        child: SingleChildScrollView(
                          child: Row(
                              children: [
                                const SizedBox(width: 16,),
                                Expanded(child: NameWidget(controller: itemController, withHelper: false, text: "Название предмета",)),
                                const SizedBox(width: 16,),
                                Expanded(
                                  child: ElevatedButton( onPressed: () {
                                    final form = formKey.currentState!;
                                    if (form.validate()) {
                                      setState(() {
                                        items.add(Item(name: itemController.text, marked: false));
                                      });
                                    }
                                  },
                                    child: Text("Добавить"),
                                    style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(Color(0xff50bc55))),
                                  ),
                                ),
                                const SizedBox(width: 16,),
                              ]),
                        ),
                      ),
                    ),
                    SizedBox(height: 16,),
                    ElevatedButton( onPressed: () {
                      setState(() {
                        bloc.add(EditItems(event.id!, items));
                      });
                    },
                      child: Text("Сохранить"),
                      style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(Color(0xff50bc55))),
                    ),
                  ],
                ),
              );
            } else if (state is PersonsLoading) {
              return const Center(child: CircularProgressIndicator(),);
            } else if (state is PersonsError) {
              return Center(child: Text(state.errorMessage),);
            } else if (state is ItemsEdited) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pushNamedAndRemoveUntil(
                context, '/event', arguments: [event, '/home'], (Route<dynamic> route) => route.settings.name != '/event' && route.settings.name != '/items');
              });
              return const Center(child: CircularProgressIndicator(),);
            } else {
              return Container();
            }
          },
        )
      ),
    );
  }
}