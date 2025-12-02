import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentCtrl = TextEditingController();
  final _newCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _loading = false;
  bool _hideCurrent = true;
  bool _hideNew = true;

  @override
  void dispose() {
    _currentCtrl.dispose();
    _newCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  void _showSnack(String msg, {bool success = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: success ? Colors.green : Colors.red),
    );
  }

  Future<void> _sendResetEmail() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user?.email == null) {
      _showSnack('No email available for this account.');
      return;
    }
    setState(() => _loading = true);
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: user!.email!);
      _showSnack('Password reset email sent to ${user.email}', success: true);
    } catch (e) {
      _showSnack('Failed to send reset email: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _linkEmailPassword() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user?.email == null) {
      _showSnack('No email available for this account.');
      return;
    }
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    try {
      final credential = EmailAuthProvider.credential(
        email: user!.email!,
        password: _newCtrl.text.trim(),
      );
      // link credential to existing account
      await user.linkWithCredential(credential);
      _showSnack('Password set — you can now sign in with email/password', success: true);
      if (mounted) Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'provider-already-linked') {
        _showSnack('Email/password provider already linked.');
      } else if (e.code == 'email-already-in-use') {
        _showSnack('Email already in use by another account.');
      } else {
        _showSnack(e.message ?? e.code);
      }
    } catch (e) {
      _showSnack('Failed to link password: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _changePasswordForEmailUser() async {
    if (!_formKey.currentState!.validate()) return;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || user.email == null) {
      _showSnack('No authenticated user.');
      return;
    }

    setState(() => _loading = true);
    try {
      final cred = EmailAuthProvider.credential(
        email: user.email!,
        password: _currentCtrl.text.trim(),
      );
      await user.reauthenticateWithCredential(cred);
      await user.updatePassword(_newCtrl.text.trim());
      _showSnack('Password updated', success: true);
      if (mounted) Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      _showSnack(e.message ?? e.code);
    } catch (e) {
      _showSnack('Unexpected error: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  bool get _isEmailPasswordUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;
    return user.providerData.any((p) => p.providerId == 'password');
  }

  bool get _isGoogleUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;
    return user.providerData.any((p) => p.providerId == 'google.com');
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(title: const Text('Change Password')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _isEmailPasswordUser
                ? Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _currentCtrl,
                          obscureText: _hideCurrent,
                          decoration: InputDecoration(
                            labelText: 'Current password',
                            suffixIcon: IconButton(
                              icon: Icon(_hideCurrent ? Icons.visibility_off : Icons.visibility),
                              onPressed: () => setState(() => _hideCurrent = !_hideCurrent),
                            ),
                          ),
                          validator: (v) => (v == null || v.isEmpty) ? 'Enter current password' : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _newCtrl,
                          obscureText: _hideNew,
                          decoration: InputDecoration(
                            labelText: 'New password',
                            hintText: '6+ characters',
                            suffixIcon: IconButton(
                              icon: Icon(_hideNew ? Icons.visibility_off : Icons.visibility),
                              onPressed: () => setState(() => _hideNew = !_hideNew),
                            ),
                          ),
                          validator: (v) => (v == null || v.length < 6) ? 'Password too short' : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _confirmCtrl,
                          obscureText: _hideNew,
                          decoration: const InputDecoration(labelText: 'Confirm new password'),
                          validator: (v) => v != _newCtrl.text ? 'Passwords do not match' : null,
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _changePasswordForEmailUser,
                            child: const Text('Change password'),
                          ),
                        ),
                      ],
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (_isGoogleUser)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Text(
                            'Signed in with Google. No current password exists.',
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                        ),
                      ElevatedButton(
                        onPressed: _sendResetEmail,
                        child: const Text('Send password reset email'),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Or set a local password (this will allow email/password sign-in).',
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                      const SizedBox(height: 12),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _newCtrl,
                              obscureText: _hideNew,
                              decoration: InputDecoration(
                                labelText: 'New password',
                                suffixIcon: IconButton(
                                  icon: Icon(_hideNew ? Icons.visibility_off : Icons.visibility),
                                  onPressed: () => setState(() => _hideNew = !_hideNew),
                                ),
                              ),
                              validator: (v) => (v == null || v.length < 6) ? 'Password too short' : null,
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _confirmCtrl,
                              obscureText: _hideNew,
                              decoration: const InputDecoration(labelText: 'Confirm new password'),
                              validator: (v) => v != _newCtrl.text ? 'Passwords do not match' : null,
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _linkEmailPassword,
                                child: const Text('Set local password (link)'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}