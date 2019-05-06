//
//  Constants.swift
//  Fitness Tracker
//
//  Created by Ravi TPSS on 24/04/19.
//  Copyright © 2019 Fitness Tracker. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    
    struct Global {
        static let APPDEL = UIApplication.shared.delegate as! AppDelegate
        static let VIEWCONTEXT = APPDEL.persistentContainer.viewContext
        static let STORYBOARD = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        static var selectedTrekType:TrekType = .Road
        static var selectedComuteType:CommuteType = .Walk
    }
    
}

enum TrekType{
    case Road
    case Trail
}

enum CommuteType{
    case Walk
    case Run
    case Bike
}

