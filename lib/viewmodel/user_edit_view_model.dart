import 'package:topshiriq/model/user_info.dart';

class UserInfoViewModel {
  final UserInfo _userInfo = UserInfo(
    userName: 'userName',
    userSurname: 'userSurname',
    phoneNumber: 'phoneNumber',
    profilePictureUrl:
        'https://w7.pngwing.com/pngs/799/987/png-transparent-computer-icons-avatar-social-media-blog-font-awesome-avatar-heroes-computer-wallpaper-social-media.png',
  );

  UserInfo get userInfo {
    return _userInfo;
  }

  void editUserInfo({
    required String newName,
    required String newSurname,
    required String newNumber,
    required String newPicture,
  }) {
    _userInfo.userName = newName;
    _userInfo.userSurname = newSurname;
    _userInfo.phoneNumber = newNumber;
    _userInfo.profilePictureUrl = newPicture;
  }
}