part of petisland.post.post_edit.widget;

class ChungLoaiPostInput extends TStatelessWidget {
  final TextEditingController chungLoaiController;

  ChungLoaiPostInput(this.chungLoaiController);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        padding: EdgeInsets.only(left: 13, right: 5),
        child: Flex(
          crossAxisAlignment: CrossAxisAlignment.start,
          direction: Axis.vertical,
          children: <Widget>[
            Text(
              'Chủng loại',
              style: TTextStyles.bold(
                fontSize: 18,
              ).copyWith(
                fontFamily: FontFamilies.thabit,
              ),
            ),
            TextField(
              controller: chungLoaiController,
            )
          ],
        ),
      ),
    );
  }
}