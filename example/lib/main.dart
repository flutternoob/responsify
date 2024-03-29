import 'package:flutter/material.dart';
import 'package:responsify/responsify.dart';

void main() {
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Responsive UI Demo",
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue[900],
            title: Text("Responsive UI Demo"),
          ),
          body: DeviceInformation(),
        ),
      ),
    );
  }
}

///Different UI for different devices. Here the string in the Text widget and the font size
///is different for Wearables and other devices
///Different app layouts can be implemented based on device type
class DeviceInformation extends StatelessWidget {
  DeviceInformation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ResponsiveUiWidget(
        targetOlderComputers: true,
        builder: (context, deviceInformation) {
          @override
          String toString() {
            return "Device Type: ${deviceInformation.deviceTypeInformation}\n"
                "Device OS: ${deviceInformation.deviceOS}\n"
                "Device Orientation: ${deviceInformation.orientation}\n"
                "Platform Brightness: ${deviceInformation.platformBrightness}\n"
                "Parent Widget Size: ${deviceInformation.parentWidgetSize}\n"
                "Local Widget Size (W x H): ${deviceInformation.localWidgetWidth} x ${deviceInformation.localWidgetHeight}";
          }

          return Text(
            toString(),
            style: TextStyle(fontSize: deviceInformation.deviceTypeInformation == DeviceTypeInformation.WEARABLE ? 8 : 16),
          );
        },
      ),
    );
  }
}
