//
//  AlarmLandingViewController.swift
//  Running-Alarm
//
//  Created by Edward Yoo on 9/5/15.
//  Copyright (c) 2015 Hohun Yoo. All rights reserved.
//
import UIKit
import RealmSwift
import CoreLocation
import AudioToolbox
import AVFoundation

class AlarmLandingViewController: UIViewController {

  @IBOutlet weak var currentTimeLabel: UILabel!
  @IBOutlet weak var tableView: UITableView!
  
  var colorOne = UIColor(red: 190/255, green: 144/255, blue: 212/255, alpha: 1)
  var colorTwo = UIColor(red: 137/255, green: 196/255, blue: 244/255, alpha: 1)
  
  var alarms: Results<Alarm>! {
    didSet {
      tableView?.reloadData()
    }
  }
  var locationManager = CLLocationManager()
  var cycle = 0
  var startingPoint = CLLocation(latitude: 0, longitude: 0)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let gradientColors: [CGColor] = [colorOne.CGColor, colorTwo.CGColor]
    let gradientLocations: [Float] = [0.1, 1.0]
    
    let gradientLayer: CAGradientLayer = CAGradientLayer()
    gradientLayer.colors = gradientColors
    gradientLayer.locations = gradientLocations
    
    gradientLayer.frame = self.view.bounds
    self.view.layer.insertSublayer(gradientLayer, atIndex: 0)
    
    //user location
    self.locationManager.delegate = self
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
    self.locationManager.requestWhenInUseAuthorization()
    self.locationManager.startUpdatingLocation()
    
    //tableView stuff for alarm
    tableView.dataSource = self
    var timestamp = NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .NoStyle, timeStyle: .ShortStyle)
    currentTimeLabel.text = "\(timestamp)"
    let realm = Realm()
    alarms = realm.objects(Alarm)
    tableView?.reloadData()
    
    self.navigationController!.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
    self.navigationController!.navigationBar.shadowImage = UIImage()
    self.navigationController!.navigationBar.translucent = true
  }
  
  override func viewDidAppear(animated: Bool) {
    tableView?.reloadData()
    var timestamp = NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .NoStyle, timeStyle: .ShortStyle)
    currentTimeLabel.text = "\(timestamp)"
  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }
  
  func soundOnTime() {
    
  }
  
  @IBAction func unwindToSegue(segue: UIStoryboardSegue) {
    let realm = Realm()
    if let identifier = segue.identifier {
      switch identifier {
        case "Save":
          let source = segue.sourceViewController as! AlarmMakerViewController
      
          realm.write() {
            realm.add(source.currentAlarm)
          }
        
        default:
        println("do something")
      }
    }
  }
  
}

extension AlarmLandingViewController: UITableViewDataSource {
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("AlarmCell", forIndexPath: indexPath) as! AlarmTableViewCell
    let row = indexPath.row
    let alarm = alarms[row] as Alarm
    cell.alarm = alarm
    
    return cell
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return Int(alarms?.count ?? 0)
  }
  
  func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == UITableViewCellEditingStyle.Delete {
      let realm = Realm()
      var selectedAlarm = alarms[indexPath.row]
      realm.write() {
        realm.delete(selectedAlarm)
        tableView.reloadData()
      }
    }
  }
}

extension AlarmLandingViewController: CLLocationManagerDelegate {
  
  func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
    let location = locations.last as! CLLocation
    var latitude: Double = location.coordinate.latitude
    var longitude: Double = location.coordinate.longitude
    var coordinates: CLLocation = CLLocation(latitude: latitude, longitude: longitude)
    var conversionToMetersToMilesFactor = 0.000621371
    cycle++
    
    if cycle == 1 {
      startingPoint = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
      //      println("Starting Location: \(startingPoint.coordinate.latitude), \(startingPoint.coordinate.longitude)")
    }
    
    var distance = (startingPoint.distanceFromLocation(coordinates) * conversionToMetersToMilesFactor)
    
    if distance >= 0.1 {
      println("youre too far")
      self.locationManager.stopUpdatingLocation()
    }
  }
  
  func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
    print("Error: " + error.localizedDescription)
  }
 
  @IBAction func buttonSubmit(sender: AnyObject) {
  }
  
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
    if (segue.identifier == "buttonSubmitSegue") {
      var svc = segue.destinationViewController as! AlarmMakerViewController;
      svc.dataPassed = colorOne
      svc.secondDataPassed = colorTwo
    }
  }
  
}