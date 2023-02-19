import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:mashtoz_flutter/ui/utils/log_out_changenotifire.dart';
import 'package:mashtoz_flutter/ui/widgets/buttons/facebook_gmail_buttons.dart';

import '../../../../config/palette.dart';
import '../singup_screen/singup_screen.dart';
import 'login_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).size.height);
    return LoadingOverlay(
        isLoading:context.watch<UserLogOutNotifier>().userLogOut,
    opacity: 0.0,
    progressIndicator: CircularProgressIndicator(),

      child: Scaffold(
        resizeToAvoidBottomInset: false,

        backgroundColor: const Color.fromRGBO(
          83,
          66,
          76,
          1,
        ),
        body: SafeArea(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Stack(
                  children: [
                    Align(alignment: Alignment.topLeft,
                    child: IconButton(onPressed: ()=>Navigator.of(context,rootNavigator: true).pop(), icon: Icon(Icons.arrow_back_ios_new_outlined),color: Colors.white,),
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 20.0, left: 20.0),
                          child: Column(
                            children: const [
                              SizedBox(height: 30),
                              Center(
                                child: SizedBox(
                                  width: 142,
                                  height: 98,
                                  child: Image(
                                    image: AssetImage(
                                        "assets/images/mashtoz_org.png"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              LoginForm(),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 55.0),
                      child: Align(
                          alignment: Alignment.bottomCenter,
                          child: ComplexButton(isLogin: true,)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
