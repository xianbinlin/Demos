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

class PreviewState: GKState {
    
    weak var vc:ViewController?
    
    init(vc:ViewController) {
        self.vc = vc
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return (stateClass is StartState.Type) || (stateClass is  NavigationState.Type)
    }
    
    override func didEnter(from previousState: GKState?) {
        // could evaluate UI state from previousState
        vc?.goButtonOutlet.isHidden = false
        vc?.cancelButtonOutlet.isHidden = true
        vc?.clearButtonOutlet.isHidden = false
        vc?.searchManager.resultSearchController?.view.isHidden = false
        
        vc?.dropPinZoomIn(placemark: (vc?.mapView.destinationLocation)!)
        vc?.mapView.findRout()

        
    }
    
    override func willExit(to nextState: GKState) {
        
    }
    
}
