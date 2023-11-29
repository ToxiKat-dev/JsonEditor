import 'package:flutter/material.dart';
import 'package:jsoneditor/values/values.dart';
import 'package:jsoneditor/widgets/form_text_tile.dart';

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
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: ListView.builder(
                itemCount: editableValues.length,
                itemBuilder: (context, index) {
                  controllerList.add(
                    TextEditingController(
                      text: editableValues[index]["value"],
                    ),
                  );
                  return FormTextTile(
                    name: editableValues[index]["key"],
                    controller: controllerList[index],
                  );
                },
              ),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ButtonStyle(
                            shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          onPressed: () {
                            setState(() {});
                          },
                          child: const Text("Discard"),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          style: ButtonStyle(
                            shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          onPressed: () {
                            Map save = {};
                            for (int i = 0; i < controllerList.length; i++) {
                              save[editableValues[i]["key"]] =
                                  controllerList[i].text;
                            }
                            saveJsonValues(save);
                            setState(() {});
                          },
                          child: const Text("Save"),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    style: ButtonStyle(
                      shape: MaterialStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    onPressed: () {
                      List<String> keyList = [];
                      for (int i = 0; i < editableValues.length; i++) {
                        keyList.add(editableValues[i]["key"]);
                      }
                      reorderDialog(keyList);
                    },
                    tooltip: "Reorder Keys",
                    icon: const Icon(Icons.reorder),
                  ),
                  IconButton(
                    style: ButtonStyle(
                      shape: MaterialStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    onPressed: addDialog,
                    tooltip: "Add key value pair",
                    icon: const Icon(Icons.add),
                  ),
                  IconButton(
                    onPressed: () {
                      List<String> keyList = [];
                      for (int i = 0; i < editableValues.length; i++) {
                        keyList.add(editableValues[i]["key"]);
                      }
                      deleteDialog(keyList);
                    },
                    style: ButtonStyle(
                      shape: MaterialStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    tooltip: "delete Key entry",
                    icon: const Icon(
                      Icons.delete_rounded,
                    ),
                  )
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

  void addDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController keyController = TextEditingController();
        final TextEditingController valueController = TextEditingController();
        return AlertDialog(
          title: const Text("Add Key Value Pair"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(label: Text("Enter Key")),
                controller: keyController,
              ),
              TextFormField(
                decoration: const InputDecoration(label: Text("Enter Value")),
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
                  addJsonKeyValues(keyController.text, valueController.text);
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
  }

  void deleteDialog(List<String> itemList) {
    Color currentTextColor = Theme.of(context).textTheme.bodyMedium!.color!;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        List<String> selectedItems = [];
        double setWidth = 500;
        double setHeight = 300;
        return AlertDialog(
          title: const Text('Delete Key Value Pair'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SizedBox(
                width: double.minPositive > setWidth
                    ? double.minPositive
                    : setWidth,
                height: setHeight,
                child: ListView.builder(
                  itemCount: itemList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: currentTextColor),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListTile(
                          title: Text(itemList[index]),
                          trailing: IconButton(
                            onPressed: () {
                              setState(() {
                                selectedItems.add(itemList[index]);
                                itemList.removeAt(index);
                              });
                            },
                            icon: const Icon(Icons.delete),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                deleteJsonKeyValues(itemList);
                Navigator.of(context).pop();
                setState(() {});
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void reorderDialog(List<String> itemList) {
    Color currentTextColor = Theme.of(context).textTheme.bodyMedium!.color!;
    List<String> reorderedList = List.from(itemList);
    ValueNotifier<bool> isUpdated = ValueNotifier<bool>(false);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        isUpdated.addListener(() {
          setState(() {});
        });
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                child: Column(
                  children: [
                    Expanded(
                      child: ReorderableListView.builder(
                        padding: const EdgeInsets.all(8.0),
                        itemBuilder: (context, index) {
                          return ReorderableDragStartListener(
                            key: ValueKey(reorderedList[index]),
                            index: index,
                            child: Padding(
                              key: ValueKey(reorderedList[index]),
                              padding: const EdgeInsets.all(4.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: currentTextColor),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: ListTile(
                                  title: Text(reorderedList[index]),
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: reorderedList.length,
                        onReorder: (oldIndex, newIndex) {
                          setState(() {
                            if (oldIndex < newIndex) {
                              newIndex -= 1;
                            }
                            final String item =
                                reorderedList.removeAt(oldIndex);
                            reorderedList.insert(newIndex, item);
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("cancel"),
                          ),
                          const SizedBox(width: 16),
                          TextButton(
                            onPressed: () {
                              reorderJsonKeys(reorderedList);
                              Navigator.of(context).pop();
                              isUpdated.value = !isUpdated.value;
                            },
                            child: const Text("Save"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
