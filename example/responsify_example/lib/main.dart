import "package:flutter/material.dart";
import "package:responsify/responsify.dart";

void main() {
  runApp(MyApp());
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
              title: Text("Responsive UI Demo")
          ),
          body: DeviceInformation(),
        ),
      ),
    );
  }
}

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
                    "Device Orientation: ${deviceInformation.orientation}\n"
                    "Platform Brightness: ${deviceInformation.platformBrightness}\n"
                    "Parent Widget Size: ${deviceInformation.parentWidgetSize}\n"
                    "Local Widget Size (W x H): ${deviceInformation.localWidgetWidth} x ${deviceInformation.localWidgetHeight}";
              }
              //String deviceInfo = toString();
              ///Different UI for different devices. Here the string in the Text widget and the font size
              ///is different for Wearables and other devices
              ///Different app layouts can be implemented based on device type
              if (deviceInformation.deviceTypeInformation == DeviceTypeInformation.WEARABLE){
                return Text(
                  "Device Type: ${deviceInformation.deviceTypeInformation}\n"
                      "Platform Brightness: ${deviceInformation.platformBrightness}\n"
                      "Parent Widget Size: ${deviceInformation.parentWidgetSize}\n"
                      "Local Widget Size (W x H): ${deviceInformation.localWidgetWidth} x ${deviceInformation.localWidgetHeight}",
                  style: const TextStyle(fontSize: 8),
                );
              } else {
                return Text(
                  toString(),
                  style: const TextStyle(fontSize: 16),
                );
              }
            }
        )
    );
  }
}