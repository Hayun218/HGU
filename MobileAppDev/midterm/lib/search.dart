import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: _SearchPageBody(),
    );
  }
}

String date = "";
DateTime selectedDate = DateTime.now();
final isChecked = <bool>[false, false, false];

class _SearchPageBody extends StatefulWidget {
  @override
  __SearchPageBodyState createState() => __SearchPageBodyState();
}

class __SearchPageBodyState extends State<_SearchPageBody> {
  bool _active = false;
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        ExpansionPanelList(
          expansionCallback: (int index, isExpanded) {
            setState(() {
              _active = !_active;
            });
          },
          animationDuration: Duration(milliseconds: 500),
          children: [
            ExpansionPanel(
              canTapOnHeader: true,
              headerBuilder: (context, isExpanded) {
                return Row(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: const Text(
                        'Filter',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.symmetric(horizontal: 60),
                      child: const Text(
                        'select filters',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                );
              },
              isExpanded: _active,
              body: _Filter(),
            ),
          ],
        ),
        Container(
          margin: EdgeInsets.fromLTRB(20, 40, 30, 30),
          child: const Text(
            'Date',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 10, 30, 10),
                    child: const Icon(Icons.calendar_today),
                  ),
                  Text(
                    date,
                    style: TextStyle(fontSize: 10),
                  ),
                ],
              ),
            ),
            const Text(
              'check-in',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(70, 0, 10, 0),
              child: ElevatedButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.lightBlueAccent,
                ),
                child: const Text('Select Date'),
                onPressed: () {
                  _selectDate(context);
                },
              ),
            ),
          ],
        ),
        Container(
          margin: const EdgeInsets.all(150),
          alignment: Alignment.bottomCenter,
          child: _DialogInfo(context),
        ),
      ],
    );
  }

  // datePicker function
  _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (selected != null && selected != selectedDate) {
      setState(() {
        selectedDate = selected;
        date = DateFormat('yyyy-MM-dd (EEE)').format(selectedDate);
      });
    }
  }
}

//dialog
Widget _DialogInfo(context) {
  return ElevatedButton(
    onPressed: () => showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Container(
          child: const Text(
            'Please check your choice',
          ),
        ),
        content: Container(
          height: 100,
          child: Column(
            children: [
              Row(
                children: [
                  Icon(Icons.wifi),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.all(10),
                      child: Text(_checkToPut()),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.calendar_today),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      "In",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: Text(date),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Search'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('Cancel'),
            style: TextButton.styleFrom(
              backgroundColor: Colors.grey,
            ),
          ),
        ],
      ),
    ),
    child: const Text('Search'),
  );
}

String _checkToPut() {
  String items = '';
  if (isChecked[0]) {
    items = 'No Kids Zone ';
  }
  if (isChecked[1]) {
    if (items.isNotEmpty) {
      items = items + '/ ';
    }
    items = items + 'Pet Friendly ';
  }
  if (isChecked[2]) {
    if (items.isNotEmpty) {
      items = items + '/ ';
    }
    items = items + 'Free Breakfast ';
  }
  return items;
}

class _Filter extends StatefulWidget {
  @override
  __FilterState createState() => __FilterState();
}

class __FilterState extends State<_Filter> {
  @override
  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.blue;
    }

    return Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 110),
          child: Row(
            children: <Widget>[
              Checkbox(
                checkColor: Colors.white,
                fillColor: MaterialStateProperty.resolveWith(getColor),
                value: isChecked[0],
                onChanged: (bool? value) {
                  setState(() {
                    isChecked[0] = value!;
                  });
                },
              ),
              const Text('No Kids Zone'),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 110),
          child: Row(
            children: <Widget>[
              Checkbox(
                checkColor: Colors.white,
                // side: MaterialStateProperty.resolveWith(getBorder),
                fillColor: MaterialStateProperty.resolveWith(getColor),
                value: isChecked[1],
                onChanged: (bool? value) {
                  setState(() {
                    isChecked[1] = value!;
                  });
                },
              ),
              const Text('Pet Friendly'),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 110),
          child: Row(
            children: <Widget>[
              Checkbox(
                checkColor: Colors.white,
                fillColor: MaterialStateProperty.resolveWith(getColor),
                value: isChecked[2],
                onChanged: (bool? value) {
                  setState(() {
                    isChecked[2] = value!;
                  });
                },
              ),
              const Text('Free Breakfast'),
            ],
          ),
        ),
      ],
    );
  }
}
