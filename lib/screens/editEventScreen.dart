import 'package:boardgm/widgets/AddressWidget.dart';
import 'package:boardgm/widgets/DateTimeWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/event.dart';
import '../apiclient/events_api_client.dart';
import '../bloc/events_bloc.dart';
import '../repositories/events_repository.dart';
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

  List<Widget> fields = [];

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
    DateTimeWidget dateTimeWidget = DateTimeWidget(controller: dateController, withHelper: true,);
    final bloc = EventsBloc(
        repository: EventsRepository(
            apiClient: EventsApiClient()
        )
    );
    return BlocProvider(
      create: (context) => bloc,
      child: Scaffold(
        appBar: AppBar(
          title:
              Text("Создание мероприятия", style: TextStyle(fontSize: 24),),
          //
          centerTitle: true,
          backgroundColor: Color(0xff50bc55),
        ),
        backgroundColor: Color(0xff292929),
        body: BlocBuilder<EventsBloc, EventsState>(
          builder: (context, state) {
            if (state is EventsInitial) {
              return Center(
                child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(16),
                    child: Column(
                        children: getColumn(bloc, dateTimeWidget)),
                  ),
                )
              );
            } else if (state is EventsLoading) {
              return Center(child: CircularProgressIndicator(),);
            } else if (state is EventsError) {
              return Center(child: Text(state.errorMessage),);
            }
        else if (state is EventCreated) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(context, '/my_events');
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

  List<Widget> getColumn(EventsBloc bloc, DateTimeWidget dateTimeWidget) {
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
                    Event event = Event(id: null, name: nameController.text, game:  gameController.text,
                    location: addressController.text, maxNumberPlayers: int.parse(countPlayersController.text),
                    description: descriptionController.text);
                    event.date = dateTimeWidget.selectedDate;
                    event.minAge = ageFromController.text.isNotEmpty ? int.parse(ageFromController.text) : 0;
                    event.maxAge = ageToController.text.isNotEmpty ? int.parse(ageToController.text) : 0;
                    event.city = "Voronezh";
                    bloc.add(CreateEvent(event));
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