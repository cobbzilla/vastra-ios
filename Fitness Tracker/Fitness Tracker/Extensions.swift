//
//  Extensions.swift
//  Fitness Tracker
//
//  Created by Ravi TPSS on 24/04/19.
//  Copyright © 2019 Fitness Tracker. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable extension UIButton {
    // Set/Get the border width of button
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    // Set/Get corner radius of the button
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    // Set/Get border color of the button
    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
    // Set/Get shadow radius of the button
    @IBInspectable var shadowRadius: CGFloat {
        
        set {
            layer.shadowRadius = newValue
        }
        get {
            return layer.shadowRadius
        }
    }
    // Set/Get shadow offset of the button
    @IBInspectable var shadowOffset: CGSize {
        set {
            layer.shadowOffset = newValue
        }
        get {
            return layer.shadowOffset
        }
    }
    // Set/Get shadow color of the button
    @IBInspectable var shadowColor: UIColor? {
        set {
            guard let uiColorValue = newValue else { return }
            layer.shadowColor = uiColorValue.cgColor
        }
        get {
            guard let color = layer.shadowColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
    // Set/Get shadow opacity of the button
    @IBInspectable var shadowOpacity: Float {
        
        set {
            layer.shadowOpacity = newValue
        }
        get {
            return layer.shadowOpacity
        }
        
    }
}
