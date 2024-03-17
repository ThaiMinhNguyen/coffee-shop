import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingWait extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.brown.shade100,
      child: SpinKitChasingDots(
        color: Colors.brown,

      ),
    );
  }
}
