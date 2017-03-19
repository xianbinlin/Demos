//
//  StateMachineManager.swift
//  DemoMapKitView
//
//  Created by xianbin lin on 2017/3/19.
//  Copyright © 2017年 lin. All rights reserved.
//

import Foundation
import GameplayKit

public class StateMachineMagager: GKStateMachine {
    
    init(forViewController vc:ViewController) {
        super.init(states: [
            StartState(vc: vc),
            PreviewState(vc: vc),
            NavigationState(vc: vc)])
        enter(StartState.self)
    }
    
    
    
    
}
