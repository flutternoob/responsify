import "dart:io";
import "dart:math";

import "package:flutter/material.dart";
import "package:responsify/responsify_files/responsify_enum.dart";

///This function is used to determine the device type, using the device's width and height in logical
///pixels, its pixel ratio, PPI and OS Platform
DeviceTypeInformation determineDeviceType(MediaQueryData? mediaQueryData,
    [bool? targetOlderComputers]) {
  ///Variable for device type based on the DeviceTypeInformation enum
  DeviceTypeInformation? deviceType;

  ///Device width in logical pixels
  num deviceLogicalWidth = mediaQueryData!.size.width;

  ///Device height in logical pixels
  num deviceLogicalHeight = mediaQueryData.size.height;

  ///Device pixel ratio
  num devicePixelRatio = mediaQueryData.devicePixelRatio;

  ///Diagonal length of the device in pixels calculated using Pythogoras theorem
  num? diagonalPixels;

  ///Variable used to determine device pixel density using its pixel ratio
  num? devicePixelDensity;

  ///Variable used to return the device type depending on the results of the calculation
  num? deviceSize;

  ///Function used to calculate the device size
  num calculateDeviceSize() {
    ///Online research showed that a device pixel ratio of 1 = 160 pixel density. This was used as a
    ///reference point for determining the device type. Older devices had a pixel density lower
    ///than 160 (such as 120 or 96). The following if...else block takes this into account and runs some
    ///simple calculations to return the the device size
    ///if block if device pixel ratio is > or < 1
    if (devicePixelRatio > 1 || devicePixelRatio < 1) {
      ///Device pixel resolution in width calculated by multiplying the logical pixels by the device
      ///pixel ratio
      num resolutionWidth = deviceLogicalWidth * devicePixelRatio;

      ///Device pixel resolution in height calculated by multiplying the logical pixels by the device
      ///pixel ratio
      num resolutionHeight = deviceLogicalHeight * devicePixelRatio;

      ///Calculate the diagonal pixels in accordance with Pythogoras theorem, which states that
      ///diagonal = SquareRoot((SideA^2) + (SideB^2)). Here, Side A is the width and Side B is the
      ///height. This theorem is used to determine the diagonal side of the device, as the diagonal
      ///size is the most frequent specification used by manufacturers for their devices. It can
      ///also be used in a more generic fashion to determine the device size. There is also more variety
      ///in resolution and pixel ratio across devices. Taking either of these values into account while
      ///ignoring the other is not an accurate way of determining the device size and hence the device type
      diagonalPixels = sqrt(pow(resolutionWidth, 2) + pow(resolutionHeight, 2));

      ///Calculate device pixel density = device pixel ratio * 160
      devicePixelDensity = devicePixelRatio * 160;
    }

    ///else block if device pixel ratio = 1
    else {
      ///No need to determine resolution as in the above if block when device pixel ratio = 1
      ///Device pixel ratio = 1 if device dots per inch (DPI) = 160 (baseline)
      diagonalPixels = sqrt(pow(deviceLogicalWidth, 2) + pow(deviceLogicalHeight, 2));
      devicePixelDensity = 160;
    }

    ///The formula for determining the device diagonal size in inches is the diagonal pixels/device
    ///pixel density
    return deviceSize = diagonalPixels! / devicePixelDensity!;
  }

  ///Function used to determine the device type based on the above calculations
  DeviceTypeInformation determineDeviceType() {
    ///Perform the calculations
    calculateDeviceSize();

    ///The checkHandheldDevicePlatform flag is used to determine a Handheld
    ///device's OS Platform
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

      ///The baseline pixel density of 160 cannot be applied to devices whose pixel densities < 160
      ///(such as 72dpi or 96dpi).
      ///Therefore, for older computers, the above Pythogorean calculation is not taken into account
      ///as this causes a device type of UNKNOWN to be returned.
      ///Hence, DeviceTypeInformation.COMPUTER is returned based on the Platform enum and the
      ///targetOlderComputers flag for older computers.
      ///For newer computers, the Pythogorean calculation is taken into account
    } else if ((deviceSize! > 13.5 && deviceSize! < 55 && checkComputerPlatform) ||
        (targetOlderComputers! && checkComputerPlatform)) {
      return deviceType = DeviceTypeInformation.COMPUTER;
    } else {
      return deviceType = DeviceTypeInformation.UNKNOWN;
    }
  }

  ///Call the function to determine the device type
  determineDeviceType();

  ///Return the device type back to the DeviceInfoWidget
  return deviceType!;
}