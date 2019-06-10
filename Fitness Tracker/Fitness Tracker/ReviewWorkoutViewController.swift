//
//  ReviewWorkoutViewController.swift
//  Fitness Tracker
//
//  Created by Ravi TPSS on 24/04/19.
//  Copyright © 2019 Fitness Tracker. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
import Mapbox
import PopupDialog

class ReviewWorkoutViewController: UIViewController, MGLMapViewDelegate {

    /* Array of all the location coordinates captured during the  workout */
    var workoutCoordinates:[CLLocationCoordinate2D] = []
    /* Name of the workout entered by user when saving it */
    var workoutName = ""
    /* It is used to animate the route on the map*/
    var timer: Timer?
    /* MGLShapeSource object to represent polyline/track on the map */
    var polylineSource: MGLShapeSource?
    /* It represents the current value of index of location coordinate from the workoutCoordinates array. Default value is 1 */
    var currentIndex = 1
    /* Array of all the location coordinates captured during the  workout */
    var allCoordinates: [CLLocationCoordinate2D]!
    /* Duration of the workout */
    var workoutDuration:String = ""
    /* Distance of the workout */
    var workoutDistance:String = ""
    /* Workout distance unit eg. meter/km */
    var workoutDistanceUnit:String = ""
    /* Workout duration in seconds */
    var duration:Int64 = 0
    /* Workout distance in meters */
    var distance:Double = 0.0
    
    private var movingAnotation:MGLPointAnnotation?
    
    /* Outlet to MGLMapView */
    @IBOutlet weak var mglMapView: MGLMapView!
    
    /* Outlet to active TrekTyp ImageView */
    @IBOutlet weak var activeTrekImageView: UIImageView!
    /* Outlet to active TrekTyp Label */
    @IBOutlet weak var activeTrekLabel: UILabel!
    
    /* Outlet to active CommuteTyp ImageView */
    @IBOutlet weak var activeCommuteImageView: UIImageView!
    /* Outlet to active CommuteTyp Label */
    @IBOutlet weak var activeCommuteLabel: UILabel!
    
    /* Outlet to workout Duration Label */
    @IBOutlet weak var durationLabel: UILabel!
    
    /* Outlet to workout Distance Label */
    @IBOutlet weak var distanceLabel: UILabel!
    /* Outlet to workout Distance Unit (meter/km) Label */
    @IBOutlet weak var distanceUnitLabel: UILabel!
    
    /* Outlet to workout Average Speed Label */
    @IBOutlet weak var speedLabel: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setSelectedTrekType()
        setSeletedCommuteType()
        movingAnotation = MGLPointAnnotation()
        initateTrek()
        durationLabel.text = workoutDuration
        distanceLabel.text = workoutDistance
        distanceUnitLabel.text = workoutDistanceUnit
        setAverageSpeed()
        
        // Set self as observer for WorkoutName notification sent by workout popup
        NotificationCenter.default.addObserver(self, selector: #selector(self.workoutNameNotification), name: NSNotification.Name(rawValue: "WorkoutName"), object: nil)
        
    }
    
    /**
     Initialize the mapview with starting point of the trek
     
     - Bound to : N/A
     
     - Parameter : N/A
     
     - Throws: N/A
     
     - Returns: N/A.
     */
    func initateTrek() {
        
        mglMapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        let latitude = allCoordinates.first?.latitude
        let longitude = allCoordinates.first?.longitude
        mglMapView.setCenter(
            CLLocationCoordinate2D(latitude: latitude ?? 100.0, longitude: longitude ?? 100.0),
            zoomLevel: 18,
            animated: false)
        mglMapView.delegate = self
    }
    
    /**
     Displays the selected TrekType
     
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
     Displays the selected CommuteType
     
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
     Displays the averate speed of the workout
     
     - Bound to : N/A
     
     - Parameter : N/A
     
     - Throws: N/A
     
     - Returns: N/A.
     */
    func setAverageSpeed(){
        
        if distance != 0.0 {
            let durationInMinutes = Double(duration)/60.0
            let averageSpeed = distance/durationInMinutes
            speedLabel.text = String(format: "%.2f", averageSpeed)
        }else {
            speedLabel.text = "0.0"
        }
    }
    
