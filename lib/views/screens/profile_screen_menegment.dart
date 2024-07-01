import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:topshiriq/viewmodel/user_edit_view_model.dart';
import 'package:topshiriq/views/widgets/custom_drawer.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserInfoViewModel _userInfoViewModel = UserInfoViewModel();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String userName = '';
  String userSurname = '';
  String phoneNumber = '';
  String profilePictureUrl = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text(tr('profile')),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(tr('profile_screen.edit_profile')),
                    content: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                initialValue:
                                    _userInfoViewModel.userInfo.userName,
                                decoration: InputDecoration(
                                    labelText: tr('profile_screen.name')),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return tr('profile_screen.enter_name');
                                  }
                                  return null;
                                },
                                onSaved: (newValue) {
                                  if (newValue != null) {
                                    userName = newValue;
                                  }
                                },
                              ),
                              TextFormField(
                                initialValue:
                                    _userInfoViewModel.userInfo.userSurname,
                                decoration: InputDecoration(
                                    labelText: tr('profile_screen.surname')),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return tr('profile_screen.enter_surname');
                                  }
                                  return null;
                                },
                                onSaved: (newValue) {
                                  if (newValue != null) {
                                    userSurname = newValue;
                                  }
                                },
                              ),
                              TextFormField(
                                initialValue:
                                    _userInfoViewModel.userInfo.phoneNumber,
                                decoration: InputDecoration(
                                    labelText:
                                        tr('profile_screen.phone_number')),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return tr(
                                        'profile_screen.enter_phone_number');
                                  }
                                  return null;
                                },
                                onSaved: (newValue) {
                                  if (newValue != null) {
                                    phoneNumber = newValue;
                                  }
                                },
                              ),
                              TextFormField(
                                initialValue: _userInfoViewModel
                                    .userInfo.profilePictureUrl,
                                decoration: InputDecoration(
                                    labelText: tr(
                                        'profile_screen.profile_picture_url')),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return tr(
                                        'profile_screen.enter_profile_picture_url');
                                  }
                                  return null;
                                },
                                onSaved: (newValue) {
                                  if (newValue != null) {
                                    profilePictureUrl = newValue;
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(tr('cancel')),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            _userInfoViewModel.editUserInfo(
                              newName: userName,
                              newSurname: userSurname,
                              newNumber: phoneNumber,
                              newPicture: profilePictureUrl,
                            );
                            setState(() {});
                            Navigator.of(context).pop();
                          }
                        },
                        child: Text(tr('save')),
                      ),
                    ],
                  );
                },
              );
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Center(
            child: Column(
              children: [
                Container(
                  height: 200,
                  width: 200,
                  clipBehavior: Clip.hardEdge,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: Image.network(
                    _userInfoViewModel.userInfo.profilePictureUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 20),
                Text(tr('profile_screen.your_name', namedArgs: {
                  'userName': _userInfoViewModel.userInfo.userName
                })),
                Text(tr('profile_screen.your_surname', namedArgs: {
                  'userSurname': _userInfoViewModel.userInfo.userSurname
                })),
                Text(tr('profile_screen.your_phone_number', namedArgs: {
                  'phoneNumber': _userInfoViewModel.userInfo.phoneNumber
                })),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
