import 'package:flutter/material.dart';
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool salesNotification = true;
  bool newArrivalsNotification = false;
  bool deliveryStatusNotification = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {},
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Settings',
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          _buildSection(
            'Personal Information',
            children: [
              _buildTextField('Full name'),
              const SizedBox(height: 16),
              _buildTextField(
                'Date of Birth',
                initialValue: '12/12/1989',
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildPasswordSection(),
          const SizedBox(height: 24),
          _buildNotificationsSection(),
        ],
      ),
    );
  }

  Widget _buildSection(String title, {required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }

  Widget _buildTextField(String label, {String? initialValue}) {
    return TextField(
      controller: initialValue != null
          ? TextEditingController(text: initialValue)
          : null,
      decoration: InputDecoration(
        labelText: label,
        // Bỏ viền mặc định
        border: InputBorder.none,
        // Chỉ hiện viền khi focus
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        // Background màu xám nhạt
        fillColor: Colors.grey[100],
        filled: true,
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  Widget _buildPasswordSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Password',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '••••••••••••••',
                style: TextStyle(
                  fontSize: 16,
                  letterSpacing: 1,
                ),
              ),
              TextButton(
                onPressed: () => _showPasswordChangeSheet(context),
                child: const Text(
                  'Change',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }


  Widget _buildNotificationsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Notifications',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 16),
        _buildSwitchTile('Sales', salesNotification, (value) {
          setState(() => salesNotification = value);
        }),
        _buildSwitchTile('New arrivals', newArrivalsNotification, (value) {
          setState(() => newArrivalsNotification = value);
        }),
        _buildSwitchTile('Delivery status changes', deliveryStatusNotification,
                (value) {
              setState(() => deliveryStatusNotification = value);
            }),
      ],
    );
  }

  Widget _buildSwitchTile(
      String title, bool value, void Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.green,
          ),
        ],
      ),
    );
  }

  void _showPasswordChangeSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const PasswordChangeSheet(),
    );
  }
}

class PasswordChangeSheet extends StatelessWidget {
  const PasswordChangeSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Container(
        height: MediaQuery.of(context).size.height/2,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Password Change',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            TextField(
              decoration: InputDecoration(
                labelText: 'Old Password',
                border: InputBorder.none,
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                fillColor: Colors.grey[100],
                filled: true,
                suffixIcon: TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: 'New Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Repeat New Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: const Text('SAVE PASSWORD'),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
