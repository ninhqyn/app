import 'package:ecommerce_app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../login/widgets/facebook_button.dart';
import '../../login/widgets/google_button.dart';
import '../../login/widgets/login_button.dart';
class ForgotPassword extends StatelessWidget{
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar:AppBar(
        title: const Text('forgot'),
      ),
      body: const SafeArea(child: ForgotView()),
    );
  }

}
class ForgotView extends StatelessWidget{
  const ForgotView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Text('Forgot Password',
            style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),)),
          Spacer(flex: 2,),
          Expanded(
            flex: 5,
            child: _MyForm(),
          ),
          Spacer(flex: 3),
          Expanded(flex: 2,
            child: SizedBox(height: 10,),
          ),
          Spacer()
        ],
      ),
    );
  }

}


class _MyForm extends StatefulWidget {
  @override
  State<_MyForm> createState() => _MyFormState();

  const _MyForm();
}

class _MyFormState extends State<_MyForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    return Form(
      key: _formKey,
      child: const Column(
        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 1,
            child: Text('Please,enter your email address.'
            'You will receive a link to create a new pass word via email.'),
          ),
          SizedBox(height: 10),
          Expanded(flex: 2,child: _EmailInput()),
          Spacer(flex: 2,),
          Expanded(
            flex: 1,
              child: SendButton()),
        ],
      ),
    );
  }

}


class _EmailInput  extends StatelessWidget{
  const _EmailInput();

  @override
  Widget build(BuildContext context) {
        return TextField(
          key: const Key('key_email'),
          decoration: InputDecoration(
            labelText: 'Password',
            //errorText: passwordError.isEmpty ? null : passwordError,
            border: const OutlineInputBorder(),
            suffixIcon: IconButton(
              icon: SvgPicture.asset('assets/images/outline-close-24px.svg'),
              onPressed: () {
                //context.read<LoginBloc>().add(const ObscurePassword());
              },
            ),
          ),
          onChanged: (value) {
            //context.read<LoginBloc>().add(PasswordChanged(value));
          },
            );
  }
}
class SendButton extends StatelessWidget {
  const SendButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
      },
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 48),
        backgroundColor: Colors.red,
      ),
      child: const Text('LOGIN',style: TextStyle(
        color: Colors.white
      ),),

    );
  }
}