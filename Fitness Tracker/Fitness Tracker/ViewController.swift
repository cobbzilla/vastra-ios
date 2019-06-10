//
//  ViewController.swift
//  Fitness Tracker
//
//  Created by Ravi TPSS on 22/04/19.
//  Copyright © 2019 Fitness Tracker. All rights reserved.
//

import UIKit
import CoreLocation
import Mapbox

class ViewController: UIViewController,MGLMapViewDelegate {

    /* Location Manager variable to get the current location of the device */
    private var locationManager:CLLocationManager?
    /* Array of all the location coordinates captured during the  workout */
    private var allCoordinates: [CLLocationCoordinate2D] = []
    /* MGLShapeSource object to represent polyline/track on the map */
    private var polylineSource: MGLShapeSource?
    /*  MGLPointAnnotation object representing anotation at current position */
    private var movingAnotation:MGLPointAnnotation?
    /* It is used to animate the route on the map */
    private var timer: Timer?
    /* It represents the current value of index of location coordinate from the workoutCoordinates array. Default value is 1 */
    private var currentIndex = 1
    /* Workout distance in meters */
    private var distance:Double = 0.0
    /* This is the timer user to calculate time for the track */
    private var workoutTimer = Timer()
    /*  Time in seconds for the workout */
    private var workoutTime:Int64 = 0
   
    /* MGLMapView object to display map */
    @IBOutlet weak var mglMapView: MGLMapView!
    /* Start/Pause/Resume workout button */
    @IBOutlet weak var workoutActionButton: UIButton!
    /* Stop Workout button */
    @IBOutlet weak var stopButton: UIButton!
    
    /* It represents the active trek image selected by the user */
    @IBOutlet weak var activeTrekImageView: UIImageView!
    /* It represents the active trek label selected by the user */
    @IBOutlet weak var activeTrekLabel: UILabel!
    
    /* It represents the active Commute image selected by the user */
    @IBOutlet weak var activeCommuteImageView: UIImageView!
    /* It represents the active Commute label selected by the user */
    @IBOutlet weak var activeCommuteLabel: UILabel!
    
    /* It represents the current duration of the workout */
    @IBOutlet weak var durationLabel: UILabel!
    
    /* It represents the distance travelled during the workout */
    @IBOutlet weak var distanceLabel: UILabel!
    /* It represents the distance unit eg meter/km etc */
    @IBOutlet weak var distanceUnitLabel: UILabel!
    
