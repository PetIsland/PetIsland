part of petisland.pet_feed.widget.post;

class PostWidget extends PostItemRender<Post> {
  final VoidCallback reRender;

  const PostWidget(
    Post item, {
    Key key,
    this.reRender,
  }) : super(item, key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Card(
        elevation: 1,
        borderOnForeground: true,
        child: Flex(
          mainAxisSize: MainAxisSize.max,
          direction: Axis.vertical,
          children: <Widget>[
            Expanded(
              flex: 7,
              child: InkWell(
                onTap: () => _onTapPost(context),
                child: PreviewPostWidget(item: item),
              ),
            ),
            Expanded(
              flex: 2,
              child: PostButtonBar(item: item),
            )
          ],
        ),
      ),
    );
  }

  void _onTapPost(BuildContext context) {
    navigateToScreen(
      context: context,
      screen: PostDetailScreen(
        item: item,
        onDeletePost: () => _removePost(context, item.id),
      ),
      screenName: PostDetailScreen.name,
    ).whenComplete(() {
      if (reRender != null) {
        reRender();
      }
    });
  }

  void _removePost(BuildContext context, String id) {
    DI.get<PetFeedController>(PetFeedController).remove(id);
  }
}

// class  {

// }

void tlaunch(String text, {LaunchMode mode = LaunchMode.Url}) async {
  String _getPrefixByMode(LaunchMode mode) {
    switch (mode) {
      case LaunchMode.Phone:
        return 'tel:';
      case LaunchMode.Message:
        return 'sms:';
      default:
        return '';
    }
  }

  final String prefix = _getPrefixByMode(mode);
  text = '$prefix$text';
  canLaunch(text)
      .then((isLaunch) => isLaunch ? launch(text) : throw Exception('cannot launch'))
      .catchError((ex) => Log.error(ex));
}

enum LaunchMode {
  Url,
  Phone,
  Message,
}
