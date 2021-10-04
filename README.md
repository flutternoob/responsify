# responsify

A new Flutter package for creating Responsive UI based on device type

## Overview of this library

* The ```responsify``` package is a pure Dart package based on [this](https://medium.com/flutter-community/the-best-flutter-responsive-ui-pattern-ba52875d70cd) tutorial by FilledStacks.
* With this library, you can:<BR>
  * Get the device type (Mobile, Tablet, Computer or Wearable) and create different layouts depending on device type<BR>
  * Get the device's orientation<BR>
  * Get the device's platform brightness, i.e., light mode or dark mode<BR>
  * Get the parent widget's size (Width X Height)<BR>
  * Get the child widget's size (Width X Height)<BR>
  
## How this library works

* The library has a single widget, known as the ```ResponsiveUiWidget``` that returns a widget in its ```build``` method<BR>
* The library takes the device's pixel density into account. It is determined using the device's pixel ratio and a baseline pixel density
  of 160. Older computers have a lower pixel density (such as 96 or 120 ppi). In this case, the pixel density is not
  considered when determining if the device is a computer<BR>
* The ```ResponsiveUiWidget``` has a required parameter called ```targetOlderComputers```. If true, this flag allows you to 
  target older computer models that have pixel density of lower than 160. Also, when true, only this flag and the computer's 
  Platform OS (Windows, macOS, Linux) is used to determine if the device is a computer. If false, the device type is determined to be a computer
  using the Pythogoras theorem (see the next point) along with the Platform OS<BR>
* The Pythogoras theorem is used to calculated the diagonal dimensions of the device screen in pixels. This resulting value is then
  used with the device pixel density to determine the diagonal screen size in inches. Device Screen Size (inches) = Device Screen Size (pixels)/Device pixel density (PPI).
  This result, along with the device's Platform OS, is used to determine the device type (Mobile, Tablet, Wearable, Computer)
* If the above three points sound confusing, here is the code block:<BR>
```
    ///The checkHandheldDevicePlatform flag is used to determine a Handheld device's OS Platform
    bool checkHandheldDevicePlatform = Platform.isAndroid || Platform.isIOS || Platform.isFuchsia;

    ///The checkComputerPlatform flag is used to determine a Computer device's OS Platform
    ///Here a Computer may be any Desktop or Laptop/Notebook device that runs either Windows,
    ///macOS or Linux
    bool checkComputerPlatform = Platform.isWindows || Platform.isMacOS || Platform.isLinux;

    ///if...else block used to determine the device type based on the DeviceType enum and the
    ///DeviceInformation class. All threshold values are in inches
    if (deviceSize! <= 3) {
      return deviceType = DeviceTypeInformation.WEARABLE;
    } else if (deviceSize! > 3 && deviceSize! < 7.1 && checkHandheldDevicePlatform) {
      return deviceType = DeviceTypeInformation.MOBILE;
    } else if (deviceSize! > 7.1 && deviceSize! < 13.5 && checkHandheldDevicePlatform) {
      return deviceType = DeviceTypeInformation.TABLET;
    } else if ((deviceSize! > 13.5 && deviceSize! < 55 && checkComputerPlatform) ||
        (targetOlderComputers! && checkComputerPlatform)) {
      return deviceType = DeviceTypeInformation.COMPUTER;
    } else {
      return deviceType = DeviceTypeInformation.UNKNOWN;
    }
```
* Device pixel density = Device pixel ratio * 160. The Device Pixel Ratio is retrieved using MediaQuery<BR>
* The thresholds for device screen sizes were determined by performing a search for minimum and maximum screen sizes for each device type. 
  As such, you do not have to specify thresholds for device sizes<BR>

## Usage

1) Add ```responsify``` to your ```pubspec.yaml``` and run ```pub get```<BR>
2) Import ```responsify.dart``` into your project, like so:<BR>
   ```import 'package:responsify/responsify.dart';'```<BR>
3) Use it. As an example, like so:<BR><BR>

```
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
```

4) Another example, using ```MaterialPageRoute``` and ```PageRouteBuilder```: <BR><BR>

