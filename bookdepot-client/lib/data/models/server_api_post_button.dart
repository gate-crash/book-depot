import 'package:flutter/material.dart';
import 'package:bookdepot_client/data/models/server_api_model.dart';

class ApiPostIconButton extends StatelessWidget {
  final String endpoint;
  final Map<String, dynamic> Function() getPayload;
  final String Function(Map<String, dynamic> payload)? getSuccessMessage;
  final IconData icon;

  const ApiPostIconButton({
    super.key,
    required this.endpoint,
    required this.getPayload,
    this.getSuccessMessage,
    this.icon = Icons.add,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton.filled(
      icon: Icon(icon),
      onPressed: () async {
        final payload = getPayload();
        final api = ServerApiPost();
        await api(endpoint, payload);

        if (context.mounted) {
          if (getSuccessMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(getSuccessMessage!(payload))),
            );
          }
        }
      },
    );
  }
}