//
//  HomeViewController.swift
//  Fitness Tracker
//
//  Created by Ravi TPSS on 24/04/19.
//  Copyright © 2019 Fitness Tracker. All rights reserved.
//

import UIKit
import Mapbox
import PopupDialog

class HomeViewController: UIViewController, MGLMapViewDelegate {

    /* Outlet to MGLMapView */
    @IBOutlet weak var mglMapView: MGLMapView!
    /* Outlet to Start Button */
    @IBOutlet weak var startWorkoutButton: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        mglMapView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        
        /* Set the initial value of Trek Type to TrekType.Road */
        Constants.Global.selectedTrekType = .Road
        
        /* Set the initial value of Commute Type to CommuteType.Walk */
        Constants.Global.selectedComuteType = CommuteType.Walk
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        addBorderCornerRadius()
    }
    
    func addBorderCornerRadius() {
        
        let buttonWidth = startWorkoutButton.frame.size.width
        startWorkoutButton.layer.cornerRadius = buttonWidth/2.0
        startWorkoutButton.layer.masksToBounds = false
        startWorkoutButton.layer.borderWidth = 2.0
        startWorkoutButton.layer.borderColor = UIColor.white.cgColor
    }
    
    
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
     Navigates to Start Workout Screen
     
     - Bound to Start Button
     
     - Parameter sender: The Start Button.
     
     - Throws: N/A
     
     - Returns: N/A.
     */
    
    @IBAction func startWorkoutButtonTapped(_ sender: UIButton) {
        
        let startWorkoutViewController = Constants.Global.STORYBOARD.instantiateViewController(withIdentifier: "StartWorkoutViewController") as! StartWorkoutViewController
        self.navigationController?.pushViewController(startWorkoutViewController, animated: true)
    }
    
    func displayPopup() {
        
        // Prepare the popup assets
        let title = "THIS IS THE DIALOG TITLE"
        let message = "This is the message section of the popup dialog default view"
        let image = UIImage(named: "pexels-photo-103290")
        
        // Create the dialog
        let popup = PopupDialog(title: title, message: message, image: image)
        
        // Create buttons
        let buttonOne = CancelButton(title: "CANCEL") {
            print("You canceled the car dialog.")
        }
        
        // This button will not the dismiss the dialog
        let buttonTwo = DefaultButton(title: "ADMIRE CAR", dismissOnTap: false) {
            print("What a beauty!")
        }
        
        let buttonThree = DefaultButton(title: "BUY CAR", height: 60) {
            print("Ah, maybe next time :)")
        }
        
        // Add buttons to dialog
        // Alternatively, you can use popup.addButton(buttonOne)
        // to add a single button
        popup.addButtons([buttonOne, buttonTwo, buttonThree])
        
        // Present dialog
        self.present(popup, animated: true, completion: nil)
    }
    
}
