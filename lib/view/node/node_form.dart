part of catalog_tree;
class NodeForm extends StatefulWidget {
  final DocumentReference parentNode;
  final bool isRoot;
  final Function onSave;

  const NodeForm(this.onSave, {Key key, this.parentNode, this.isRoot = false}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new NodeFormState(parentNode, onSave, isRoot: isRoot);
  }
}

class NodeFormState extends State<NodeForm> {
  final _formKey = GlobalKey<FormState>();
  final DocumentReference parentNode;
  final bool isRoot;
  final Db _db = new Db();
  final Function onSave;

  Map _data = new Map<String, dynamic>();

  NodeFormState(this.parentNode, this.onSave, {this.isRoot = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(25.0),
        child: Form(key: _formKey, child: _buildFields()));
  }

  static Function emptyCheck = (value) {
    if (value.isEmpty) {
      return 'Please enter valid text';
    }
  };

  static InputDecoration label(String name) => new InputDecoration(
        labelText: 'Enter a $name',
      );

  Widget _buildFields() {
    Scaffold body = Scaffold(
        body: Column(
      children: <Widget>[
        TextFormField(
            decoration: label('Name'),
            validator: emptyCheck,
            onSaved: (String value) => _data["name"] = value,
        ),
        SizedBox(
          height: 13.0,
        ),
        TextFormField(decoration: label('Description'), validator: emptyCheck,
          onSaved: (String value) => _data["description"] = value,),
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
                // TODO display progress
                  saveNode();
              }
            },
            child: Text('Save'),
          ),
        ),
      ],
    ));
    return body;
  }

  void saveNode() {
    //TODO handle fails and complete
     _data["parent"] = parentNode;
    var acl = new Map<String, Map>();
    acl["someSTringhere"] = AclLevel.toMap(AclLevel.forOwner());
    _data["acl"] = acl;
    _data["is_root"] = isRoot;
    _db.createNode(_data);
    this.onSave();
    Navigator.pop(context);
  }
}
