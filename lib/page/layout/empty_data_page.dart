import 'package:flutter/material.dart';

class EmptyData extends StatelessWidget {
  const EmptyData({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                height: 300,
                child: Image.asset("assets/background/4954310.png")),
            // Lottie.asset("assets/background/empty_bg.json"),
            // const Text(
            //   "Data Empty",
            //   style: TextStyle(
            //     fontWeight: FontWeight.bold,
            //     fontSize: 30,
            //   ),
            // ),
            Text(
              'Opps...,\nYour data is empty, try to add data',
              style: Theme.of(context).textTheme.titleSmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class SmallEmpty extends StatelessWidget {
  const SmallEmpty({super.key});

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SizedBox(
        height: 270,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                height: 150,
                child: Image.asset("assets/background/4954310.png")),
            // Lottie.asset("assets/background/empty_bg.json"),
            // const Text(
            //   "Data Empty",
            //   style: TextStyle(
            //     fontWeight: FontWeight.bold,
            //     fontSize: 30,
            //   ),
            // ),
            Text(
              'Opps...,\nYour data is empty, try to add data',
              style: Theme.of(context).textTheme.titleSmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}