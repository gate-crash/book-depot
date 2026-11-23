import 'package:flutter/material.dart';


class FloatingActionButtonExampleApp extends StatelessWidget {
  const FloatingActionButtonExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: FloatingActionButtonExample());
  }
}

class FloatingActionButtonExample extends StatelessWidget {
  const FloatingActionButtonExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FloatingActionButton Sample')),
      body: Center(
        child: Column(
          mainAxisAlignment: .spaceEvenly,
          children: <Widget>[
           Row(
              mainAxisAlignment: .center,
              children: <Widget>[
                const Text('Large'),
                const SizedBox(width: 16),
                // An example of the large floating action button.
                //
                // https://m3.material.io/components/floating-action-button/specs#9d7d3d6a-bab7-47cb-be32-5596fbd660fe
                FloatingActionButton.large(
                  onPressed: () {
                    // Add your onPressed code here!
                  },
                  child: const Icon(Icons.add),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: .center,
              children: <Widget>[
                const Text('Extended'),
                const SizedBox(width: 16),
                // An example of the extended floating action button.
                //
                // https://m3.material.io/components/extended-fab/specs#686cb8af-87c9-48e8-a3e1-db9da6f6c69b
                FloatingActionButton.extended(
                  onPressed: () {
                    // Add your onPressed code here!
                  },
                  label: const Text('Add'),
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}