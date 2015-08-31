//
//  WhereAmICommand.swift
//  whereami
//
//  Created by Victor Jalencas on 14/12/14.
//  © 2014-2015 Hand Forged. All rights reserved.
//

import Foundation

import CoreLocation


let MaxLocationFixStaleness = 10.0

enum OutputFormat {
    case Json
    case Bare
    case Sexagesimal
}

enum WhereAmIError: ErrorType {
    case RestrictedPermission
    case DeniedPermission
    case LocationServicesDisabled
    case InvalidLocationFix
//    case LocationUnknown
}

public class WhereAmICommand: NSObject, OptionCommandType, CLLocationManagerDelegate {
    var locationObtained = false
    //    var errorOccurred = false
    var location : CLLocationCoordinate2D?
    //    var errorMessage = ""
    var locationError: ErrorType?

    var format = OutputFormat.Bare



    func display(location: CLLocationCoordinate2D) -> () {
        var outputString: String
        switch (self.format) {
        case .Json:
            outputString = "{\"latitude\":\(location.latitude), \"longitude\": \(location.longitude)}"
        case .Sexagesimal:
            outputString = "\(stringFromDegrees(location.latitude)), \(stringFromDegrees(location.longitude))"
        case .Bare:
            outputString = "\(location.latitude),\(location.longitude)"
        }
        print(outputString);

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
    // MARK: - OptionCommandType

    public var commandName: String {
        return ""
    }

    public var commandSignature: String {
        return ""
    }

    public var commandShortDescription: String {
        return "Returns your location"
    }

    public func execute(arguments arguments: CommandArguments) throws  {
        do {
            switch CLLocationManager.authorizationStatus() {
            case .Restricted:
                throw WhereAmIError.RestrictedPermission
            case .Denied:
                throw WhereAmIError.DeniedPermission
            default:
                guard CLLocationManager.locationServicesEnabled() else {
                    throw WhereAmIError.LocationServicesDisabled
                }
            }

            var status: CFRunLoopRunResult = .Finished


            let manager = CLLocationManager();
            manager.delegate = self;
            manager.startUpdatingLocation(); // TODO: Use requestLocation() in 10.11

            status = CFRunLoopRunInMode(kCFRunLoopDefaultMode, 15, false)


            guard status != .TimedOut else {
                throw WhereAmIError.InvalidLocationFix
            }

            guard let foundLocation = location else {
                throw self.locationError!
            }
            display(foundLocation)
        } catch let error as WhereAmIError {
            let errorMessage: String
            switch (error) {
            case .RestrictedPermission:
                errorMessage = "You don't have permission to use Location Services."
            case .DeniedPermission:
                errorMessage = "You denied permission to use Location Services, please enable it in Preferences."
            case .LocationServicesDisabled:
                errorMessage = "Location Services are not enabled for this computer, please enable them in Preferences."
            case .InvalidLocationFix:
                errorMessage = "Could not get a proper location fix in 15 seconds. Try again perhaps?"
            }
            throw CLIError.Error(errorMessage)
        } catch let error as CLError {
            let errorMessage: String
            switch (error) {
            case .LocationUnknown:
                errorMessage = "Unable to obtain a value right now"

            case .Denied:
                errorMessage = "You denied permission to use Location Services, please enable it in Preferences."
            case .Network:
                errorMessage = "Network seems to be unavailable, please enable networking"
            default: // shouldn't happen with the kind of requests we make            }
                errorMessage = "Unexpected CoreLocation error"
            }
            throw CLIError.Error(errorMessage)
        } catch {
            if let e = error as NSError? {
                throw CLIError.Error(e.localizedDescription)
            } else {
                throw error
            }
        }
    }

    public func setupOptions(options: Options) {
        options.onKeys(["--format"],
            usage:"output format (bare (default), json, sexagesimal)") {(key, value) in
                switch (value) {
                case "json":
                    self.format = .Json
                case "sexagesimal":
                    self.format = .Sexagesimal
                default:
                    self.format = .Bare
                }
        }
    }


    public func locationManager(manager: CLLocationManager, didUpdateLocations locations: [AnyObject]) {

        // the last one will be the most recent
        let updatedLocation = locations.last as! CLLocation;

        // Check is not older than 10 seconds, otherwise discard it
        if (updatedLocation.timestamp.timeIntervalSinceNow < MaxLocationFixStaleness) {
            self.location = updatedLocation.coordinate;
            locationObtained = true;
            CFRunLoopStop(CFRunLoopGetCurrent());
        }

    }
    
    public func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        self.locationError = error
        CFRunLoopStop(CFRunLoopGetCurrent());
    }
    
}