```
class ResponsifyApp extends StatelessWidget {
  ResponsifyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        MaterialButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ResponsiveUiWidget(
                    targetOlderComputers: false,
                    builder: (context, deviceInformation) {
                      if (deviceInformation.deviceTypeInformation == DeviceTypeInformation.MOBILE) {
                        return MobileVersion();
                      } else {
                        return Scaffold(
                          body: Center(
                            child: Text("This app is compatible only with a Mobile device"),
                          ),
                        );
                      }
                    }),
              ),
            );
          },
          textColor: Colors.white,
          child: Text("Mobile"),
          color: Colors.black,
        ),
        MaterialButton(
          onPressed: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => ResponsiveUiWidget(
                  targetOlderComputers: false,
                  builder: (context, deviceInformation) {
                    if (deviceInformation.deviceTypeInformation == DeviceTypeInformation.TABLET) {
                      return TabletVersion();
                    } else {
                      return Scaffold(
                        body: Center(
                          child: Text("This app is compatible only with a Tablet device"),
                        ),
                      );
                    }
                  },
                ),
              ),
            );
          },
          textColor: Colors.white,
          child: Text("Tablet"),
          color: Colors.black,
        )
      ]),
    );
  }
}

class MobileVersion extends StatelessWidget {
  const MobileVersion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("This is a Mobile Device")),
    );
  }
}

class TabletVersion extends StatelessWidget {
  const TabletVersion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("This is a Tablet Device")),
    );
  }
}
```

## Screenshots

<img src = "https://raw.githubusercontent.com/flutternoob/responsify/master/screenshots/Responsify_mobile_portrait.png"><BR><BR>
<img src = "https://raw.githubusercontent.com/flutternoob/responsify/master/screenshots/Responsify_mobile_landscape.png"><BR><BR>
<img src = "https://raw.githubusercontent.com/flutternoob/responsify/master/screenshots/Responsify_tablet_portrait.png"><BR><BR>
<img src = "https://raw.githubusercontent.com/flutternoob/responsify/master/screenshots/Responsify_tablet_landscape.png"><BR><BR>
<img src = "https://raw.githubusercontent.com/flutternoob/responsify/master/screenshots/Responsify_wearable.png"><BR><BR>
<img src = "https://raw.githubusercontent.com/flutternoob/responsify/master/screenshots/Responsify_computer.png"><BR>

## Note

* The benchmarks for determining thresholds for device screen sizes were determined by<BR>
  performing a Google search for minimum and maximum screen sizes for each device type<BR>
* This library has not been tested on foldable devices such as some Microsoft Surface devices, foldable phones and foldable tablets 
  via an emulator or a physical device<BR>
* I currently have no way to test this library on Apple and Linux devices<BR>

## Known Issues

* For a Windows computer that has dark mode enabled, the Platform brightness is identified as light mode. I do not know why.<BR>

## References

1) [https://material.io/blog/device-metrics](https://material.io/blog/device-metrics)
2) [https://developer.android.com/training/multiscreen/screendensities](https://developer.android.com/training/multiscreen/screendensities)
3) [https://www.calculatorsoup.com/calculators/technology/ppi-calculator.php](https://www.calculatorsoup.com/calculators/technology/ppi-calculator.php)
4) [https://groups.google.com/g/flutter-dev/c/oYN_prI7sio](https://groups.google.com/g/flutter-dev/c/oYN_prI7sio)
5) [https://medium.com/flutter-community/the-best-flutter-responsive-ui-pattern-ba52875d70cd](https://medium.com/flutter-community/the-best-flutter-responsive-ui-pattern-ba52875d70cd)
6) [https://stackoverflow.com/questions/49307677/how-to-get-height-of-a-widget](https://stackoverflow.com/questions/49307677/how-to-get-height-of-a-widget)
7) [https://github.com/flutter/flutter/issues/14488](https://github.com/flutter/flutter/issues/14488)

## Conclusion

I hope this library is useful for those who want an easy way to create different layouts based on device type. PRs are welcome.
