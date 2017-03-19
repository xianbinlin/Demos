//
//  StartState.swift
//  DemoMapKitView
//
//  Created by xianbin lin on 2017/3/18.
//  Copyright © 2017年 lin. All rights reserved.
//  

import Foundation
import GameplayKit
import UIKit

class NavigationState: GKState {
    
    weak var vc:ViewController?
    
    init(vc:ViewController) {
        self.vc = vc
    }
      
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return (stateClass is StartState.Type)
    }
    
    override func didEnter(from previousState: GKState?) {
        // could evaluate UI state from previousState
        vc?.goButtonOutlet.isHidden = true
        vc?.cancelButtonOutlet.isHidden = false
        vc?.clearButtonOutlet.isHidden = true
        vc?.navigationController?.isNavigationBarHidden = true
        
        vc?.mapView.userTrackingMode = .followWithHeading
        vc?.mapView.showUserLocation()
        
        
    }
    
    override func willExit(to nextState: GKState) {
        
    }
    
    
}
