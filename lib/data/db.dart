part of catalog_tree;


class Db {
  Firestore db = Firestore.instance;
  CollectionReference nodes;

  static final Db _db = new Db._internal();
  factory Db() => _db;

   Db._internal() {
    this.nodes = db.collection('nodes');
    db.settings(timestampsInSnapshotsEnabled: true);
  }

  getRootNodes(Function callback) {
    Future<QuerySnapshot> fromDb = db.collection('nodes')
        .where("is_root", isEqualTo: true).getDocuments();
    return fromDb.then((QuerySnapshot value) => callback(value));
  }

  getNodesByParent(DocumentReference parent, Function callback) {
    Future<QuerySnapshot> fromDb = db.collection('nodes')
        .where("parent", isEqualTo: parent)
        .getDocuments();
    return fromDb.then((QuerySnapshot value) => callback(value));
  }

  createNode(Map node, {bool isRoot = false}){
    this.nodes.add(node);
  }
}