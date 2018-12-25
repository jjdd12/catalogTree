part of catalog_tree;

enum LeafType { collection, video }

class LeafTypeSelector extends StatelessWidget {
  final Function onChange;

  const LeafTypeSelector(this.onChange, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Padding body = Padding(
      padding: EdgeInsets.symmetric(vertical: 300.0, horizontal: 80.0),
        child: Scaffold(
            body:  new DropdownButton<LeafType>(
                hint: new Text(' Select a type to add ...'),
                items: <DropdownMenuItem<LeafType>>[
                  new DropdownMenuItem(
                    child: new Text('Collection'),
                    value: LeafType.collection,
                  ),
                  new DropdownMenuItem(
                    child: new Text('Video'),
                    value: LeafType.video,
                  ),
                ],
                onChanged: (LeafType type) {
                  // closes the dialog then call the onChange callback
                  //Navigator.pop(context);
                  onChange(type);
                },
              ))
        );
    return body;
  }
}
