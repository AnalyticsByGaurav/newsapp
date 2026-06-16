import 'package:flutter/material.dart';
import '../../widgets/empty_widget.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('सूचनाएं'),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('सब पढ़ा'),
          ),
        ],
      ),
      body: const AppEmptyWidget(
        message: 'कोई सूचना नहीं है।\nपुश नोटिफिकेशन यहाँ दिखेंगी।',
        icon: Icons.notifications_none_outlined,
      ),
    );
  }
}
