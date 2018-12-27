part of catalog_tree;

enum VideoType { local, youtube }

class Video {
  Video({this.isRoot,
      this.acl,
      this.type,
      this.thumbnail,
      this.parent,
      this.name,
      this.creator,
      this.reference,
      this.player});

  final DocumentReference reference;
  final ResourceAcl acl;
  final FirebaseUser creator;
  Player player;
  final VideoType type;
  final Image thumbnail;
  final Node parent;
  final String name;
  final bool isRoot;

  static List<Video> fromDb(QuerySnapshot value) {
    List<Video> videos = new List<Video>();
    value.documents.forEach((DocumentSnapshot document) {
      videos.add(Video.fromSnapshot(document));
    });
    return videos;
  }

  Video.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['type'] != null),
        assert(map['acl'] != null),
        assert(map['thumbnail'] != null),
        assert(map["creator"] != null),
        name = map['name'],
        type = map['type'],
        thumbnail = map["thumbnail"],
        creator = map["creator"],
        acl = ResourceAcl.fromMap(map['acl']),
        parent = map['parent'],
        isRoot = map['is_root'];

  Video.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);
}

abstract class Player extends StatefulWidget {
  Player(this.path);

  final String path;
}

class LocalPlayer extends Player {
  LocalPlayer(String path) : super(path);

  @override
  State<StatefulWidget> createState() => LocalVideoState(path);
}

class LocalVideoState extends State<LocalPlayer> {
  final String path;
  VideoPlayerController _controller;
  bool _isPlaying = false;

  LocalVideoState(this.path);

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
      path,
    )
      ..addListener(() {
        final bool isPlaying = _controller.value.isPlaying;
        if (isPlaying != _isPlaying) {
          setState(() {
            _isPlaying = isPlaying;
          });
        }
      })
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Demo',
      home: Scaffold(
        body: Center(
          child: _controller.value.initialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
              : Container(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _controller.value.isPlaying
              ? _controller.pause
              : _controller.play,
          child: Icon(
            _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          ),
        ),
      ),
    );
  }
}
