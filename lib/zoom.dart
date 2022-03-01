import "package:flutter/widgets.dart";

class ZoomImageWidget extends StatelessWidget {
  const ZoomImageWidget(this.url, { Key? key }) : super(key: key);

  final String url;

  @override
  Widget build(BuildContext context) {
    return GestureDetector (
      child: Hero (
        tag: url,
        child: Image.network(url),
      ),
      onTap: () {
        Navigator.pop(context);
      },
    );
  }
}