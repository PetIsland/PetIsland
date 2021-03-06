part of petisland.profile.widget;

class BasicFunctionWidget extends StatelessWidget {
  final VoidCallback onTapLogout;
  final VoidCallback onTapChangePassword;
  final VoidCallback onTapReport;
  final VoidCallback onTapRating;

  const BasicFunctionWidget(
      {Key key,
      this.onTapLogout,
      this.onTapChangePassword,
      this.onTapReport,
      this.onTapRating})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final spacer = const SizedBox(height: 10);
    return Flex(
      direction: Axis.vertical,
      children: <Widget>[
        _buildRating(),
        spacer,
        _buildReport(),
        spacer,
        _buildChangePassword(),
        spacer,
        _buildLogout(),
        spacer,
      ],
    );
  }

  Widget _buildChangePassword() {
    // TODO(hao): Enable change password in next version
    return EnableWidget(
      enable: false,
      child: SettingOptionWidget(
        title: 'Change Password',
        onTap: onTapChangePassword,
        icon: Icon(Icons.security),
      ),
    );
  }

  Widget _buildRating() {
    // TODO(tvc12): Enable review in the feature
    return EnableWidget(
      enable: false,
      child: SettingOptionWidget(
        title: 'Review',
        onTap: onTapRating,
        icon: Icon(Icons.star_half),
      ),
    );
  }

  Widget _buildReport() {
    // TODO(tvc12): Enable Report and Suggestion in the feature
    return EnableWidget(
      enable: false,
      child: SettingOptionWidget(
        title: 'Report and Suggestion',
        onTap: onTapReport,
        icon: Icon(Icons.info_outline),
      ),
    );
  }

  Widget _buildLogout() {
    return SettingOptionWidget(
      title: 'Log Out',
      onTap: onTapLogout,
      icon: SvgIconWidget(
        icon: Transform.rotate(
          angle: pi,
          child: SvgPicture.asset(
            TAssets.logout,
            color: TColors.black,
          ),
        ),
      ),
    );
  }
}
