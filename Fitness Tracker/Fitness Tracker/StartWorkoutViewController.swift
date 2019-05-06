//
//  StartWorkoutViewController.swift
//  Fitness Tracker
//
//  Created by Ravi TPSS on 22/04/19.
//  Copyright © 2019 Fitness Tracker. All rights reserved.
//

import UIKit

class StartWorkoutViewController: UIViewController {

    @IBOutlet weak var roadButton: UIButton!
    @IBOutlet weak var trailButton: UIButton!
    @IBOutlet weak var runButton: UIButton!
    @IBOutlet weak var walkButton: UIButton!
    @IBOutlet weak var bikeButton: UIButton!
    @IBOutlet weak var letsGoButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateTrackTypeButton()
        updateComuteTypeButton()
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func roadButtonTapped(_ sender: UIButton) {
        Constants.Global.selectedTrekType = .Road
        updateTrackTypeButton()
    }
    
    @IBAction func trailButtonTapped(_ sender: UIButton) {
        Constants.Global.selectedTrekType = .Trail
        updateTrackTypeButton()
    }
    
    @IBAction func runButtonTapped(_ sender: UIButton) {
        Constants.Global.selectedComuteType = .Run
        updateComuteTypeButton()
    }
    
    @IBAction func walkButtonTapped(_ sender: UIButton) {
        Constants.Global.selectedComuteType = .Walk
        updateComuteTypeButton()
    }
    
    @IBAction func bikeButtonTapped(_ sender: UIButton) {
        Constants.Global.selectedComuteType = .Bike
        updateComuteTypeButton()
    }
    
    @IBAction func letsGoButtonTapped(_ sender: UIButton) {
    
        let viewController = Constants.Global.STORYBOARD.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func updateTrackTypeButton(){
        
        switch Constants.Global.selectedTrekType {
        case .Road:
            roadButton.backgroundColor = UIColor.lightGray
            trailButton.backgroundColor = UIColor.purple
        default:
            roadButton.backgroundColor = UIColor.purple
            trailButton.backgroundColor = UIColor.lightGray
        }
        
    }
    
    func updateComuteTypeButton(){
        
        switch Constants.Global.selectedComuteType {
        case .Walk:
            walkButton.backgroundColor = UIColor.blue
            runButton.backgroundColor = UIColor.orange
            bikeButton.backgroundColor = UIColor.orange
        case .Run:
            walkButton.backgroundColor = UIColor.orange
            runButton.backgroundColor = UIColor.blue
            bikeButton.backgroundColor = UIColor.orange
        default:
            walkButton.backgroundColor = UIColor.orange
            runButton.backgroundColor = UIColor.orange
            bikeButton.backgroundColor = UIColor.blue
        }
    }
}
