import 'dart:math';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _haspermissiongraded = false;
  double diraction = 0.0; // initialize dirat to a default value

  @override
  void initState() {
    _fechthepermission();

    super.initState();
  }

  void _fechthepermission() {
    Permission.locationWhenInUse.status.then((status) => {
          if (mounted)
            {_haspermissiongraded = (status == PermissionStatus.granted)}
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 118, 83, 71),
      body: Builder(
        builder: (context) {
          if (_haspermissiongraded) {
            return _buildCompass();
          } else {
            return handlePermission();
          }
        },
      ),
    );
  }

  Widget _buildCompass() {
    return StreamBuilder<CompassEvent>(
      stream: FlutterCompass.events,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("error${snapshot.error}");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        double? diracion = snapshot.data!.heading;
        if (diracion == null) {
          return const Center(
            child: Text('Compass direction not available'),
          );
        } else {
          diraction = diracion;
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text(
                  'C  O M  P  A  S  S',
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.w700),
                ),
                compess(context),
              ],
            ),
          );
        }
      },
    );
  }

  Neumorphic compess(BuildContext context) {
    return Neumorphic(
      style: NeumorphicStyle(
        shape: NeumorphicShape.convex,
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(180)),
        color: const Color.fromARGB(255, 118, 83, 71),
      ),
      child: Transform.rotate(
        angle: diraction * (pi / 180 * -1),
        child: Container(
          padding: const EdgeInsets.all(15),
          width: MediaQuery.of(context).size.width * 0.85,
          decoration: const BoxDecoration(shape: BoxShape.circle),
          child: Image.asset(
            'images/comp.png',
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget handlePermission() {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            LottieBuilder.asset('images/location.json'),
            NeumorphicButton(
                style: NeumorphicStyle(
                    boxShape:
                        NeumorphicBoxShape.roundRect(BorderRadius.circular(15)),
                    shape: NeumorphicShape.convex,
                    color: const Color.fromARGB(255, 138, 109, 100)
                        .withAlpha(210)),
                child: const Text(
                  'Allow permission',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                onPressed: () {
                  Permission.locationWhenInUse.request().then(
                    (value) {
                      _fechthepermission();
                    },
                  );
                  setState(
                    () {
                      _haspermissiongraded = true;
                    },
                  );
                }),
          ],
        ),
      ),
    );
  }
}
