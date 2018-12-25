part of catalog_tree;

enum VideoType {
  local,
  youtube
}

class Video {
  const Video({
    this.reference,
    this.source,
    this.type,
    this.thumbnail,
    this.parent,
    this.name
  });

  final DocumentReference reference;
  final Source source;
  final VideoType type;
  final Image thumbnail;
  final Node parent;
  final String name;
}



class Source {
  Source(this.path, this.owner, this.acl);
  final ResourceAcl acl;
  final String path;
  final FirebaseUser owner;
}



