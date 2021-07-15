///The responsive UI Widget aids in creating responsive UIs across devices

import "package:flutter/material.dart";

import "package:responsify/responsify_files/responsify_model.dart";
import "package:responsify/responsify_files/responsify_function.dart";

///The ResponsiveUiWidget is used as a wrapper for any widget to which responsive design has to be applied
class ResponsiveUiWidget extends StatefulWidget {
  ///The builder Widget function is needed to get a widget's context and the device information
  ///based on the DeviceInformation class
  final Widget Function(BuildContext context, DeviceInformation deviceInformation)? builder;

  ///Used to target older or newer computers. If targeting older computers the value should be true
  ///If targeting newer computers, the value should be false
  final bool? targetOlderComputers;

  ///Constructor for this widget
  const ResponsiveUiWidget({Key? key, this.builder, required this.targetOlderComputers}) : super(key: key);

  @override
  _ResponsiveUiWidgetState createState() => _ResponsiveUiWidgetState();
}

class _ResponsiveUiWidgetState extends State<ResponsiveUiWidget> {

  ///Used for local widget width and height
  double? localWidgetWidth;
  double? localWidgetHeight;

  ///Creating a GlobalKey to get the widget's current context
  final GlobalKey responsiveKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    ///Listen to the responsiveKey. Based on its context, get the width and height of the widget
    WidgetsBinding.instance!.addPostFrameCallback(
            (_) => setState(() => localWidgetWidth = responsiveKey.currentContext!.size!.width));
    WidgetsBinding.instance!.addPostFrameCallback(
            (_) => setState(() => localWidgetHeight = responsiveKey.currentContext!.size!.height));
  }

  @override
  Widget build(BuildContext context) {
    ///Creating a variable for getting information about the device to pass to the getDeviceType
    ///function. MediaQueryData works in a similar fashion to the media query property in CSS
    MediaQueryData mediaQueryData = MediaQuery.of(context);

    ///The LayoutBuilder widget is necessary for getting the width and height of the parent widget
    ///using the boxConstraints enum from the Size parameter
    return LayoutBuilder(
        key: responsiveKey,
        builder: (context, boxConstraints) {

          ///Passing information about the device to the DeviceInformation class constructor
          DeviceInformation deviceInformation = DeviceInformation(
              orientation: mediaQueryData.orientation,

              ///Passing the mediaQueryData parameter to the getDeviceType function to determine
              ///the device type
              deviceTypeInformation: determineDeviceType(mediaQueryData, widget.targetOlderComputers),
              platformBrightness: mediaQueryData.platformBrightness,
              parentWidgetSize: Size(boxConstraints.maxWidth, boxConstraints.maxHeight),
              localWidgetWidth: localWidgetWidth,
              localWidgetHeight: localWidgetHeight,
          );

          ///Return the sizingInformation along with the widget's context
          return widget.builder!(context, deviceInformation);
        });
  }
}