    /* It represents the current speed of the workout */
    @IBOutlet weak var speedLabel: UILabel!
  
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        mglMapView.clearsContextBeforeDrawing = true
        polylineSource = nil
        movingAnotation = MGLPointAnnotation()
        setSelectedTrekType()
        setSeletedCommuteType()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(true)
        startTimer()
        allCoordinates = []
        startLocation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        workoutTimer.invalidate()
    }
    
    /**
      This method displays the trek type selected by the user
     
     - Bound to : N/A
     
     - Parameter : N/A
     
     - Throws: N/A
     
     - Returns: N/A.
     */
    
    func setSelectedTrekType(){
        
        activeTrekLabel.text = Constants.Global.selectedTrekType.rawValue
        activeTrekImageView.image = UIImage(named: Constants.Global.selectedTrekType.rawValue)
    }
    
    /**
    This method displays the commute type selected by the user
     
     - Bound to : N/A
     
     - Parameter : N/A
     
     - Throws: N/A
     
     - Returns: N/A.
     */
    func setSeletedCommuteType(){
        
        activeCommuteLabel.text = Constants.Global.selectedComuteType.rawValue
        activeCommuteImageView.image = UIImage(named: Constants.Global.selectedComuteType.rawValue)
    }
    
    /**
     Initialize the workout timer to track the time of the workout
     
     - Bound to : N/A
     
     - Parameter : N/A
     
     - Throws: N/A
     
     - Returns: N/A.
     */
    func startTimer(){
        
        workoutTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector:#selector(updateTimer) , userInfo: nil, repeats: true)
    }
    
    /**
     Called every second to update the time spent on the workout
     
     - Bound to : N/A
     
     - Parameter : N/A
     
     - Throws: N/A
     
     - Returns: N/A.
     */
    @objc func updateTimer(){
        
        workoutTime = workoutTime + 1
        
        var hours:Int64 = 0
        var minutes:Int64 = 0
        var seconds:Int64 = 0
        
        let numberOfSecondsInHour:Int64 = 3600
        let numberOfSecondsInMinute:Int64 = 60
        hours = workoutTime/numberOfSecondsInHour
        let remainingSeconds = workoutTime%numberOfSecondsInHour
        minutes = remainingSeconds/numberOfSecondsInMinute
        seconds = remainingSeconds%numberOfSecondsInMinute
        
        let workoutTimeString = String(format: "%02d:%02d:%02d", hours,minutes,seconds)
        durationLabel.text = workoutTimeString
    }
    
    
    /**
     Pauses/Resumes the workout. If the workout is currently in progress then this button will have text Pause. If the workout is paused the by clicking the button the text changes to Resume.
     
     - Bound to Workout action button Button
     
     - Parameter sender: The Pause/Resume Button.
     
     - Throws: N/A
     
     - Returns: N/A.
     */
    
    @IBAction func workoutActionButtonTapped(_ sender: UIButton) {
        
        let buttonText = workoutActionButton.title(for: .normal)
        if buttonText == "Resume"{
            startTimer()
            workoutActionButton.setTitle("Pause", for: .normal)
        }else{
            workoutTimer.invalidate()
            workoutActionButton.setTitle("Resume", for: .normal)
        }
    }
    
    /**
     When it is tapped the current workout session is completed and the app navigates to the Workout Review Screen. All the location coordinates that are captured during the workout are passed to the next screen.
     
     - Bound to Workout Stop Button
     
     - Parameter sender: The Stop Button.
     
     - Throws: N/A
     
     - Returns: N/A.
     */
    
    @IBAction func stopButtonTapped(_ sender: UIButton) {
        
        let reviewWorkoutViewController = Constants.Global.STORYBOARD.instantiateViewController(withIdentifier: "ReviewWorkoutViewController") as! ReviewWorkoutViewController
        reviewWorkoutViewController.allCoordinates = allCoordinates
        reviewWorkoutViewController.workoutDistance = distanceLabel.text ?? "0.0"
        reviewWorkoutViewController.workoutDistanceUnit = distanceUnitLabel.text ?? "m"
        reviewWorkoutViewController.workoutDuration = durationLabel.text ?? "00:00:00"
        reviewWorkoutViewController.distance = distance
        reviewWorkoutViewController.duration = workoutTime
        
        self.navigationController?.pushViewController(reviewWorkoutViewController, animated: true)
    }
    
    /**
     This function creates a CLLocationManager class object to get the device current location.
     
     - Bound to : N/A
     
     - Parameter sender: N/A.
     
     - Throws: N/A
     
     - Returns: N/A.
     */
    
    func startLocation() {
        
        // Create locationManager object.
        locationManager = CLLocationManager()
        // Set the class as the delegate of CLLocationManagerDelegate
        locationManager?.delegate = self
        // Request the user permission for accessing the device's current location
        locationManager?.requestAlwaysAuthorization()
        // Here we configure the Location Manager object to allow the app to access the location of the device when the app is in the background state
        locationManager?.allowsBackgroundLocationUpdates = true
        locationManager?.pausesLocationUpdatesAutomatically = false
        // Configure the object to get the best possible location of the device for navigation
        locationManager?.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager?.distanceFilter = 5
        
    }
    
    /**
     This function is used to display the current location of the device on the map. It also calls the addAnotation method to display the anotation at the current location
     
     - Bound to : N/A
     
     - Parameter sender: current Latitude and longitude of the divice returned by CLLocationManager Object
     
     - Throws: N/A
     
     - Returns: N/A.
     */
    
    func initiateCurrentLocation(latitude:Double, longitude:Double) {
        
        mglMapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mglMapView.userTrackingMode = .followWithCourse
        mglMapView.setCenter(
            CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
            zoomLevel: 15,
            animated: false)
        mglMapView.delegate = self
        addAnotation(map: mglMapView, latitude: latitude,longitude: longitude)
    }
    
    /**
     Adds anotation at initial device location on map
     
     - Bound to : N/A
     
     - Parameter sender: MGLMapView Object, current Latitude and longitude of the divice returned by CLLocationManager Object
     
     - Throws: N/A
     
     - Returns: N/A.
     */
    
    func addAnotation(map:MGLMapView, latitude:Double, longitude:Double){
        
        let anotation = MGLPointAnnotation()
        anotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        map.addAnnotation(anotation)
    }
    
    /**
     Adds anotation at current device location on map as the device moves
     
     - Bound to : N/A
     
     - Parameter sender: MGLMapView Object, current Latitude and longitude of the divice returned by CLLocationManager Object
     
     - Throws: N/A
     
     - Returns: N/A.
     */
    
    func movingAnotation(map:MGLMapView, latitude:Double, longitude:Double){
        
        movingAnotation?.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        if movingAnotation != nil {
            map.addAnnotation(movingAnotation!)
        }
    }
    
    /**
     When the Mapview finishes loading then this function of MGLMapViewDelegate is called. It calls two another methods one adds polylines on the map and the other function set the value of currentIndex = 1
     
     - Bound to : N/A
     
     - Parameter sender: MGLMapView Object
     
     - Throws: N/A
     
     - Returns: N/A.
     */
    
    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        
        addPolyline(to: mapView.style!)
        animatePolyline()
    }
    
    /**
     MGLMapViewDelegate delegate method. It returns the anotation image to be displayed at a particular distance
     
     - Bound to : N/A
     
     - Parameter : MGLMapView object, MGLAnnotation object
     
     - Throws: N/A
     
     - Returns: MGLAnnotationImage object
     */
    
    func mapView(_ mapView: MGLMapView, imageFor annotation: MGLAnnotation) -> MGLAnnotationImage? {
        
        if distance == 0 {
            var annotationImage = mapView.dequeueReusableAnnotationImage(withIdentifier: "anotationImage")
            if annotationImage == nil {
                var image = UIImage(named: "PointerBlue")!
                image = image.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: 0, bottom: image.size.height/2, right: 0))
                annotationImage = MGLAnnotationImage(image: image, reuseIdentifier: "anotationImage")
            }
            return annotationImage
        }else{
            
            var annotationImage = mapView.dequeueReusableAnnotationImage(withIdentifier: "anotationImageOrange")
            if annotationImage == nil {
                var image = UIImage(named: "PointerOrange")!
                image = image.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: 0, bottom: image.size.height/2, right: 0))
                annotationImage = MGLAnnotationImage(image: image, reuseIdentifier: "anotationImageOrange")
            }
            return annotationImage
        }
    }
    
    /**
     This method adds polylines on the map
     
     - Bound to : N/A
     
     - Parameter sender: MGLStyle object
     
     - Throws: N/A
     
     - Returns: N/A
     */
    
    func addPolyline(to style: MGLStyle) {
        
        let source = MGLShapeSource(identifier: "polyline", shape: nil, options: nil)
        style.addSource(source)
        polylineSource = source
        let layer = MGLLineStyleLayer(identifier: "polyline", source: source)
        layer.lineJoin = NSExpression(forConstantValue: "round")
        layer.lineCap = NSExpression(forConstantValue: "round")
        layer.lineColor = NSExpression(forConstantValue: UIColor.blue)
        layer.lineWidth = NSExpression(format: "mgl_interpolate:withCurveType:parameters:stops:($zoomLevel, 'linear', nil, %@)",
                                       [10: 5, 9: 20])
        style.addLayer(layer)
    }
    
    /**
     Sets the currentIndex = 1.
     
     - Bound to : N/A
     
     - Parameter sender: N/A
     
     - Throws: N/A
     
     - Returns: N/A
     */
    
    func animatePolyline() {
        
        currentIndex = 1
        // Start a timer that will simulate adding points to our polyline. This could also represent coordinates being added to our polyline from another source, such as a CLLocationManagerDelegate.
        ///timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(tick), userInfo: nil, repeats: true)
    }
    
    /**
     This method is used to set the polyline segments as now locations are being captured by calling updatePolylineWithCoordinates method. It increase the value of currentIndex by one
     
     - Bound to : N/A
     
     - Parameter : N/A
     
     - Throws: N/A
     
     - Returns: N/A
     */
    
    @objc func tick() {
        
        if currentIndex > allCoordinates.count ?? 0 {
            //timer?.invalidate()
            //timer = nil
            return
        }
        let coordinates = Array(allCoordinates[0..<currentIndex] )
        updatePolylineWithCoordinates(coordinates: coordinates)
        currentIndex += 1
    }
    
    /**
     This method is used to set the polyline segments as new locations are being captured
     
     - Bound to : N/A
     
     - Parameter sender: Coordinates of the location at currentIndex
     - Throws: N/A
     
     - Returns: N/A
     */
    
    func updatePolylineWithCoordinates(coordinates: [CLLocationCoordinate2D]) {
        
        var mutableCoordinates = coordinates
        let polyline = MGLPolylineFeature(coordinates: &mutableCoordinates, count: UInt(mutableCoordinates.count))
        polylineSource?.shape = polyline
    }
}

