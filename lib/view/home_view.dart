part of catalog_tree;

class NodeViewState extends State<NodeView> {
  List<Object> children = List<Object>();
  List<NodeContainer> childrenNodes;
  List<Video> videos;
  DocumentReference currentNode;
  bool isRoot;
  String title;
  final TextStyle _biggerFont = const TextStyle(fontSize: 18.0);
  final Db db = new Db();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isRoot ? "Home" : title != null ? title : ""),
        leading: new Icon(isRoot ? Icons.home : Icons.perm_media),
      ),
      body: _buildList(context),
      floatingActionButton: new FloatingActionButton(
        onPressed: _showDialog,
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    if (isRoot) {
      updateFromDb();
    }
  }

  Widget _buildList(BuildContext context) {
    List<Widget> widgets = List<Widget>();
    widgets.addAll(childrenNodes
        .map((dynamic node) => _buildCollectionRow(node))
        .toList());
//    var _videos = widgets
//        .addAll(videos.map((dynamic video) => _buildVideoRow(video)).toList());
    return ListView(
        padding: const EdgeInsets.all(16.0),
        // The itemBuilder callback is called once per suggested word pairing,
        // and places each suggestion into a ListTile row.
        // For even rows, the function adds a ListTile row for the word pairing.
        // For odd rows, the function adds a Divider widget to visually
        // separate the entries. Note that the divider may be difficult
        // to see on smaller devices.
        children: widgets);
  }

  void _showDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) => new NodeForm(updateFromDb, null,
            parentNode: currentNode, isRoot: isRoot));
  }

  Widget _buildCollectionRow(NodeContainer node) {
    return ListTile(
      leading: new Icon(
        node.category.icon,
        size: 32,
        color: Colors.black54,
      ),
      title: Text(
        node.title,
        style: _biggerFont,
      ),
      onTap: () {
        db.getNodesByParent(node.reference, (data) {
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            List<NodeContainer> nodes = new List<NodeContainer>();
            data.documents.forEach((DocumentSnapshot document) {
              nodes.add(NodeContainer.fromNode(Node.fromSnapshot(document)));
            });
            return NodeView(
                childrenNodes: nodes,
                title: node.category.name,
                currentNode: node.reference,
                isRoot: false);
          }));
        });
      },
    );
  }



  nodesRefresh(QuerySnapshot value) {
    setState(() => childrenNodes = NodeContainer.fromDb(value));
  }

  videosRefresh(QuerySnapshot value) {
    setState(() => videos = Video.fromDb(value));
  }

  //refreshes the the children nodes from the database
  updateFromDb() {
    if (isRoot) {
      db.getRootNodes(nodesRefresh);
      db.getRootVideos(videosRefresh);
    } else {
      db.getNodesByParent(currentNode, nodesRefresh);
      db.getVideosByParent(currentNode, videosRefresh);
    }
  }
}

class NodeView extends StatefulWidget {
  const NodeView(
      {Key key,
      this.childrenNodes,
      this.title,
      this.currentNode,
      this.isRoot = false,
      this.videos})
      : super(key: key);

  final List<NodeContainer> childrenNodes;
  final List<Video> videos;
  final DocumentReference currentNode;
  final bool isRoot;
  final String title;

  @override
  NodeViewState createState() {
    var state = new NodeViewState();
    state.childrenNodes = this.childrenNodes;
    state.title = title;
    state.currentNode = currentNode;
    state.isRoot = isRoot;
    state.videos = videos;
    return state;
  }
}
