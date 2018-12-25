part of catalog_tree;
class VideoInputAdapter {
  /// Initialize from either a URL or a file, but not both.
  VideoInputAdapter.fromFile(this.file)
      : this.url = null,
        assert(file != null);

  VideoInputAdapter.fromUrl(this.url)
      : this.file = null,
        assert(url != null);

  /// An image file
  final File file;

  /// A direct link to the remote image
  final String url;

  /// Render the thumbnail from a file or from a remote source.
  Widget widgetize() {
    if (file != null) {
      return Image.file(file);
    } else {
      return FadeInImage(
        image: NetworkImage(url),
        placeholder: AssetImage("assets/images/placeholder.png"),
        fit: BoxFit.contain,
      );
    }
  }

  Widget getThumbnail() {
    return FadeInImage(
        image: VideoThumbnail(file.path),
        placeholder: AssetImage("packages/flutter_gallery_assets/food/icons/main.png"),
        fit: BoxFit.cover
    );
  }
}
