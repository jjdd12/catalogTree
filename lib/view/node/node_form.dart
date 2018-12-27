part of catalog_tree;

class NodeForm extends StatefulWidget {
  final DocumentReference parentNode;
  final bool isRoot;
  final Function onSave;
  final LeafType type;

  const NodeForm(this.onSave, this.type,
      {Key key, this.parentNode, this.isRoot = false})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new NodeFormState(parentNode, onSave, type, isRoot: isRoot);
  }
}

class NodeFormState extends State<NodeForm> {
  final _formKey = GlobalKey<FormState>();
  final DocumentReference parentNode;
  final bool isRoot;
  final Db _db = new Db();
  final Function onSave;
  LeafType type;

  Map _data = new Map<String, dynamic>();

  NodeFormState(this.parentNode, this.onSave, this.type, {this.isRoot = false});


  @override
  Widget build(BuildContext context) {
    if(type == null) {
      return new LeafTypeSelector((LeafType type) => setState(() => this.type = type));
    }

    Widget childForm;
    switch (type) {
      case LeafType.collection:
        childForm = _buildCollectionFields();
        break;
      case LeafType.video:
        childForm = _buidVideoFields();
        break;
    }
    return Padding(
        padding: const EdgeInsets.all(25.0),
        child: Form(key: _formKey, child: childForm));
  }

  static Function emptyCheck = (value) {
    if (value.isEmpty) {
      return 'Please enter valid text';
    }
  };

  static InputDecoration label(String name) => new InputDecoration(
        labelText: 'Enter a $name',
      );

  Widget _buidVideoFields() {
    SingleChildScrollView body = SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: <Widget>[
          TextFormField(
            decoration: label(' Name'),
            validator: emptyCheck,
            onSaved: (String value) => _data["name"] = value,
          ),
          SizedBox(
            height: 13.0,
          ),
          ImageFormField<VideoInputAdapter>(
            shouldAllowMultiple: false,
            onSaved: (val) => _data["video"] = val[0].file.toString(),
            initializeFileAsImage: (file) => VideoInputAdapter.fromFile(file),
            previewImageBuilder: (_, image) => image.getThumbnail((String thumbPath) => _data["thumbnail"] = thumbPath),
            buttonBuilder: (BuildContext context, int num) => Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColorLight,
                  borderRadius:
                      const BorderRadius.all(const Radius.circular(6.0)),
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.videocam,
                          color: Theme.of(context).primaryColor),
                      Text(" Select Video",
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold))
                    ])),
          ), SizedBox(
            height: 13.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
              onPressed: () {
                // Validate will return true if the form is valid, or false if
                // the form is invalid.
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  saveVideo();
                }
              },
              child: Text('Save'),
            ),
          ),
        ]));
    return Scaffold(
        appBar: AppBar(centerTitle: true, title: const Text(" Add Video")),
        body: body);
  }

  Widget _buildCollectionFields() {
    SingleChildScrollView body = SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: label('Name'),
              validator: emptyCheck,
              onSaved: (String value) => _data["name"] = value,
            ),
            SizedBox(
              height: 13.0,
            ),
            TextFormField(
              decoration: label('Description'),
              validator: emptyCheck,
              onSaved: (String value) => _data["description"] = value,
            ),
            SizedBox(
              height: 13.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: RaisedButton(
                onPressed: () {
                  // Validate will return true if the form is valid, or false if
                  // the form is invalid.
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    saveCollection();
                  }
                },
                child: Text('Save'),
              ),
            ),
          ],
        ));
    return Scaffold(
        appBar: AppBar(centerTitle: true, title: const Text(" Add Collection")),
        body: body);
  }

  void saveCollection() {
    //TODO handle fails and complete
    _data["parent"] = parentNode;
    _data["acl"] = new Map<String, Map>();
    _data["acl"][_user.uid] = AclLevel.toMap(AclLevel.forOwner());
    _data["is_root"] = isRoot;
    _data["owner"] = _user.uid;
    _db.createNode(_data);
    this.onSave();
    //this one closes the form popup
    Navigator.pop(context);
  }

  void saveVideo(){
    _data["acl"] = new Map<String, Map>();
    _data["acl"][_user.uid] = AclLevel.toMap(AclLevel.forOwner());
    _data["type"]= VideoType.local.toString();
    _data["parent"] = parentNode;
    _data["creator"] = _user.uid;
    _data["is_root"] = isRoot;
    _db.createVideo(_data);
    this.onSave();
    //this one closes the form popup
    Navigator.pop(context);
  }
}