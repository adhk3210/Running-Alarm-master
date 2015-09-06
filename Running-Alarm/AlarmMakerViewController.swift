//
//  AlarmMakerViewController.swift
//  Running-Alarm
//
//  Created by Edward Yoo on 9/5/15.
//  Copyright (c) 2015 Hohun Yoo. All rights reserved.
//

import UIKit
import RealmSwift
import CoreLocation
import MapKit

class AlarmMakerViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

  @IBOutlet weak var timePickerWheel: UIDatePicker!
  @IBOutlet weak var mapView: MKMapView!
  
  let locationManager = CLLocationManager()
  var currentAlarm = Alarm()
  var setAlarm: NSDate?
  var alarmString = ""
  var timeOfDayData: [String]?
  var cycle = 0
  var startingPoint = CLLocation(latitude: 0, longitude: 0)
  
  var dataPassed:UIColor!
  var secondDataPassed:UIColor!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    var topColor = dataPassed
    var bottomColor = secondDataPassed
    
    let gradientColors: [CGColor] = [topColor.CGColor, bottomColor.CGColor]
    let gradientLocations: [Float] = [0.1, 1.0]
    
    let gradientLayer: CAGradientLayer = CAGradientLayer()
    gradientLayer.colors = gradientColors
    gradientLayer.locations = gradientLocations
    
    gradientLayer.frame = self.view.bounds
    self.view.layer.insertSublayer(gradientLayer, atIndex: 0)
    
    timePickerWheel.setValue(UIColor.whiteColor(), forKeyPath: "textColor")
    
    self.locationManager.delegate = self
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
    self.locationManager.requestWhenInUseAuthorization()
    self.locationManager.startUpdatingLocation()
    
    self.mapView.showsUserLocation = true
  }
  
  static var dateFormatter: NSDateFormatter = {
    var formatter = NSDateFormatter()
    formatter.dateFormat = "HH:mm"
    return formatter
  }()

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    currentAlarm.timeString = AlarmMakerViewController.dateFormatter.stringFromDate(timePickerWheel.date)
    currentAlarm.setDate = timePickerWheel.date
    println(currentAlarm.modificationDate)
    currentAlarm.findDifferenceBetweenTimesAndSetTimer(currentAlarm.modificationDate, timeSet: currentAlarm.setDate)
  }
  
  var alarm: Alarm? {
    didSet {
      if let alarm = alarm, timePickerWheel = timePickerWheel {
        alarm.timeString = AlarmMakerViewController.dateFormatter.stringFromDate(timePickerWheel.date)
      }
    }
  }
  
  @IBAction func timePickerAction(sender: AnyObject) {
    var dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    var strDate = dateFormatter.stringFromDate(timePickerWheel.date)
    }
  
  // MARK: Map Stuff- done by Albert Kim
  
  func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
    let location = locations.last as! CLLocation
    let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    var latitude: Double = location.coordinate.latitude
    var longitude: Double = location.coordinate.longitude
    var coordinates: CLLocation = CLLocation(latitude: latitude, longitude: longitude)
    var conversionToMetersToMilesFactor = 0.000621371
    self.mapView.setRegion(region, animated: true)
    cycle++
    
    if cycle == 1 {
      startingPoint = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
//      println("Starting Location: \(startingPoint.coordinate.latitude), \(startingPoint.coordinate.longitude)")
      let annotation = MKPointAnnotation()
      annotation.coordinate = CLLocationCoordinate2D(latitude: startingPoint.coordinate.latitude, longitude: startingPoint.coordinate.longitude)
      self.mapView.addAnnotation(annotation)
    }
    
    var distance = (startingPoint.distanceFromLocation(coordinates) * conversionToMetersToMilesFactor)
    
//    println("Distance: \(distance)")
    
    if distance >= 0.1 {
      println("youre too far")
      self.locationManager.stopUpdatingLocation()
    }
    
//    println("current location: \(latitude), \(longitude)")
  }
  
  func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
    print("Error: " + error.localizedDescription)
  }
  
}
