part of catalog_tree;

enum VideoType {
  local,
  youtube
}

class Video {
  const Video({
    this.id,
    this.source,
    this.type,
    this.thumbnail,
    this.parent,
    this.name
  });

  final Uuid id;
  final Source source;
  final VideoType type;
  final Image thumbnail;
  final Node parent;
  final String name;
}



class Source {
  Source(this.type, this.owner);
  final String type;
  final FirebaseUser owner;
}



