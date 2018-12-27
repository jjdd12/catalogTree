part of catalog_tree;

class NodeRoute {
  const NodeRoute._({this.name, this.icon});

  @required
  final String name;
  @required
  final IconData icon;

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) return true;
    if (runtimeType != other.runtimeType) return false;
    final NodeRoute typedOther = other;
    return typedOther.name == name && typedOther.icon == icon;
  }

  @override
  int get hashCode => hashValues(name, icon);

  @override
  String toString() {
    return '$runtimeType($name)';
  }
}

class NodeContainer {
  const NodeContainer(
      {@required this.title,
      @required this.icon,
//    this.subtitle,
      @required this.category,
      @required this.routeName,
      @required this.reference})
      : assert(title != null),
        assert(category != null),
        assert(routeName != null);
  final String title;
  final IconData icon;

//  final String subtitle;
  final NodeRoute category;
  final String routeName;
  final DocumentReference reference;

  @override
  String toString() {
    return '$runtimeType($title $routeName)';
  }

  static List<NodeContainer> fromDb(QuerySnapshot value) {
    List<NodeContainer> nodes = new List<NodeContainer>();
    value.documents.forEach((DocumentSnapshot document) {
      nodes.add(NodeContainer.fromNode(Node.fromSnapshot(document)));
    });
    return nodes;
  }

  NodeContainer.fromNode(Node node)
      : icon = null,
        title = node.name,
        reference = node.reference,
        category = NodeRoute._(
          name: node.name,
          icon: Icons.perm_media,
        ),
  //TODO adjust to create a valid route name
        routeName = node.name;
}
