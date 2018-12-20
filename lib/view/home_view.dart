part of catalog_tree;


class NodeViewState extends State<NodeView> {
  List<NodeContainer> children;
  DocumentReference currentNode;
  bool isRoot;
  String title;
  final _suggestions = Set<NodeContainer>();
  final _biggerFont = const TextStyle(fontSize: 18.0);
  final Db db = new Db();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title != null ? title : "Home"),
      ),
      body: _buildSuggestions(context),
      floatingActionButton: new FloatingActionButton(
        onPressed: _showDialog,
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ),
    );
  }

  Widget _buildSuggestions(BuildContext context) {
    _suggestions.addAll(this.children);
    return ListView(
        padding: const EdgeInsets.all(16.0),
        // The itemBuilder callback is called once per suggested word pairing,
        // and places each suggestion into a ListTile row.
        // For even rows, the function adds a ListTile row for the word pairing.
        // For odd rows, the function adds a Divider widget to visually
        // separate the entries. Note that the divider may be difficult
        // to see on smaller devices.
        children:
            children.map((dynamic node) => _buildRow(node)).toList());
  }

  void _showDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) =>
            new NodeForm(updateNodesFromDb, parentNode: currentNode, isRoot: isRoot));
  }

  Widget _buildRow(NodeContainer node) {
    return ListTile(
      leading: new Icon(node.category.icon),
      title: Text(
        node.title,
        style: _biggerFont,
      ),
      onTap: () {
        db.getNodesByParent(node.reference, (data) {
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            List<NodeContainer> nodes = new List<NodeContainer>();
            data.documents.forEach((DocumentSnapshot document) {
              nodes
                  .add(NodeContainer.fromNode(Node.fromSnapshot(document)));
            });
            return NodeView(
                childrenNodes: nodes,
                title: node.category.name,
                currentNode: node.reference);
          }));
        });
      },
    );
  }

  nodesRefresh(QuerySnapshot value) {
    setState(()=> children = NodeContainer.fromDb(value));
  }

  //refreshes the the children nodes from the database
  updateNodesFromDb(){
    if (isRoot) {
      db.getRootNodes(nodesRefresh);
    } else {
      db.getNodesByParent(currentNode, nodesRefresh);
    }
  }
}

class NodeView extends StatefulWidget {
  const NodeView(
      {Key key,
      this.childrenNodes,
      this.title,
      this.currentNode,
      this.isRoot = false})
      : super(key: key);

  final List<NodeContainer> childrenNodes;
  final DocumentReference currentNode;
  final bool isRoot;
  final String title;

  @override
  NodeViewState createState() {
    var state = new NodeViewState();
    state.children = this.childrenNodes;
    state.title = title;
    state.currentNode = currentNode;
    state.isRoot = isRoot;
    return state;
  }
}