/**
 This extension conforms to CLLocationManagerDelegate
 */

extension ViewController: CLLocationManagerDelegate {
    
    /**
     This method is called everytime when LocationManager object finds a new location. It gives an array of number of possible locations of the device. The last object of the array represents the most recent location of the device.
     
     - Bound to : N/A
     
     - Parameter sender: CLLocationManager object, array of possible location of the device
     
     - Throws: N/A
     
     - Returns: N/A
     
     */
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if locations.count > 0 {
            
            let currentLocation = locations.last
            let currentSpeed = currentLocation?.speed
            self.currentSpeed(speed: currentSpeed)
            
            if allCoordinates.count == 0{
                
                allCoordinates.append((locations.last?.coordinate)!)
                let latitude =  currentLocation?.coordinate.latitude
                let longitude = currentLocation?.coordinate.longitude
                initiateCurrentLocation(latitude: latitude!, longitude: longitude!)
                
                addPolyline(to: mglMapView.style!)
                animatePolyline()
                
            }else {
                
                let coordinate = CLLocation(latitude: (allCoordinates.last?.latitude)!, longitude: (allCoordinates.last?.longitude)!)
                let distanceInMeters = currentLocation?.distance(from: coordinate) as! Double
                if distanceInMeters >= 6.0 {
                    distanceTraveled(newDistance: distanceInMeters)
                    allCoordinates.append((locations.last?.coordinate)!)
                    let latitude = locations.last?.coordinate.latitude
                    let longitude = locations.last?.coordinate.longitude
                    movingAnotation(map: mglMapView, latitude: latitude!,longitude: longitude!)
                }
            }
        
            let buttonText = workoutActionButton.title(for: .normal)
            if buttonText == "Pause"{
                tick()
            }
        }
    }
    
    /**
     Calculates the current speed of the user. It also display current speed on the app
     
     - Bound to : N/A
     
     - Parameter sender: current speed in meter/second
     
     - Throws: N/A
     
     - Returns: N/A
     
     */
    func currentSpeed(speed:Double?) {
        
        let speedValue = speed ?? 0.0
        if speedValue >= 0 {
            let currentSpeedString = String(format: "%.2f", speedValue)
            self.speedLabel.text = currentSpeedString
        }
    }
    
    /**
     This method calculate the distance travelled during the workout and update distance/distance unit label
     
     - Bound to : N/A
     
     - Parameter sender: distance between last can current location
     
     - Throws: N/A
     
     - Returns: N/A
     
     */
    func distanceTraveled(newDistance:Double){
        
        distance = distance + newDistance
        var distanceString = String(format: "%.2f",distance)
        var distanceUnitString = "m"
        if distance >  1000 {
            let kmDistance = distance/1000.0
            distanceString = String(format: "%.3f", kmDistance)
            distanceUnitString = "km"
        }
        distanceUnitLabel.text = distanceUnitString
        distanceLabel.text = distanceString
    }
    
    /**
     If while accessing location of the device any error occurs the this method is called
     
     - Bound to : N/A
     
     - Parameter sender: CLLocationManager object, Error object explaining the reason of the failure
     
     - Throws: N/A
     
     - Returns: N/A
     
     */
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print("\(error)")
    }
    
    /**
     This method is called when the users changes the Authorization status
     
     - Bound to : N/A
     
     - Parameter sender: CLLocationManager object, CLAuthorizationStatus object 
     
     - Throws: N/A
     
     - Returns: N/A
     
     */
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            locationManager?.startUpdatingLocation()
            locationManager?.startUpdatingHeading()
        }
    }
    
}
