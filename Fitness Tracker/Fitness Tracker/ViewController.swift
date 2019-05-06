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

    var locationManager:CLLocationManager?
    var locationsArray:[CLLocationCoordinate2D] = []
    var timer: Timer?
    var polylineSource: MGLShapeSource?
    var currentIndex = 1
    var allCoordinates: [CLLocationCoordinate2D]!
    var movingAnotation:MGLPointAnnotation?
    
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var mglMapView: MGLMapView!
    @IBOutlet weak var workoutActionButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        polylineSource = nil
        movingAnotation = MGLPointAnnotation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(true)
        locationsArray = []
        startLocation()
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func workoutActionButtonTapped(_ sender: UIButton) {
        
        let buttonText = workoutActionButton.title(for: .normal)
        if buttonText == "Resume"{
            workoutActionButton.setTitle("Pause", for: .normal)
        }else{
            workoutActionButton.setTitle("Resume", for: .normal)
        }
    }
    
    @IBAction func stopButtonTapped(_ sender: UIButton) {
        
        let reviewWorkoutViewController = Constants.Global.STORYBOARD.instantiateViewController(withIdentifier: "ReviewWorkoutViewController") as! ReviewWorkoutViewController
        reviewWorkoutViewController.allCoordinates = allCoordinates
        self.navigationController?.pushViewController(reviewWorkoutViewController, animated: true)
    }
    
    func startLocation() {
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        locationManager?.allowsBackgroundLocationUpdates = true
        locationManager?.pausesLocationUpdatesAutomatically = false
        locationManager?.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager?.distanceFilter = 5
    }
    
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
    
    func addAnotation(map:MGLMapView, latitude:Double, longitude:Double){
        
        let anotation = MGLPointAnnotation()
        anotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        map.addAnnotation(anotation)
    }
    
    func movingAnotation(map:MGLMapView, latitude:Double, longitude:Double){
        
        movingAnotation?.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        if movingAnotation != nil {
            map.addAnnotation(movingAnotation!)
        }
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        
        addPolyline(to: mapView.style!)
        animatePolyline()
    }
    
    func mapView(_ mapView: MGLMapView, imageFor annotation: MGLAnnotation) -> MGLAnnotationImage? {
        
        var annotationImage = mapView.dequeueReusableAnnotationImage(withIdentifier: "anotationImage")
        if annotationImage == nil {
            var image = UIImage(named: "Blue")!
            image = image.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: 0, bottom: image.size.height/2, right: 0))
            annotationImage = MGLAnnotationImage(image: image, reuseIdentifier: "anotationImage")
        }
        
        return annotationImage
    }
    
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
    
    func animatePolyline() {
        
        currentIndex = 1
        // Start a timer that will simulate adding points to our polyline. This could also represent coordinates being added to our polyline from another source, such as a CLLocationManagerDelegate.
        ///timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(tick), userInfo: nil, repeats: true)
    }
    
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
    
    func updatePolylineWithCoordinates(coordinates: [CLLocationCoordinate2D]) {
        
        var mutableCoordinates = coordinates
        let polyline = MGLPolylineFeature(coordinates: &mutableCoordinates, count: UInt(mutableCoordinates.count))
        polylineSource?.shape = polyline
    }
}

extension ViewController:CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if locations.count > 0 {
            
            let currentLocation = locations.last
            
            if locationsArray.count == 0{
                
                locationsArray.append((locations.last?.coordinate)!)
                let latitude =  currentLocation?.coordinate.latitude
                let longitude = currentLocation?.coordinate.longitude
                initiateCurrentLocation(latitude: latitude!, longitude: longitude!)
                allCoordinates = locationsArray
                addPolyline(to: mglMapView.style!)
                animatePolyline()
                
            }else {
                
                let coordinate = CLLocation(latitude: (locationsArray.last?.latitude)!, longitude: (locationsArray.last?.longitude)!)
                let distanceInMeters = currentLocation?.distance(from: coordinate) as! Double
                if distanceInMeters >= 6.0 {
                
                    locationsArray.append((locations.last?.coordinate)!)
                    allCoordinates = locationsArray
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
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("\(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == .authorizedAlways {
            locationManager?.startUpdatingLocation()
        }
    }
    
}
