import 'package:flutter/material.dart';

class CreateSessionScreen extends StatefulWidget {
  @override
  _CreateSessionScreenState createState() => _CreateSessionScreenState();
}

class _CreateSessionScreenState extends State<CreateSessionScreen> {
  final _formKey = GlobalKey<FormState>();

  String _title = '';
  String _description = '';
  DateTime _date = DateTime.now();
  String _startTime = '';
  String _endTime = '';
  String _location = '';
  bool _isOnline = false;
  String _platform = '';
  String _color = '#6200EA';
  List<String> _invitees = [];

  //  invitees logic

  // TODO: Save session logic

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text("Create Session", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                style: const TextStyle(color: Colors.black, fontSize: 12),
                decoration: const InputDecoration(
                    labelText: "Session Title",
                    labelStyle: TextStyle(color: Colors.black38),
                    hintText: "Enter a title",
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    )),
                onSaved: (value) {
                  _title = value!;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              TextFormField(
                style: TextStyle(color: Colors.black, fontSize: 12),
                decoration: const InputDecoration(
                  labelText: "Description",
                  labelStyle: TextStyle(color: Colors.black38),
                  hintText: "Enter a description",
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                onSaved: (value) {
                  _description = value!;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              TextFormField(
                style: TextStyle(color: Colors.black, fontSize: 12),
                decoration: const InputDecoration(
                  labelText: "Date",
                  labelStyle: TextStyle(color: Colors.black38),
                  hintText: "Enter a date",
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _date = pickedDate;
                    });
                  }
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a date';
                  }
                  return null;
                },
              ),
              TextFormField(
                style: TextStyle(color: Colors.black, fontSize: 12),
                decoration: const InputDecoration(
                  labelText: "Start Time",
                  labelStyle: TextStyle(color: Colors.black38),
                  hintText: "Enter a start time",
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                onSaved: (value) {
                  _startTime = value!;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a start time';
                  }
                  return null;
                },
              ),
              TextFormField(
                style: TextStyle(color: Colors.black, fontSize: 12),
                decoration: const InputDecoration(
                  labelText: "End Time",
                  labelStyle: TextStyle(color: Colors.black38),
                  hintText: "Enter an end time",
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                onSaved: (value) {
                  _endTime = value!;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter an end time';
                  }
                  return null;
                },
              ),
              TextFormField(
                style: TextStyle(color: Colors.black, fontSize: 12),
                decoration: const InputDecoration(
                  labelText: "Location",
                  labelStyle: TextStyle(color: Colors.black38),
                  hintText: "Enter a location",
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                onSaved: (value) {
                  _location = value!;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a location';
                  }
                  return null;
                },
              ),
              SwitchListTile(
                title: const Text("Online Meeting",
                    style: TextStyle(color: Colors.black38)),
                value: _isOnline,
                onChanged: (value) {
                  setState(() {
                    _isOnline = value;
                  });
                },
              ),
              if (_isOnline)
                TextFormField(
                  style: TextStyle(color: Colors.black, fontSize: 12),
                  decoration: const InputDecoration(
                    labelText: "Platform",
                    labelStyle: TextStyle(color: Colors.black38),
                    hintText: "Enter a platform",
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                  onSaved: (value) {
                    _platform = value!;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a platform';
                    }
                    return null;
                  },
                ),
              TextFormField(
                style: TextStyle(color: Colors.black, fontSize: 12),
                decoration: const InputDecoration(
                  labelText: "Session Color",
                  labelStyle: TextStyle(color: Colors.black38),
                  hintText: "Enter a color",
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                onSaved: (value) {
                  _color = value!;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a color';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                  }
                },
                child: const Text("Create Session"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