    /**
     Listens to the workoutName notification
     
     - Bound to : N/A
     
     - Parameter : N/A
     
     - Throws: N/A
     
     - Returns: N/A.
     */
    @objc private func workoutNameNotification(notification: NSNotification){
       
        let userInfo = notification.userInfo as! [String:String]
        workoutName = userInfo["workoutName"] ?? ""
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
     Call the saveWorkoutDetail() method to save workout
     
     - Bound to : saveWorkoutButton
     
     - Parameter sender : saveWorkoutButton
     
     - Throws: N/A
     
     - Returns: N/A.
     */
    
    @IBAction func saveWorkoutButtonTapped(_ sender: UIButton) {
        
        showWorkoutDialog(animated: true)
    }
    
    /**
     Takes the user to new workout screen.
     
     - Bound to : newWorkoutButton
     
     - Parameter sender : newWorkoutButton
     
     - Throws: N/A
     
     - Returns: N/A.
     */
    
    @IBAction func newWorkoutButtonTapped(_ sender: UIButton) {
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    /**
     Saves the workout detail to the device using coredata
     
     - Bound to : N/A
     
     - Parameter : N/A
     
     - Throws: N/A
     
     - Returns: N/A.
     */
    func saveWorkoutDetail(){
        
        let entity = NSEntityDescription.entity(forEntityName: "Workout", in: Constants.Global.VIEWCONTEXT)
        let workout = NSManagedObject(entity: entity!, insertInto: Constants.Global.VIEWCONTEXT) as! Workout
        
        workout.workoutName = workoutName
        workout.comuteType = Constants.Global.selectedComuteType.rawValue
        workout.trekType = Constants.Global.selectedTrekType.rawValue
        workout.coordinates = workoutCoordinates
        
        workout.duration = duration
        workout.durationString = workoutDuration
        workout.totalDistance = distance
        workout.totalDistanceString = workoutDistance
        
        do {
            try Constants.Global.VIEWCONTEXT.save()
            displayAlert(title: "Success", message: "Workout Saved Successfully.")
        } catch {
            print("error")
        }
    }
    
    /**
     Used to display alert
     
     - Bound to : N/A
     
     - Parameter : title - of the alert eg Success/Alert/Error, message - message to be displayed on the alert
     
     - Throws: N/A
     
     - Returns: N/A.
     */
    
    func displayAlert(title:String, message:String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: {( UIAlertAction ) in })
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    /**
     MGLMapViewDelegate delegate method called when maps loads completely
     
     - Bound to : N/A
     
     - Parameter : MGLMapView object
     
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
        
        if currentIndex == 1 {
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
        timer = Timer.scheduledTimer(timeInterval: 0.005, target: self, selector: #selector(tick), userInfo: nil, repeats: true)
    }
    
    /**
     This method is used to set the polyline segments as now locations are being captured by calling updatePolylineWithCoordinates method. It increase the value of currentIndex by one
     
     - Bound to : N/A
     
     - Parameter : N/A
     
     - Throws: N/A
     
     - Returns: N/A
     */
    
    @objc func tick() {
        
        if currentIndex > allCoordinates.count {
            timer?.invalidate()
            timer = nil
            return
        }
        let coordinates = Array(allCoordinates[0..<currentIndex])
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
        
        let coordinate = coordinates[currentIndex-1]
        let latitude = coordinate.latitude
        let longitude = coordinate.longitude
        
        if currentIndex == 1 {
            addAnotation(map: mglMapView, latitude: latitude ,longitude: longitude )
        }else{
            movingAnotation(map: mglMapView, latitude: latitude,longitude: longitude)
        }
        
    }
    
    /**
     Displays popup to save workout
     
     - Bound to : N/A
     
     - Parameter Bool value indicating whether to present it with animation or not
     
     - Throws: N/A
     
     - Returns: N/A.
     */
    func showWorkoutDialog(animated: Bool = true) {
        
        // Create a custom view controller
        let ratingVC = RatingViewController(nibName: "RatingViewController", bundle: nil)
        
        // Create the dialog
        let popup = PopupDialog(viewController: ratingVC,
                                buttonAlignment: .horizontal,
                                transitionStyle: .bounceDown,
                                tapGestureDismissal: false,
                                panGestureDismissal: false)
        
        // Create first button
        let buttonOne = CancelButton(title: "CANCEL", height: 60) {
            // Hide the popup
        }
        
        // Create second button
        let buttonTwo = DefaultButton(title: "OK", height: 60) {
            // Checks for empty workout name
            if self.workoutName != "" {
                // Call saveWorkoutDetail() method
                self.saveWorkoutDetail()
            }else {
                // Display alert if user has not entered the workout name
                self.displayAlert(title: "Alert!", message: "Please enter workout name.")
            }
        }
        
        // Add buttons to dialog
        popup.addButtons([buttonOne, buttonTwo])
        
        // Present dialog
        present(popup, animated: animated, completion: nil)
    }
    
}
