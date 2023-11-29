import 'package:jsoneditor/values/values.dart';
import 'package:flutter/material.dart';

class FormTextTile extends StatefulWidget {
  final String name;
  final TextEditingController controller;
  const FormTextTile({
    required this.name,
    required this.controller,
    super.key,
  });

  @override
  State<FormTextTile> createState() => _FormTextTileState();
}

class _FormTextTileState extends State<FormTextTile> {
  late bool isExpanded;
  late TextEditingController xController, yController;

  @override
  void initState() {
    super.initState();
    isExpanded = defaultExpand.value;
  }

  @override
  Widget build(BuildContext context) {
    Color currentTextColor = Theme.of(context).textTheme.bodyMedium!.color!;
    return Padding(
      padding: const EdgeInsets.only(
        left: 8.0,
        right: 8.0,
        top: 4.0,
        bottom: 4.0,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: currentTextColor),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                title: Text(widget.name),
                trailing: isExpanded
                    ? const Icon(Icons.keyboard_arrow_up)
                    : const Icon(Icons.keyboard_arrow_down),
                onTap: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
              ),
              isExpanded
                  ? Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: TextFormField(controller: widget.controller),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
