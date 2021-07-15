import "package:flutter/material.dart";
import "package:responsify/responsify_files/responsify_enum.dart";

///The DeviceInformationModel is used to retrieve basic information about the device, some of which
///are available via the Flutter SDK.
class DeviceInformation {
  ///Used to determine whether the device is in Portrait or in Landscape Mode
  final Orientation? orientation;

  ///Used to determine the device type in accordance with the DeviceTypeInformation enum
  final DeviceTypeInformation? deviceTypeInformation;

  ///Used to determine the device's brightness.
  ///On Windows devices with dark mode, the Platform Brightness is incorrectly indicated as
  ///Brightness.light even with dark mode enabled on the device
  final Brightness? platformBrightness;

  ///Used to determine the size of a given widget's parent widget.
  final Size? parentWidgetSize;

  ///Used to determined the size of a widget
  final double? localWidgetWidth;
  final double? localWidgetHeight;

  ///Constructor for this class
  DeviceInformation(
      {this.orientation,
        this.deviceTypeInformation,
        this.platformBrightness,
        this.parentWidgetSize,
        this.localWidgetWidth,
        this.localWidgetHeight,
      });
}