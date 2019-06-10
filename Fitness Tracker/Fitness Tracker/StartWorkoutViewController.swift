//
//  StartWorkoutViewController.swift
//  Fitness Tracker
//
//  Created by Ravi TPSS on 22/04/19.
//  Copyright © 2019 Fitness Tracker. All rights reserved.
//

import UIKit
import Mapbox

class StartWorkoutViewController: UIViewController,MGLMapViewDelegate {
    
    /* Outlet to MGLMapView */
    @IBOutlet weak var mglMapView: MGLMapView!
    /* Outlet to Road Button */
    @IBOutlet weak var roadButton: UIButton!
    /* Outlet to Trail Button */
    @IBOutlet weak var trailButton: UIButton!
    /* Outlet to Run Button */
    @IBOutlet weak var runButton: UIButton!
    /* Outlet to Walk Button */
    @IBOutlet weak var walkButton: UIButton!
    /* Outlet to Bike Button */
    @IBOutlet weak var bikeButton: UIButton!
    /* Outlet to Let's Go Button */
    @IBOutlet weak var letsGoButton: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        mglMapView.delegate = self
        updateTrekTypeButton()
        updateComuteTypeButton()
    }
    
    /**
        This method gives the current location of the user
     
     - Bound to : N/A
     
     - Parameter : MGLMapView object, updated userLocation
     
     - Throws: N/A
     
     - Returns: N/A.
     */
    
    func mapView(_ mapView: MGLMapView, didUpdate userLocation: MGLUserLocation?) {
        
        initiateCurrentLocation(location: (userLocation?.coordinate)!)
    }
    
    /**
     This method is used to zoom to the current location of the device
     
     - Bound to : N/A
     
     - Parameter sender: N/A
     
     - Throws: N/A
     
     - Returns: N/A.
     */
    
    func initiateCurrentLocation(location:CLLocationCoordinate2D) {
        
        mglMapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mglMapView.userTrackingMode = .follow
        mglMapView.setCenter(
            location,
            zoomLevel: 15,
            animated: false)
    }
    
    /**
     Navigates back to Home Screen
     
     - Bound to Back Button
     
     - Parameter sender: The Back Button.
     
     - Throws: N/A
     
     - Returns: N/A.
     */
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    /**
     Sets the value of Global Constant selectedTrekType = TrekType.Road
     Calls the updateTrekTypeButton() function
     
     - Bound to Road Button
     
     - Parameter sender: The Road Button.
     
     - Throws: N/A
     
     - Returns: N/A.
     */
    
    @IBAction func roadButtonTapped(_ sender: UIButton) {
        
        Constants.Global.selectedTrekType = .Road
        updateTrekTypeButton()
    }
    
    /**
     Sets the value of Global Constant selectedTrekType = TrekType.Trail
     Calls the updateTrekTypeButton() function
     
     - Bound to Trail Button
     
     - Parameter sender: The Trail Button.
     
     - Throws: N/A
     
     - Returns: N/A.
     */
    
    @IBAction func trailButtonTapped(_ sender: UIButton) {
        
        Constants.Global.selectedTrekType = .Trail
        updateTrekTypeButton()
    }
    
    /**
     Sets the value of Global Constant selectedTrekType = CommuteType.Run
     Calls the updateComuteTypeButton() function
     
     - Bound to Run Button
     
     - Parameter sender: The Run Button.
     
     - Throws: N/A
     
     - Returns: N/A.
     */
    
    @IBAction func runButtonTapped(_ sender: UIButton) {
        
        Constants.Global.selectedComuteType = .Run
        updateComuteTypeButton()
    }
    
    /**
     Sets the value of Global Constant selectedTrekType = CommuteType.Walk
     Calls the updateComuteTypeButton() function
     
     - Bound to Walk Button
     
     - Parameter sender: The Walk Button.
     
     - Throws: N/A
     
     - Returns: N/A.
     */
    
    @IBAction func walkButtonTapped(_ sender: UIButton) {
        
        Constants.Global.selectedComuteType = .Walk
        updateComuteTypeButton()
    }
    
    /**
     Sets the value of Global Constant selectedTrekType = CommuteType.Bike
     Calls the updateComuteTypeButton() function
     
     - Bound to Bike Button
     
     - Parameter sender: The Bike Button.
     
     - Throws: N/A
     
     - Returns: N/A.
     */
    
    @IBAction func bikeButtonTapped(_ sender: UIButton) {
        
        Constants.Global.selectedComuteType = .Bike
        updateComuteTypeButton()
    }
    
    /**
     Navigates to Active Workout Screen
     
     - Bound to Let's Go Button
     
     - Parameter sender: The Let's Go Button.
     
     - Throws: N/A
     
     - Returns: N/A.
     */
    
    @IBAction func letsGoButtonTapped(_ sender: UIButton) {
    
        let viewController = Constants.Global.STORYBOARD.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    /**
     Updates the Trek Type Buttons State
     Checks the current selected Trek Type and makes the corresponding button highlighted
     
     - Parameter: N/A
     
     - Throws: N/A
     
     - Returns: N/A.
     */
    
    func updateTrekTypeButton(){
        
        roadButton.layer.borderColor = UIColor.clear.cgColor
        trailButton.layer.borderColor = UIColor.clear.cgColor
        
        switch Constants.Global.selectedTrekType {
        case .Road:
            roadButton.layer.borderColor = UIColor.white.cgColor
        default:
            trailButton.layer.borderColor = UIColor.white.cgColor
        }
    }
    
    /**
     Updates the Comute Type Buttons State
     Checks the current selected Comute Type and makes the corresponding button highlighted
     
     - Parameter: N/A
     
     - Throws: N/A
     
     - Returns: N/A.
     */
    
    func updateComuteTypeButton(){
        
        walkButton.layer.borderColor = UIColor.clear.cgColor
        runButton.layer.borderColor = UIColor.clear.cgColor
        bikeButton.layer.borderColor = UIColor.clear.cgColor
        
        switch Constants.Global.selectedComuteType {
        case .Walk:
            walkButton.layer.borderColor = UIColor.orange.cgColor
        case .Run:
            runButton.layer.borderColor = UIColor.orange.cgColor
        default:
            bikeButton.layer.borderColor = UIColor.orange.cgColor
        }
    }
}
