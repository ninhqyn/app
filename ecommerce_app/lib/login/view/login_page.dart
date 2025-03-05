import 'package:authentication_repository/authentication_repository.dart';
import 'package:ecommerce_app/forgotpassword/view/forgot_password.dart';
import 'package:ecommerce_app/login/bloc/login_bloc.dart';
import 'package:ecommerce_app/shop/bloc/shop_bloc.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';

import '../../main/view/my_home_page.dart';
import '../widgets/facebook_button.dart';
import '../widgets/google_button.dart';
import '../widgets/login_button.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});
  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const LoginPage());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocProvider(
          create: (context) => LoginBloc(authenticationRepository:
          context.read<AuthenticationRepository>()),
          child: BlocConsumer<LoginBloc, LoginState>(
            listener: (context, state) {
              if (state.status == LoginStatus.success && state.isValid) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const MyHomePage()),
                );
              }
            },
  builder: (context, state) {
    return Stack(
      children: [
        const LoginView(),
        //Loading
        if (state.status == LoginStatus.inProgress)
          Container(
            color: Colors.black.withOpacity(0.3),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  },
),
    )
    );
  }
}
class LoginView extends StatelessWidget{
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Text('Login',
            style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),)),
          Spacer(),
          Expanded(
            flex: 5,
            child: _MyForm(),
          ),
          Spacer(flex: 3),
          Expanded(flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Or login witch social account'),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GoogleButton(),
                      SizedBox(width: 10,),
                       FaceBookButton(),
                    ],
                  )
                ],
              )
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _EmailInput(),
              const SizedBox(height: 16),
              const _PasswordInput(),
              const SizedBox(height: 16),
              BlocBuilder<LoginBloc, LoginState>(
                builder: (context, state) {
                  if(state.errorMessage == ''){
                    return Container();
                  }
                  return _AuthenticationStatus(state.errorMessage);
                },
              ),
              InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ForgotPassword()));

                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text('Forgot your password', textAlign: TextAlign.right),
                    const SizedBox(width: 20),
                    SvgPicture.asset('assets/images/next.svg'),
                  ],
                ),
              ),
              
              const LoginButton(),

              const SizedBox(height: 16),
            ],
          ),
        );
  }

}
class _AuthenticationStatus extends StatelessWidget{
  final String status;

  const _AuthenticationStatus(this.status);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(status,style: const TextStyle(
        fontSize: 16,
        color: Colors.red
      ),),
    );
  }
}
class _PasswordInput  extends StatelessWidget{
  const _PasswordInput();

  @override
  Widget build(BuildContext context) {
    final passwordError = context.select((LoginBloc bloc) => bloc.state.passwordError);
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) =>
      previous.obscurePassword != current.obscurePassword ||
          previous.passwordError != current.passwordError,
      builder: (context, state) {
        return TextFormField(
          key: const Key('key_password'),
          obscureText: state.obscurePassword,
          decoration: InputDecoration(
            labelText: 'Password',
            errorText: passwordError.isEmpty ? null : passwordError,
            border: const OutlineInputBorder(),
            suffixIcon: IconButton(
              icon: Icon(
                state.obscurePassword ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey,
              ),
              onPressed: () {
                context.read<LoginBloc>().add(const ObscurePassword());
              },
            ),
          ),
          onChanged: (value) {
            context.read<LoginBloc>().add(PasswordChanged(value));
          },
        );
      },
    );
  }
}

class _EmailInput  extends StatelessWidget{
  const _EmailInput();
  @override
  Widget build(BuildContext context) {
    final emailError = context.select((LoginBloc bloc) => bloc.state.emailError);
    final emailTouched = context.select((LoginBloc bloc) => bloc.state.emailTouched);

    return TextFormField(
      key: const Key('key_username'),
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'Email',
        errorText: emailError.isEmpty ? null : emailError,
        border: const OutlineInputBorder(),
        suffixIcon: emailError.isEmpty && emailTouched
            ? const Icon(Icons.check, color: Colors.green)
            : null,
      ),
      onChanged: (value) {
        context.read<LoginBloc>().add(EmailChanged(value));
      },
    );
  }
}

