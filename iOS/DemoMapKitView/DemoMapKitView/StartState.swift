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

class StartState: GKState {
    
    weak var vc:ViewController?
    
    init(vc:ViewController) {
        self.vc = vc
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is PreviewState.Type
    }
    
    override func didEnter(from previousState: GKState?) {
        // could evaluate UI state from previousState
        vc?.goButtonOutlet.isHidden = true
        vc?.cancelButtonOutlet.isHidden = true
        vc?.clearButtonOutlet.isHidden = true
        vc?.navigationController?.isNavigationBarHidden = false
        vc?.setSearchBarText(text: "")
        if let annotations = vc?.mapView.annotations{
            vc?.mapView.removeAnnotations(annotations)
        }
        
        if let routes = vc?.mapView.overlays{
            vc?.mapView.removeOverlays(routes)
        }
        
        vc?.mapView.showUserLocation()
        
        
        

    }
    
    override func willExit(to nextState: GKState) {
        
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        print("update",seconds)
    }
    
    
}
