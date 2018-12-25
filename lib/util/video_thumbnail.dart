part of catalog_tree;

class VideoThumbnail extends ImageProvider<VideoThumbnail> {
  final String path;

  final String savePath;

  final ThumbFormat imageFormat;

  VideoThumbnail(this.path,
      {
        this.savePath = '/storage/emulated/0/Android/data/jhony.app.catalog/files',
        this.imageFormat = ThumbFormat.PNG,
      });

  @override
  ImageStreamCompleter load(VideoThumbnail key) {
    return MultiFrameImageStreamCompleter(
        codec: _loadAsync(key),
        scale: 1.0,
        informationCollector: (StringBuffer information) {
          information.writeln('Path: ${key?.path}');
        });
  }

  Future<Ui.Codec> _loadAsync(VideoThumbnail key) async {
    assert(key == this);
    Future<String> thumb = Thumbnails.getThumbnail(
        thumbnailFolder: savePath,
        // creates the specified path if it doesnt exist
        videoFile: key.path,
        imageType: imageFormat,
        quality: 30);

    File imageFile = File(await thumb);
    final Uint8List bytes = await imageFile.readAsBytes();
    if (bytes.lengthInBytes == 0)
      return null;

    return await PaintingBinding.instance.instantiateImageCodec(bytes);
  }

  @override
  Future<VideoThumbnail> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<VideoThumbnail>(this);
  }
}
