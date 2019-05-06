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

class ReviewWorkoutViewController: UIViewController, MGLMapViewDelegate {

    var workoutCoordinates:[CLLocationCoordinate2D] = []
    var workoutName = ""
    var timer: Timer?
    var polylineSource: MGLShapeSource?
    var currentIndex = 1
    var allCoordinates: [CLLocationCoordinate2D]!
    
    @IBOutlet weak var mglMapView: MGLMapView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        mglMapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        let latitude = allCoordinates.first?.latitude
        let longitude = allCoordinates.first?.longitude
        mglMapView.setCenter(
            CLLocationCoordinate2D(latitude: latitude ?? 100.0, longitude: longitude ?? 100.0),
            zoomLevel: 18,
            animated: false)
        mglMapView.delegate = self
    }
    
    @IBAction func saveWorkoutButtonTapped(_ sender: UIButton) {
        self.showInputDialog(title: "Workout Name",
                        subtitle: "Please enter name for the workout.",
                        actionTitle: "OK",
                        cancelTitle: "Cancel",
                        inputPlaceholder: "Workout Name",
                        inputKeyboardType: .default)
        { (input:String?) in
            
            self.workoutName = input ?? ""
            self.saveWorkoutDetail()
        }
    }
    
    @IBAction func newWorkoutButtonTapped(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func saveWorkoutDetail(){
        
        let entity = NSEntityDescription.entity(forEntityName: "Workout", in: Constants.Global.VIEWCONTEXT)
        
        let workout = NSManagedObject(entity: entity!, insertInto: Constants.Global.VIEWCONTEXT) as! Workout
        var trekType = "Trail"
        if Constants.Global.selectedTrekType == .Road {
            trekType = "Road"
        }
        
        var comuteType = "Walk"
        if Constants.Global.selectedComuteType == .Run {
            comuteType = "Run"
        }else {
            comuteType = "Bike"
        }
        
        workout.workoutName = workoutName
        workout.comuteType = comuteType
        workout.trekType = trekType
        workout.coordinates = workoutCoordinates
        
        do {
            try Constants.Global.VIEWCONTEXT.save()
            displayAlert()
            print("workout saved")
        } catch {
            print("error")
        }
    }
    
    func displayAlert(){
        
        let alert = UIAlertController(title: "Success", message: "Workout saved successfully", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: {( UIAlertAction ) in })
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
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
        timer = Timer.scheduledTimer(timeInterval: 0.005, target: self, selector: #selector(tick), userInfo: nil, repeats: true)
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
