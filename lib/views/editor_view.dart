import 'package:flutter/material.dart';
import 'package:jsoneditor/values/values.dart';

class Editingview extends StatefulWidget {
  const Editingview({super.key});

  @override
  State<Editingview> createState() => _EditingviewState();
}

class _EditingviewState extends State<Editingview> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getJsonValues(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data == null) {
            return const Center(child: Text("null"));
          }
          List editableValues = snapshot.data;
          List<TextEditingController> controllerList = [];
          return Scaffold(
            body: ListView.builder(
              itemCount: editableValues.length,
              itemBuilder: (context, index) {
                controllerList.add(
                  TextEditingController(
                    text: editableValues[index]["value"],
                  ),
                );
                return TextFormField(
                  decoration: InputDecoration(
                      label: Text(editableValues[index]["key"])),
                  controller: controllerList[index],
                );
              },
            ),
            floatingActionButton: FloatingActionButton(
              tooltip: "Add key",
              shape: const CircleBorder(),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    final TextEditingController keyController =
                        TextEditingController();
                    final TextEditingController valueController =
                        TextEditingController();
                    return AlertDialog(
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            decoration:
                                const InputDecoration(label: Text("Enter Key")),
                            controller: keyController,
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                                label: Text("Enter Value")),
                            controller: valueController,
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () {
                            if (keyController.text.isNotEmpty) {
                              addJsonKeyValues(
                                  keyController.text, valueController.text);
                            }

                            Navigator.of(context).pop();
                            setState(() {});
                          },
                          child: const Text("Add"),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Icon(Icons.add),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {});
                    },
                    child: const Text("Discard"),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      Map save = {};
                      for (int i = 0; i < controllerList.length; i++) {
                        controllerList[i].text = editableValues[i]["value"];
                        save[editableValues[i]["key"]] = controllerList[i].text;
                      }
                      saveJsonValues(save);
                    },
                    child: const Text("Save"),
                  ),
                ],
              ),
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
