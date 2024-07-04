import 'package:flutter/material.dart';
import 'package:pillpalmobile/screens/userinformation/components/appbar_widget.dart';
import 'package:pillpalmobile/screens/userinformation/components/profile_widget.dart';
import 'package:pillpalmobile/screens/userinformation/components/textfield_widget.dart';
import 'package:pillpalmobile/constants.dart';
class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  @override
  Widget build(BuildContext context) => Builder(
        builder: (context) => Scaffold(
          appBar: buildAppBar(context),
          body: ListView(
            padding: EdgeInsets.symmetric(horizontal: 32),
            physics: BouncingScrollPhysics(),
            children: [
              ProfileWidget(
                imagePath: userInfomation.loginuser!.photoURL.toString(),
                isEdit: true,
                onClicked: () async {},
              ),
              const SizedBox(height: 10),
              TextFieldWidget(
                label: 'Họ tên',
                text: 'Nguyễn Hoàng Chiến',
                onChanged: (name) {},
              ),
              const SizedBox(height: 10),
              TextFieldWidget(
                label: 'Giới Tính',
                text: 'Nam',
                onChanged: (email) {},
              ),
              const SizedBox(height: 10),
              TextFieldWidget(
                label: 'Ngày sinh',
                text: '1/1/1999',
                onChanged: (name) {},
              ),
              const SizedBox(height: 10),
              TextFieldWidget(
                label: 'Số điện thoại',
                text: '0909080908',
                onChanged: (name) {},
              ),
              const SizedBox(height: 10),
              TextFieldWidget(
                label: 'Địa chỉ',
                text: 'TP.Hồ Chí Minh',
                onChanged: (name) {},
              ),
              const SizedBox(height: 10),
              TextButton(
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.focused))
                      return Colors.red;
                    return null; // Defer to the widget's default.
                  }),
                ),
                onPressed: () {},
                child: Text('Lưu'),
              )
            ],
          ),
        ),
      );
}
