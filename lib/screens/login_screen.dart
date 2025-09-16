
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';


class LoginScreen extends StatefulWidget {
const LoginScreen({super.key});

@override
State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
final _formKey = GlobalKey<FormState>();
final _emailController = TextEditingController();
final _passwordController = TextEditingController();
bool _isSignUp = false;

@override
void dispose() {
_emailController.dispose();
_passwordController.dispose();
super.dispose();
}

Future<void> _submit() async {
if (_formKey.currentState!.validate()) {
final authProvider = Provider.of<AuthProvider>(context, listen: false);
try {
if (_isSignUp) {
await authProvider.signUp(_emailController.text, _passwordController.text);
} else {
await authProvider.signIn(_emailController.text, _passwordController.text);
}
} catch (e) {
ScaffoldMessenger.of(context).showSnackBar(
SnackBar(content: Text(e.toString())),
);
}
}
}

@override
Widget build(BuildContext context) {
final authProvider = Provider.of<AuthProvider>(context);
return Scaffold(
appBar: AppBar(title: Text(_isSignUp ? 'Sign Up' : 'Login')),
body: Padding(
padding: const EdgeInsets.all(16.0),
child: Form(
key: _formKey,
child: Column(
mainAxisAlignment: MainAxisAlignment.center,
children: [
TextFormField(
controller: _emailController,
decoration: const InputDecoration(labelText: 'Email'),
keyboardType: TextInputType.emailAddress,
validator: (value) {
if (value == null || value.isEmpty) return 'Required';
if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) return 'Invalid email';
return null;
},
),
TextFormField(
controller: _passwordController,
decoration: const InputDecoration(labelText: 'Password'),
obscureText: true,
validator: (value) {
if (value == null || value.isEmpty) return 'Required';
if (value.length < 6) return 'Password must be at least 6 characters';
return null;
},
),
const SizedBox(height: 16),
authProvider.isLoading
? const CircularProgressIndicator()
    : ElevatedButton(
onPressed: _submit,
child: Text(_isSignUp ? 'Sign Up' : 'Login'),
),
TextButton(
onPressed: () => setState(() => _isSignUp = !_isSignUp),
child: Text(_isSignUp ? 'Have an account? Login' : 'Need an account? Sign Up'),
),
],
),
),
),
);
}
}
