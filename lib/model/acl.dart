part of catalog_tree;

class AclLevel {
  final bool isOwner;
  final bool canEdit;
  final bool canDelete;
  final bool canShare;

  AclLevel(
      {this.isOwner = false,
      this.canEdit = false,
      this.canDelete = false,
      this.canShare = false});

  AclLevel.forOwner(
      {this.isOwner: true,
      this.canEdit: true,
      this.canDelete: true,
      this.canShare: true});

  AclLevel.fromMap(Map map)
      : assert(map["isOwner"]),
        assert(map["canEdit"]),
        assert(map["canDelete"]),
        assert(map["canShare"]),
        this.isOwner = map["isOwner"],
        this.canEdit = map["canEdit"],
        this.canDelete = map["canDelete"],
        this.canShare = map["canShare"];


  static Map<String, bool> toMap(AclLevel acl){
    var map = Map<String, bool>();
    map["isOwner"] = acl.isOwner;
    map["canEdit"] = acl.canEdit;
    map["canDelete"] = acl.canDelete;
    map["canShare"] = acl.canShare;
    return map;
  }
}

class ResourceAcl {
  final Map<String, AclLevel> permissions;

  ResourceAcl(this.permissions);

  ResourceAcl.fromMap(Map<dynamic, dynamic> map) : permissions = _fromMap(map);

  static Map<String, AclLevel> _fromMap(Map<dynamic, dynamic> map) {
    Map<String, AclLevel> acls = new Map<String, AclLevel>();
    map.forEach((dynamic key, dynamic _acl) {
      acls[key] = AclLevel.fromMap(_acl);
    });
    return acls;
  }

  static Map<dynamic, dynamic> toMap(ResourceAcl acl){
    var map = Map();
    acl.permissions.forEach((String key, AclLevel _acl) {
      map[key] = AclLevel.toMap(_acl);
    });
    return map;
  }
}
