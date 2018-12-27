part of catalog_tree;

class Db {
  Firestore db = Firestore.instance;
  CollectionReference nodes;
  CollectionReference videos;

  static final Db _db = new Db._internal();

  factory Db() => _db;

  Db._internal() {
    this.nodes = db.collection('nodes');
    this.videos = db.collection('videos');
    db.settings(timestampsInSnapshotsEnabled: true);
  }

  getRootNodes(Function callback) {
    if (_user == null) {
      return signInWithGoogle()
          .then((FirebaseUser user) => getRootNodes(callback));
    }
    Future<QuerySnapshot> fromDb = nodes
        .where("is_root", isEqualTo: true)
        .where("owner", isEqualTo: _user.uid)
        .getDocuments();
    return fromDb.then((QuerySnapshot value) => callback(value));
  }


  getRootVideos(Function callback) {
    if (_user == null) {
      return signInWithGoogle()
          .then((FirebaseUser user) => getRootNodes(callback));
    }
    Future<QuerySnapshot> fromDb = videos
        .where("is_root", isEqualTo: true)
        .where("creator", isEqualTo: _user.uid)
        .getDocuments();
    return fromDb.then((QuerySnapshot value) => callback(value));
  }

  getNodesByParent(DocumentReference parent, Function callback) {
    Future<QuerySnapshot> fromDb =
        nodes.where("parent", isEqualTo: parent).getDocuments();
    return fromDb.then((QuerySnapshot value) => callback(value));
  }

  getVideosByParent(DocumentReference parent, Function callback) {
    Future<QuerySnapshot> fromDb =
        videos.where("parent", isEqualTo: parent).getDocuments();
    return fromDb.then((QuerySnapshot value) => callback(value));
  }

  createNode(Map node, {bool isRoot = false}) {
    nodes.add(node);
  }

  createVideo(Map video){
    videos.add(video);
  }
}
