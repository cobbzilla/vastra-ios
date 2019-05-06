//
//  HomeViewController.swift
//  Fitness Tracker
//
//  Created by Ravi TPSS on 24/04/19.
//  Copyright © 2019 Fitness Tracker. All rights reserved.
//

import UIKit
import Mapbox

class HomeViewController: UIViewController {

    @IBOutlet weak var mglMapView: MGLMapView!
    @IBOutlet weak var startWorkoutButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        Constants.Global.selectedTrekType = .Road
        Constants.Global.selectedComuteType = .Walk
    }
    
    @IBAction func startWorkoutButtonTapped(_ sender: UIButton) {
        
        let startWorkoutViewController = Constants.Global.STORYBOARD.instantiateViewController(withIdentifier: "StartWorkoutViewController") as! StartWorkoutViewController
         self.navigationController?.pushViewController(startWorkoutViewController, animated: true)
    }
    
}
