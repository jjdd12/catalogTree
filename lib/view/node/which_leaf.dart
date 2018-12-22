part of catalog_tree;

enum leafType { collection, video }

class LeafSelector extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    Scaffold body = Scaffold(
        body: Column(children: <Widget>[
      new Padding(
          padding: const EdgeInsets.all(20.0),
          child: new DropdownButton(
            hint: new Text('Select a type to add ...'),
            items: <DropdownMenuItem>[
              new DropdownMenuItem(
                child: new Text('Collection'),
                value: leafType.collection,
              ),
              new DropdownMenuItem(
                child: new Text('Video'),
                value: leafType.video,
              ),
            ],
          ))
    ]));
    return body;
  }
}
