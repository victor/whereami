//
//  WhereAmICommand.swift
//  whereami
//
//  Created by Victor Jalencas on 14/12/14.
//  © 2014-2015 Hand Forged. All rights reserved.
//

import Foundation
import SwiftCLI
import CoreLocation


let MaxLocationFixStaleness = 10.0

enum OutputFormat {
	case json
	case bare
	case sexagesimal
}

enum WhereAmIError: ErrorType {
	case restrictedPermission
	case deniedPermission
	case locationServicesDisabled
	case invalidLocationFix
//	case locationUnknown
}

public class WhereAmICommand: NSObject, OptionCommandType, CLLocationManagerDelegate {
	public let commandName = ""
	public let commandShortDescription = "Returns your location"
	public let commandSignature = ""

	public var helpOnHFlag = true

	var locationObtained = false
	var location : CLLocationCoordinate2D?
	var locationError: ErrorType?

	var format = OutputFormat.bare



	func display(location: CLLocationCoordinate2D) -> () {
		var outputString: String
		switch (self.format) {
		case .json:
			outputString = "{\"latitude\":\(location.latitude), \"longitude\": \(location.longitude)}"
		case .sexagesimal:
			outputString = "\(stringFromDegrees(location.latitude)), \(stringFromDegrees(location.longitude))"
		case .bare:
			outputString = "\(location.latitude),\(location.longitude)"
		}
		print(outputString)

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

	public func execute(arguments: CommandArguments) throws  {
		do {
			switch CLLocationManager.authorizationStatus() {
			case .Restricted:
				throw WhereAmIError.restrictedPermission
			case .Denied:
				throw WhereAmIError.deniedPermission
			default:
				guard CLLocationManager.locationServicesEnabled() else {
					throw WhereAmIError.locationServicesDisabled
				}
			}

			let manager = CLLocationManager()
			manager.delegate = self
			manager.startUpdatingLocation()

			let status = CFRunLoopRunInMode(kCFRunLoopDefaultMode, 15, false)


			guard status != .TimedOut else {
				throw WhereAmIError.invalidLocationFix
			}

			guard let foundLocation = location else {
				throw self.locationError!
			}

			display(foundLocation)

		} catch let error as WhereAmIError {
			let errorMessage: String
			switch (error) {
			case .restrictedPermission:
				errorMessage = "You don't have permission to use Location Services."
			case .deniedPermission:
				errorMessage = "You denied permission to use Location Services, please enable it in Preferences."
			case .locationServicesDisabled:
				errorMessage = "Location Services are not enabled for this computer, please enable them in Preferences."
			case .invalidLocationFix:
				errorMessage = "Could not get a proper location fix in 15 seconds. Try again perhaps?"
			}
			throw CLIError.Error(errorMessage)
		} catch let error as CLError {
			let errorMessage: String
			switch (error) {
			case .LocationUnknown:
				errorMessage = "Unable to obtain a value right now, please try again."

			case .Denied:
				errorMessage = "You denied permission to use Location Services, please enable it in Preferences."
			case .Network:
				errorMessage = "WiFi seems to be unavailable, please enable Airport"
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
							self.format = .json
						case "sexagesimal":
							self.format = .sexagesimal
						default:
							self.format = .bare
						}
		}
	}

	#if swift(>=2.3)
	public func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

		// the last one will be the most recent
		if let updatedLocation = locations.last {

			// Check is not older than 10 seconds, otherwise discard it
			if (updatedLocation.timestamp.timeIntervalSinceNow < MaxLocationFixStaleness) {
				self.location = updatedLocation.coordinate
				locationObtained = true
				CFRunLoopStop(CFRunLoopGetCurrent())
			}
		}

	}
	#else
	public func locationManager(manager: CLLocationManager, didUpdateLocations locations: [AnyObject]) {

		// the last one will be the most recent
		if let updatedLocation = locations.last {

			// Check is not older than 10 seconds, otherwise discard it
			if (updatedLocation.timestamp.timeIntervalSinceNow < MaxLocationFixStaleness) {
				self.location = updatedLocation.coordinate
				locationObtained = true
				CFRunLoopStop(CFRunLoopGetCurrent())
			}
		}
		
	}
	#endif




	public func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
		self.locationError = error
		CFRunLoopStop(CFRunLoopGetCurrent())
	}

}
