part of catalog_tree;

class Node {
  const Node({
    this.parent,
    this.name,
    this.description,
    this.acl,
    this.reference,
    this.isRoot
  });

  final DocumentReference reference;
  final DocumentReference parent;
  final String name;
  final String description;
  final ResourceAcl acl;
  final bool isRoot;

  Node.fromMap(Map<String, dynamic> map, {this.reference})
      :
        assert(map['name'] != null),
        assert(map['description'] != null),
        assert(map['acl'] != null),
        assert(map['description'] != null),
        name = map['name'],
        description = map['description'],
        acl = ResourceAcl.fromMap(map['acl']),
        parent = map['parent'],
        isRoot = map['is_root'];

  Node.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

}