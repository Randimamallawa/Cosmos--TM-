import 'package:cosmos_client/Workflow%20Management/Services/apiserviceworkflow.dart';
import 'package:cosmos_client/Workflow%20Management/View%20Cards/PieChartCard.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:cosmos_client/Chat/Screen/chat_group.dart';
import 'package:cosmos_client/Workflow%20Management/Screens/yourSubWorkflow.dart';
import 'package:cosmos_client/Constants.dart';
import 'package:cosmos_client/Workflow%20Management/Models/workflowModels.dart';
import 'package:uuid/uuid.dart';

class PieChartWorksScreen extends StatefulWidget {
  dynamic subworkflow;
  final String workflowName;
  final Function(dynamic) onDelete;
  PieChartWorksScreen(
      {super.key,
      required this.subworkflow,
      required this.workflowName,
      required this.onDelete});

  @override
  State<PieChartWorksScreen> createState() => _PieChartWorksScreenState();
}

class _PieChartWorksScreenState extends State<PieChartWorksScreen> {
  List<WorkModel> workcards = [];
  Map<String, double> dataMap = {};
  Uuid uuid = const Uuid();
  TextEditingController _workController = TextEditingController(); //name
  TextEditingController _workDesController = TextEditingController(); //des
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController =
      TextEditingController(); // Subworkflow
  TextEditingController _amountController = TextEditingController();

  String? selectedUnit;
  bool isActive = false;
  // Start Date
  DateTime pickedStart = DateTime.now();
  Future<DateTime?> _selectStartDate(BuildContext context) async {
    final DateTime? pickedStart = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    return pickedStart;
  }

  // End Date
  DateTime pickedEnd = DateTime.now();
  Future<DateTime?> _selectEndDate(BuildContext context) async {
    final DateTime? pickedEnd = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    return pickedEnd;
  }

