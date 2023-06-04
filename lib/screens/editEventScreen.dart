import 'package:boardgm/model/dto/event_dto.dart';
import 'package:boardgm/model/event.dart';
import 'package:boardgm/widgets/AddressWidget.dart';
import 'package:boardgm/widgets/DateTimeWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../apiclient/events_api_client.dart';
import '../bloc/events_bloc.dart';
import '../repositories/events_repository.dart';
import '../utils/dialog.dart';
import '../widgets/CountPlayersWidget.dart';
import '../widgets/DescriptionWidget.dart';
import '../widgets/NameWidget.dart';
import '../widgets/ageWidget.dart';

class EditEventScreen extends StatefulWidget {

  EditEventScreen({super.key});

  @override
  State<EditEventScreen> createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final gameController = TextEditingController();
  final addressController = TextEditingController();
  final countPlayersController = TextEditingController();
  final dateController = TextEditingController();
  final descriptionController = TextEditingController();
  final ageFromController = TextEditingController();
  final ageToController = TextEditingController();
  final bloc = EventsBloc(
      eventsRepository: EventsRepository(
          apiClient: EventsApiClient()
      )
  );
  late DateTimeWidget dateTimeWidget;

  List<Widget> fields = [];

  @override
  void initState() {
    super.initState();
    dateTimeWidget = DateTimeWidget(controller: dateController, withHelper: true);
  }


  @override
  void dispose() {
    nameController.dispose();
    gameController.dispose();
    addressController.dispose();
    countPlayersController.dispose();
    dateController.dispose();
    descriptionController.dispose();
    ageFromController.dispose();
    ageToController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Event? event = (ModalRoute.of(context)?.settings.arguments == null) ? null : ModalRoute.of(context)?.settings.arguments as Event;
    if (event != null) {
      print(event.minAge);
      print(event.maxAge);
      nameController.text = event.name;
      gameController.text = event.game;
      addressController.text = event.location;
      countPlayersController.text = event.maxNumberPlayers.toString();
      dateController.text = event.date!.toIso8601String();
      dateTimeWidget.selectedDate = event.date!;
      descriptionController.text = event.description;
      ageFromController.text = event.minAge == 0 ? "" : event.minAge.toString();
      ageToController.text = event.maxAge == 0 ? "" : event.maxAge.toString();
    }


    return BlocProvider(
      create: (context) => bloc,
      child: Scaffold(
        appBar: AppBar(
          title:
              event == null ? Text("Создание мероприятия", style: TextStyle(fontSize: 24),)
                            : Text("Изменение мероприятия", style: TextStyle(fontSize: 24),),
          //
          centerTitle: true,
          backgroundColor: Color(0xff50bc55),
        ),
        backgroundColor: Color(0xff292929),
        body: BlocBuilder<EventsBloc, EventsState>(
          builder: (context, state) {
            if (state is EventsInitial) {
              return buildCenter(bloc, dateTimeWidget, event);
            } else if (state is EventsLoading) {
              return Center(child: CircularProgressIndicator(),);
            } else if (state is EventsError) {
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                await DialogUtil.showErrorDialog(context, state.getErrorMessageWithoutException());
              });
              return buildCenter(bloc, dateTimeWidget, event);
              //return Center(child: Text(state.errorMessage),);
            } else if (state is EventCreated) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushNamedAndRemoveUntil(context, '/my_events',
                      (Route<dynamic> route) => route.settings.name != '/editEvent' && route.settings.name != '/my_events'
                  && route.settings.name != '/home');
            });
            return const Center(child: CircularProgressIndicator(),);
            }
            else if (state is EventUpdated) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pop(context);
              });
              return const Center(child: CircularProgressIndicator(),);
            }
        else {
              return Container();
            }
          }
        )
      ),
    );
  }

  Center buildCenter(EventsBloc bloc, DateTimeWidget dateTimeWidget, Event? event) {
    return Center(
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Column(
                      children: getColumn(bloc, dateTimeWidget, event)),
                ),
              )
            );
  }

  List<Widget> getColumn(EventsBloc bloc, DateTimeWidget dateTimeWidget, Event? event) {
    return [
      NameWidget(controller: nameController, withHelper: true, text: "Название мероприятия"),
      const SizedBox(height: 16,),
      NameWidget(controller: gameController, withHelper: true, text: "Название игры"),
      const SizedBox(height: 16,),
      CountPlayersWidget(controller: countPlayersController, withHelper: true,),
      const SizedBox(height: 16,),
      AddressWidget(controller: addressController, withHelper: true,),
      const SizedBox(height: 16,),
      Row(
        children: [
          Expanded(child: dateTimeWidget,),
        ],
      ),
      const SizedBox(height: 16,),
      DescriptionWidget(controller: descriptionController,),
      const SizedBox(height: 16,),
      Row(
        children: [
          Expanded(child: AgeWidget(controller: ageFromController, text: "Возраст от")),
          SizedBox(width: 16,),
          Expanded(child: AgeWidget(controller: ageToController, text: "Возраст до")),
        ],
      ),
      SizedBox(height: 16,),
      Row(
          children: [
            Expanded(
              child: ElevatedButton( onPressed: () {
                final form = formKey.currentState!;
                if (form.validate()) {
                  setState(() {
                    if (event == null) {
                      CreateEventRequest request = CreateEventRequest(
                          name: nameController.text, game:  gameController.text,  address: addressController.text, date: dateTimeWidget.selectedDate,
                          maxPersonCount: int.parse(countPlayersController.text),
                          minAge: ageFromController.text.isNotEmpty ? int.parse(ageFromController.text) : 0,
                          maxAge: ageToController.text.isNotEmpty ? int.parse(ageToController.text) : 0,
                          description: descriptionController.text);
                      bloc.add(CreateEvent(request));
                    } else {
                      UpdateEventRequest request = UpdateEventRequest(id: event.id!,
                          name: nameController.text, game:  gameController.text,  address: addressController.text, date: dateTimeWidget.selectedDate,
                          maxPersonCount: int.parse(countPlayersController.text),
                          minAge: ageFromController.text.isNotEmpty ? int.parse(ageFromController.text) : 0,
                          maxAge: ageToController.text.isNotEmpty ? int.parse(ageToController.text) : 0,
                          description: descriptionController.text);
                      bloc.add(UpdateEvent(request));
                    }
                  });
                }
              },
                child: Text("Продолжить"),
                style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(Color(0xff50bc55))),
              ),
            ),]
      ),

      const SizedBox(height: 16,),
    ];
  }
}