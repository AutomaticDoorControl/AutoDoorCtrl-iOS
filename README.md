[![Build Status](https://travis-ci.org/AutomaticDoorControl/AutoDoorCtrl-iOS.svg?branch=master)](https://travis-ci.org/AutomaticDoorControl/AutoDoorCtrl-iOS)

# AutomaticDoorControl - iOS
iOS Version of the AutomaticDoorControl Project.

## Travis CI
[Link to Travis CI](https://travis-ci.org/AutomaticDoorControl/AutoDoorCtrl-iOS)

## Manual Installation
* **In order to proceed you'll need access to a Mac.**
* Clone this repository: [https://github.com/AutomaticDoorControl/AutoDoorCtrl-iOS.git](https://github.com/AutomaticDoorControl/AutoDoorCtrl-iOS.git)
* Download and install `Xcode` and its latest CLI tools if you haven't.
* Open the **workspace** file in Xcode: `autodoorctrl.xcworkspace`
    * Do not work with the `autodoorctrl.xcodeproj` file.
    
## Running the :iphone: App
<p align = "center">
    <img width = "900" height = "23" src = "MiscellaneousFiles/RunningXcodeProject.png">
</p>

* Select a device to run on by clicking the Xcode icon to the right of `autodoorctrl`.
* Then click the run button - the first button on the left.
    * Xcode will then build the project and run it on the iOS simulator. However, the simulator does not support bluetooth.
* To use the bluetooth features required by the app, run the app on an actual iOS device.
    * To do so, create an Apple ID and set it up in Xcode by navigating to Xcode - Preferences - Accounts
    * Then set up code signing in autodoorctrl - general.
    * Use `Xcode Managed Profile` as the provisioning profile.
    * Now you can run the app on any of your iOS devices.


## Libraries Used
* `CoreBluetooth`
* `Alamofire`
* `SwiftMessages` 
* `Lottie` from the awesome folks at Airbnb
* `MapKit`
* `LocalAuthentication`
* `JLActivityIndicator`
* `SwiftJWT` (Swift Packages Dependency)
* `RxSwift` (Swift Packages Dependency)

## Bug Fix - module not found when using SPM and compiling unit tests
Add `-Xcc -fmodule-map-file=$(PROJECT_TEMP_ROOT)/GeneratedModuleMaps/iphonesimulator/<module name>.modulemap` to `OTHER SWIFT FLAGS` in the test target
[Stack Overflow Link](https://stackoverflow.com/questions/58125428/missing-required-module-xyz-on-unit-tests-when-using-swift-package-manager)

### Thanks for stopping by! :+1::+1:



