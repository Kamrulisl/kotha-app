import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'change_password_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _msgNotif = true;
  bool _groupNotif = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          "সেটিংস",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF00A884),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 8),

          // Account Section
          _buildSectionTitle("অ্যাকাউন্ট"),
          const SizedBox(height: 8),
          _buildSettingCard(
            icon: Icons.key_rounded,
            title: "পাসওয়ার্ড পরিবর্তন করুন",
            subtitle: "তোমার পাসওয়ার্ড আপডেট করো",
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ChangePasswordScreen()),
              );
            },
          ),
          const SizedBox(height: 8),
          _buildSettingCard(
            icon: Icons.privacy_tip_rounded,
            title: "প্রাইভেসি",
            subtitle: "প্রোফাইল ফটো, লাস্ট সিন, স্ট্যাটাস",
            onTap: () {
              // TODO: Implement privacy settings
            },
          ),
          const SizedBox(height: 8),
          _buildSettingCard(
            icon: Icons.security_rounded,
            title: "সিকিউরিটি",
            subtitle: "টু-ফ্যাক্টর অথেন্টিকেশন",
            onTap: () {
              // TODO: Implement security settings
            },
          ),

          const SizedBox(height: 24),

          // Notifications Section
          _buildSectionTitle("নোটিফিকেশন"),
          const SizedBox(height: 8),
          _buildSettingCard(
            icon: Icons.notifications_rounded,
            title: "মেসেজ নোটিফিকেশন",
            subtitle: "শব্দ, পপআপ",
            trailing: Switch(
              value: _msgNotif,
              onChanged: (value) {
                setState(() => _msgNotif = value);
                // TODO: persist setting
              },
              activeThumbColor: const Color(0xFF00A884),
            ),
          ),
          const SizedBox(height: 8),
          _buildSettingCard(
            icon: Icons.groups_rounded,
            title: "গ্রুপ নোটিফিকেশন",
            subtitle: "শব্দ, পপআপ",
            trailing: Switch(
              value: _groupNotif,
              onChanged: (value) {
                setState(() => _groupNotif = value);
                // TODO: persist setting
              },
              activeThumbColor: const Color(0xFF00A884),
            ),
          ),

          const SizedBox(height: 24),

          // App Settings Section
          _buildSectionTitle("অ্যাপ সেটিংস"),
          const SizedBox(height: 8),
          _buildSettingCard(
            icon: Icons.language_rounded,
            title: "ভাষা",
            subtitle: "বাংলা",
            onTap: () {
              // TODO: Implement language selection
            },
          ),
          const SizedBox(height: 8),
          _buildSettingCard(
            icon: Icons.wallpaper_rounded,
            title: "ওয়ালপেপার",
            subtitle: "চ্যাট ব্যাকগ্রাউন্ড পরিবর্তন করো",
            onTap: () {
              // TODO: Implement wallpaper selection
            },
          ),
          const SizedBox(height: 8),
          _buildSettingCard(
            icon: Icons.storage_rounded,
            title: "স্টোরেজ এবং ডেটা",
            subtitle: "নেটওয়ার্ক ব্যবহার, অটো-ডাউনলোড",
            onTap: () {
              // TODO: Implement storage settings
            },
          ),

          const SizedBox(height: 24),

          // Help Section
          _buildSectionTitle("হেল্প"),
          const SizedBox(height: 8),
          _buildSettingCard(
            icon: Icons.help_rounded,
            title: "সাহায্য",
            subtitle: "FAQ, যোগাযোগ করুন",
            onTap: () {
              // TODO: Implement help screen
            },
          ),
          const SizedBox(height: 8),
          _buildSettingCard(
            icon: Icons.info_rounded,
            title: "অ্যাপ সম্পর্কে",
            subtitle: "ভার্সন 1.0.0",
            onTap: () {
              _showAboutDialog(context);
            },
          ),

          const SizedBox(height: 32),

          // Logout Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton.icon(
              onPressed: () {
                _showLogoutDialog(context);
              },
              icon: const Icon(Icons.logout_rounded),
              label: const Text(
                "লগআউট",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade400,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Delete Account Button
          TextButton(
            onPressed: () {
              _showDeleteAccountDialog(context);
            },
            child: Text(
              "অ্যাকাউন্ট ডিলিট করুন",
              style: TextStyle(
                color: Colors.red.shade600,
                fontSize: 14,
                decoration: TextDecoration.underline,
              ),
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Color(0xFF00A884),
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSettingCard({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF00A884).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: const Color(0xFF00A884), size: 24),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            subtitle,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 13,
            ),
          ),
        ),
        trailing: trailing ??
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: Colors.grey.shade400,
            ),
        onTap: onTap,
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("লগআউট করবে?"),
        content: const Text("তুমি কি নিশ্চিত যে তুমি লগআউট করতে চাও?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("বাতিল"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              FirebaseAuth.instance.signOut();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade400,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text("লগআউট"),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("অ্যাকাউন্ট ডিলিট?"),
        content: const Text(
          "সতর্কতা! তোমার সব ডেটা পারমানেন্টলি ডিলিট হয়ে যাবে। এই অ্যাকশন আনডু করা যাবে না।",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("বাতিল"),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement account deletion
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("অ্যাকাউন্ট ডিলিট ফিচার শীঘ্রই আসছে"),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text("ডিলিট করুন"),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: "Kotha",
      applicationVersion: "1.0.0",
      applicationIcon: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF00A884).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.chat_bubble_rounded,
          color: Color(0xFF00A884),
          size: 32,
        ),
      ),
      children: const [
        Text("তোমার নিজের চ্যাট অ্যাপ"),
        SizedBox(height: 8),
        Text("Developed with ❤️ in Bangladesh"),
      ],
    );
  }
}