  //Delete Pie Chart view
  deletePieChartView() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: kAlertBoxBorderStyle,
          title: const Icon(
            Icons.delete,
            size: 60.0,
            color: Colors.green,
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Are You Sure ?',
                  style: kAlertBoxTopicTextStyle,
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 20, left: 17),
                  child: Text(
                    'You want to delete Pie Chart View !',
                    style: TextStyle(fontSize: 13, fontStyle: FontStyle.italic),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: kAlertBoxButtonStyle,
                  onPressed: () {
                    widget.onDelete(widget.subworkflow);
                  },
                  child: const Text(
                    'Delete',
                    style: kAlertBoxButtonTextStyle,
                  ),
                ),
                ElevatedButton(
                  style: kAlertBoxButtonStyle,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Cancel',
                    style: kAlertBoxButtonTextStyle,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        );
      },
    );
  }

  // Edit Subworkflow Description
  editSubworkflow() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: kAlertBoxBorderStyle,
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Description',
                  style: kAlertBoxTopicTextStyle,
                ),
                const SizedBox(height: 10),
                const Icon(
                  Icons.description,
                  size: 60.0,
                  color: Colors.green,
                ),
                const SizedBox(height: 10),
                //SubWorkflow Description
                TextField(
                  maxLines: 3,
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    hintText: 'Edit here',
                    border: InputBorder.none,
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          actions: [
            Center(
              child: ElevatedButton(
                style: kAlertBoxButtonStyle,
                onPressed: () {
                  // String title = _workController.text.trim();
                  // String workid = uuid.v4();
                  // WorkModel work_newItem = WorkModel(
                  //   workid: workid,
                  //   title: title,
                  //   active: true,
                  // );
                  // createWork(
                  //     work_newItem, workcards, widget.subworkflow['_id']);
                  // setState(() {
                  //   workcards.add(work_newItem);
                  // });

                  // Navigator.pop(context);
                  // _workController.clear();
                },
                child: const Text(
                  'Confirm',
                  style: kAlertBoxButtonTextStyle,
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.subworkflow['title'];
    _descriptionController.text = widget.subworkflow['description'];
    int nWorks = widget.subworkflow['works'].length;
    for (var i = 0; i < nWorks; i++) {
      workcards.add(WorkModel(
          workid: widget.subworkflow['works'][i]['_id'],
          title: widget.subworkflow['works'][i]['title'],
          description: widget.subworkflow['works'][i]['description'],
          active: widget.subworkflow['works'][i]['active'],
          repetitive: RepetitiveModel(
            amount: widget.subworkflow['works'][i]['repetitive']['amount'] ?? 0,
            unit: widget.subworkflow['works'][i]['repetitive']['unit'] ?? 'NU',
          )));
    }
    updateDataMap();
  }

  updateDataMap() {
    for (var work in workcards) {
      dataMap[work.title] = work.repetitive?.amount ?? 0;
    }
  }

  @override
  void dispose() {
    _workController.dispose();
    _workDesController.dispose();
    super.dispose();
  }

  createWorks(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: kAlertBoxBorderStyle,
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Create Work',
                  style: kAlertBoxTopicTextStyle,
                ),
                const SizedBox(height: 10),
                const Icon(
                  Icons.add,
                  size: 60.0,
                  color: Colors.green,
                ),
                const SizedBox(height: 10),
                //Work Name
                TextField(
                  controller: _workController,
                  decoration: const InputDecoration(
                    labelText: 'Work Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                //Work Description
                TextField(
                  controller: _workDesController,
                  decoration: const InputDecoration(
                    labelText: 'Work Description',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                //Amount and unit
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: 130,
                      child: TextField(
                        controller: _amountController,
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(
                          labelText: 'Amount',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 5,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Colors.grey.shade100,
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.black26,
                                blurRadius: 6,
                                offset: Offset(0, 2))
                          ]),
                      child: DropdownButton<String>(
                        underline: Text(''),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        alignment: AlignmentDirectional.centerEnd,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          decoration: null,
                        ),
                        value: selectedUnit,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedUnit = newValue;
                          });
                          print(selectedUnit);
                        },
                        items: <String>[
                          'kg',
                          'km',
                          'm',
                          'LKR',
                          'USD',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
          actions: [
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                style: kAlertBoxButtonStyle,
                onPressed: () {
                  String title = _workController.text.trim();
                  String descripion = _workDesController.text.trim();
                  String workid = uuid.v4();
                  WorkModel work_newItem = WorkModel(
                      workid: workid,
                      title: title,
                      description: descripion,
                      active: true,
                      repetitive: RepetitiveModel(
                          amount: double.parse(_amountController.text),
                          unit: selectedUnit ?? 'NU'));
                  createWork(
                      work_newItem, workcards, widget.subworkflow['_id']);
                  setState(() {
                    workcards.add(work_newItem);
                  });
                  updateDataMap();
                  Navigator.pop(context);
                  _workController.clear();
                  _workDesController.clear();
                },
                child: const Text(
                  'Create',
                  style: kAlertBoxButtonTextStyle,
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        );
      },
    );
  }

  void deleteWorks(String workid) {
    deleteWork(workcards.firstWhere((element) => element.workid == workid),
        workcards, widget.subworkflow['_id']);
    setState(() {
      workcards.removeWhere((element) => element.workid == workid);
    });
    dataMap.clear();
    updateDataMap();
  }

  void editWorks(WorkModel editedItem) {
    setState(() {
      int index = workcards
          .indexWhere((element) => element.workid == editedItem.workid);
      workcards[index] = editedItem;
    });
    editWork(
        workcards.firstWhere((element) => element.workid == editedItem.workid),
        workcards,
        widget.subworkflow['_id']);
    dataMap.clear();
    updateDataMap();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: kPrimaryColor,
          onPressed: () => createWorks(context),
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        body: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          suffixIcon: Icon(Icons.create),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter Title';
                          }
                          return null;
                        },
                      ),
                    ),
                    IconButton(
                      icon:
                          const Icon(Icons.help, color: kDefaultIconDarkColor),
                      onPressed: editSubworkflow, // Show Description
                    ),
                    IconButton(
                        onPressed: deletePieChartView,
                        icon: const Icon(Icons.delete))
                  ],
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: buildPieChart(),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: ListView.builder(
                  itemCount: workcards.length,
                  itemBuilder: (context, index) {
                    return PieChartWorksCard(
                      item: workcards[index],
                      workonDelete: (workid) => deleteWorks(workid),
                      workonEdit: (editedItem) => editWorks(editedItem),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPieChart() {
    final colorList = <Color>[
      Colors.greenAccent,
      Colors.amber,
      Colors.blue,
      Colors.red,
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: dataMap.isEmpty
          ? const Text('Add a Work')
          : PieChart(
              dataMap: dataMap,
              chartType: ChartType.ring,
              ringStrokeWidth: 20,
              colorList: colorList,
              initialAngleInDegree: -90,
              chartLegendSpacing: 48,
              chartRadius: 200,
              chartValuesOptions: const ChartValuesOptions(
                showChartValueBackground: false,
                showChartValuesInPercentage: true,
                decimalPlaces: 1,
              ),
            ),
    );
  }
}
