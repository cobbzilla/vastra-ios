//
//  RatingViewController.swift
//  PopupDialog
//
//  Created by Martin Wildfeuer on 11.07.16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit

class RatingViewController: UIViewController {
    
    @IBOutlet weak var commentTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // sets RatingViewController as delegate of textField
        commentTextField.delegate = self
        // adds tapgesturerecognizer to view. when view is tapped then keyboard hides
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endEditing)))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Hides the keyboard
    @objc func endEditing() {
        view.endEditing(true)
    }
}

// RatingViewController extension as TextField Delegate
extension RatingViewController: UITextFieldDelegate {
    // Called when return button is tapped
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing()
        return true
    }
    // Called when textfield ends editing
    func textFieldDidEndEditing(_ textField: UITextField) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "WorkoutName"), object: nil, userInfo: ["workoutName":textField.text ?? ""])
    }
    
}
