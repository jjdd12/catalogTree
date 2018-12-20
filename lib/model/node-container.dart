part of catalog_tree;

class MovesMain extends StatelessWidget {
  const MovesMain({Key key}) : super(key: key);

  static const String routeName = '/pesto';

  @override
  Widget build(BuildContext context) => new MovesHome();
}

class MovesHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //  return const RecipeGridPage(recipes: kMoveDetails);
  }
}

class MovesFavorites extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //return new RecipeGridPage(recipes: _favoriteRecipes.toList());
  }
}

class MoveStyle extends TextStyle {
  const MoveStyle({
    double fontSize: 12.0,
    FontWeight fontWeight,
    Color color: Colors.black87,
    double letterSpacing,
    double height,
  }) : super(
          inherit: false,
          color: color,
          fontFamily: 'Raleway',
          fontSize: fontSize,
          fontWeight: fontWeight,
          textBaseline: TextBaseline.alphabetic,
          letterSpacing: letterSpacing,
          height: height,
        );
}

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
          icon: GalleryIcons.menu,
        ),
        routeName = MovesMain.routeName;
}
