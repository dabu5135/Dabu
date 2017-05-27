//
//  FirstViewController.swift
//  MyLocation
//
//  Created by Dabu on 2017. 4. 25..
//  Copyright © 2017년 Dabu. All rights reserved.
//

import UIKit
import CoreLocation

class CurrentLocationViewController: UIViewController {
  
  @IBOutlet weak var messageLabel: UILabel!
  @IBOutlet weak var latitudeLabel: UILabel!
  @IBOutlet weak var longitudeLabel: UILabel!
  @IBOutlet weak var addressLabel: UILabel!
  @IBOutlet weak var tagButton: UIButton!
  @IBOutlet weak var getButton: UIButton!
  
  let locationManager = CLLocationManager()
  var location: CLLocation?
  var updatingLocation = false
  var lastLocationError: Error?
  
  // Properties for geocoding
  let geocoder = CLGeocoder()
  var placemark: CLPlacemark?       // address를 담기 위한 변수
  var performingReverseGeocoding = false
  var lastGeocodingError: Error?
  
  // MARK: View Controller Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    updateLabels()
    configureGetButton()
  }
  
  deinit {
    print("CurrentViewController is deinited!!")
  }
  
  
  // MARK: IBAction
  @IBAction func getLocation() {
    
    let authStatus = CLLocationManager.authorizationStatus()
    
    if authStatus == .notDetermined {
      locationManager.requestWhenInUseAuthorization()
      return
    }
    
    if authStatus == .denied || authStatus == .restricted {
      
      showLocationServicesDeniedAlert()
      return
    }
    
    // 버튼 toggle
    if updatingLocation {
      stopLocationManager()
    } else {
      location = nil
      lastLocationError = nil
      startLocationManager()
    }
    
    updateLabels()
    configureGetButton()
  }
  
  // MARK: Others
  func showLocationServicesDeniedAlert() {
    
    let alert = UIAlertController(title: "Location Services Disabled",
                                  message: "Please enable location services for this app in Settings",
                                  preferredStyle: .alert)
    let okAction = UIAlertAction(title: "OK",
                                 style: .default, handler: nil)
    
    alert.addAction(okAction)
    present(alert,
            animated: true,
            completion: nil)
  }
  
  func updateLabels() {
    
    if let location = location {
      latitudeLabel.text = String(format: "%.8f", location.coordinate.latitude)
      longitudeLabel.text = String(format: "%.8f", location.coordinate.longitude)
      tagButton.isHidden = false
      messageLabel.text = ""
      if let placemark = placemark {
        addressLabel.text = string(from: placemark)
      } else if performingReverseGeocoding {
        addressLabel.text = "Searching for address...."
      } else if lastGeocodingError != nil {
        addressLabel.text = "Error Finding Address.."
      } else {
        addressLabel.text = "No Address Found"
      }
      
    } else {
      latitudeLabel.text = ""
      longitudeLabel.text = ""
      addressLabel.text = ""
      tagButton.isHidden = true
      
      let statusMessage: String
      
      if let error = lastLocationError as NSError? {
        
        // kCLErrorDomain은 Core Location 에러와 연관
        //                if error.domain == kCLErrorDomain && error.code == CLError.denied.rawValue {
        //                    statusMessage = "Location Services Disabled"
        //                } else {
        //                    statusMessage = "Error Getting Location"
        //                }
        statusMessage = (error.domain == kCLErrorDomain && error.code == CLError.denied.rawValue) ? "Location Services Disabled" : "Error Getting Location"
        
      } else if !CLLocationManager.locationServicesEnabled() {
        statusMessage = "Location Services Disabled"
      } else if updatingLocation {
        statusMessage = "Searching...."
      } else {
        statusMessage = "Tap 'Get My Location' to Start!"
      }
      
      messageLabel.text = statusMessage
    }
  }
  
  func stopLocationManager() {
    
    if updatingLocation {
      locationManager.stopUpdatingLocation()
      locationManager.delegate = nil
      updatingLocation = false
    }
  }

  
  func startLocationManager() {
    placemark = nil
    lastGeocodingError = nil
    
    if CLLocationManager.locationServicesEnabled() {
      locationManager.delegate = self
      locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
      locationManager.startUpdatingLocation()
      updatingLocation = true
    }
  }
  
  func configureGetButton() {
    if updatingLocation {
      getButton.setTitle("Stop", for: .normal)
    } else {
      getButton.setTitle("Get My Location", for: .normal)
    }
  }
  
  func string(from placemark: CLPlacemark) -> String {
    var line1 = ""
    if let s = placemark.subThoroughfare {
      line1 += s + " "
    }
    if let s = placemark.thoroughfare {
      line1 += s }
    var line2 = ""
    if let s = placemark.locality {
      line2 += s + " "
    }
    if let s = placemark.administrativeArea {
      line2 += s + " "
    }
    if let s = placemark.postalCode {
      line2 += s }
  
    return line1 + "\n" + line2
  }
}

// MARK: - CLLocationManager Delegate

extension CurrentLocationViewController: CLLocationManagerDelegate {
  
  func locationManager(_ manager: CLLocationManager,
                       didFailWithError error: Error) {
    
    print("didFailWithEror \(error)")
    
    if (error as NSError).code == CLError.locationUnknown.rawValue {
      return
    }
    lastLocationError = error
    stopLocationManager()
    updateLabels()
    configureGetButton()
  }
  
  func locationManager(_ manager: CLLocationManager,
                       didUpdateLocations locations: [CLLocation]) {
    
    let newLocation = locations.last!
    print("didUpdateLocations \(newLocation)")
    
    if newLocation.timestamp.timeIntervalSinceNow < -5 {
      return
    }
    
    // horizontalAccuracy가 음수이면 location은 invalid 인듯하다.
    if newLocation.horizontalAccuracy < 0 {
      return
    }
    
    var distance = CLLocationDistance(Double.greatestFiniteMagnitude)
    if let location = location {
      distance = newLocation.distance(from: location)
    }
    
    // location이 nil일 때(즉, 처음 위치를 받아올때) or 새로운 위치의 정확도가 더 좋을 때
    if location == nil || location!.horizontalAccuracy > newLocation.horizontalAccuracy {
      lastLocationError = nil
      location = newLocation
      updateLabels()
      
      // locationManager에 설정한 Accuracy보다 같거나 더 낮은(=정확도높은)위치가 들어왔을 때 stop한다.
      if newLocation.horizontalAccuracy <= locationManager.desiredAccuracy {
        print("Done!!")
        stopLocationManager()
        configureGetButton()
      }
      
      if !performingReverseGeocoding {
        print("** Geocoding..~~ **")
        performingReverseGeocoding = true
        geocoder.reverseGeocodeLocation(
          newLocation,
          completionHandler: { [weak self] placemarks, error in
            guard let `self` = self else { return }
            print("*** Found placemarks: \(String(describing: placemarks)), error: \(String(describing: error))")
            self.lastGeocodingError = error
            if error == nil, let p = placemarks, !p.isEmpty {
              self.placemark = p.last
            } else {
              self.placemark = nil
            }
            self.performingReverseGeocoding = false
            self.updateLabels()
        })
      }
    } else if distance < 1 {
      let tiemInterval = newLocation.timestamp.timeIntervalSince(location!.timestamp)
      if tiemInterval > 10 {
        print("Force Done~~")
        stopLocationManager()
        updateLabels()
        configureGetButton()
        
        if distance > 0 {
          performingReverseGeocoding = false
        }
      }
    }
  }
}

