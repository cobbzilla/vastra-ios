//
//  Constants.swift
//  Fitness Tracker
//
//  Created by Ravi TPSS on 24/04/19.
//  Copyright © 2019 Fitness Tracker. All rights reserved.
//

import Foundation
import UIKit

// These are the variables/constants which are accessible throughout the app
struct Constants {
    
    struct Global {
        // app Delegate object
        static let APPDEL = UIApplication.shared.delegate as! AppDelegate
        // viewcontext object of coredata
        static let VIEWCONTEXT = APPDEL.persistentContainer.viewContext
        // storyboard object
        static let STORYBOARD = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        // currently selected trektype default .Road
        static var selectedTrekType:TrekType = .Road
        // currently selected commutetype default = .Walk
        static var selectedComuteType:CommuteType = .Walk
    }
}

// types of trek
enum TrekType: String {
    case Road
    case Trail
}

// types of commute
enum CommuteType: String {
    case Walk
    case Run
    case Bike
}
