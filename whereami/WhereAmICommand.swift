//
//  WhereAmICommand.swift
//  whereami
//
//  Created by Victor Jalencas on 14/12/14.
//  Copyright (c) 2014 Hand Forged. All rights reserved.
//

import Foundation

import CoreLocation

let MaxLocationFixStaleness = 10.0

enum OutputFormat {
    case Json
    case Bare
    case Sexagesimal
}

class WhereAmICommand: Command, CLLocationManagerDelegate {
    var locationObtained = false
    var errorOccurred = false
    var location = CLLocationCoordinate2DMake(0, 0)
    var errorMessage = ""

    var format = OutputFormat.Bare


    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {

        // the last one will be the most recent
        let updatedLocation = locations.last as CLLocation;

        // Check is not older than 10 seconds, otherwise discard it
        if (updatedLocation.timestamp.timeIntervalSinceNow < MaxLocationFixStaleness) {
            location = updatedLocation.coordinate;
            locationObtained = true;
            CFRunLoopStop(CFRunLoopGetCurrent());
        }

    }

    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println(error.localizedDescription);
        errorOccurred = true;
        CFRunLoopStop(CFRunLoopGetCurrent());
    }

    func display(CLLocationCoordinate2D) -> () {
        var outputString: String
        switch (self.format) {
        case .Json:
            outputString = "{\"latitude\":\(location.latitude), \"longitude\": \(location.longitude)}"
        case .Sexagesimal:
            outputString = "\(stringFromDegrees(location.latitude)), \(stringFromDegrees(location.longitude))"
        case .Bare:
            outputString = "\(location.latitude),\(location.longitude)"
        }
        println(outputString);

    }

    func showError(String) -> () {
        let stderr = NSFileHandle.fileHandleWithStandardError();

        stderr.writeData(errorMessage.dataUsingEncoding(NSUTF8StringEncoding)!);
    }

    // MARK: - Aux function

    func stringFromDegrees(degrees: Double) -> String {

        var deg: Double
        var min: Double
        var sec: Double

        (deg, min) = modf(degrees)
        min = min * 60
        (min, sec) = modf(min)
        sec = sec * 60

        return "\(Int(deg))° \(Int(min))′ \(sec)″"

    }
    // MARK: - Overrides

    override func commandName() -> String {
        return ""
    }

    override func execute() -> CommandResult {
        switch CLLocationManager.authorizationStatus() {
        case .Restricted:
            errorMessage = "You don't have permission to use Location Services.";
            errorOccurred = true;
        case .Denied:
            errorMessage = "You denied permission to use Location Services, please enable it in Preferences.";
            errorOccurred = true;
        default:
            if (!CLLocationManager.locationServicesEnabled()) {
                errorMessage = "Location Services are not enabled for this computer, please enable them in Preferences.";
                errorOccurred = true;
            }
        }

        if (!errorOccurred) {

            let manager = CLLocationManager();
            manager.delegate = self;
            manager.startUpdatingLocation();

            CFRunLoopRun()
        }

        if (errorOccurred) {
            showError(errorMessage);
            return .Failure(errorMessage);
        } else {
            display(location);
        }

        return .Success;
    }

    override func handleOptions() {
        self.onKey("--format", block: {key, value in
            switch (value) {
            case "json":
                self.format = .Json
            case "sexagesimal":
                self.format = .Sexagesimal
            default:
                self.format = .Bare
            }
            }, usage:"output format (bare (default), json, sexagesimal)", valueSignature: "formatName")
    }
}