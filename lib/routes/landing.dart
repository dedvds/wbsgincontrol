import 'package:flutter/material.dart';

import 'auth.dart';

class Landing extends StatelessWidget {
  const Landing({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.headlineSmall?.copyWith(
          color: Colors.black,
        );

    final headlineStyle = Theme.of(context).textTheme.displaySmall?.copyWith(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        );

    const spacing = 10.0;

    return Scaffold(
      body: Stack(
        children: [
             Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  "Introducing",
                  style: textStyle,
                ),
              ),
              const SizedBox(height: spacing),
              Center(
                child: Text(
                  "WBSG in Control",
                  style: headlineStyle,
                ),
              ),
              const SizedBox(height: spacing),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: textStyle,
                  children: const [
                    TextSpan(text: 'A Simple App to keep track of todos, groceries and plans')
                  ],
                ),
              ),
              const SizedBox(height: spacing),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Auth()),
                  );
                },
                child: const Text('Get Started'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
