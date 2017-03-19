//
//  ViewController.swift
//  DemoMapKitView
//
//  Created by xianbin lin on 2017/3/13.
//  Copyright © 2017年 lin. All rights reserved.
//

import UIKit
import MapKit
import GameplayKit

enum StateCase{
    case start,preview,navigation
    
    func getSelf()->AnyClass{
        switch self {
        case .start:
            return StartState.self
        case .preview:
            return PreviewState.self
        case .navigation:
            return NavigationState.self
        }
    }
}




class ViewController: UIViewController {

    @IBOutlet weak var goButtonOutlet: UIButton!{
        didSet{
            goButtonOutlet.layer.borderWidth = 3
            goButtonOutlet.layer.borderColor = UIColor.brown.cgColor
        }
    }
    
    @IBOutlet weak var clearButtonOutlet: UIButton!{
        didSet{
            clearButtonOutlet.layer.borderWidth = 3
            clearButtonOutlet.layer.borderColor = UIColor.brown.cgColor
        }
    }
    
    
    @IBOutlet weak var cancelButtonOutlet: UIButton!{
        didSet{
            cancelButtonOutlet.layer.borderWidth = 3
            cancelButtonOutlet.layer.borderColor = UIColor.brown.cgColor
        }
    }
    
    @IBOutlet weak var mapView: MapViewManager!
    var searchManager:SearchMananer!
    var stateMachine:StateMachineMagager!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchManager = SearchMananer()
        searchManager.vcDelegate = self
        searchManager.locationSearchTable.vcDelegate = self
        stateMachine = StateMachineMagager(forViewController: self)
        navigationItem.titleView = searchManager.resultSearchController?.searchBar
        definesPresentationContext = true

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mapView.vcDelegate = self
      
        mapView.setup()
        mapView.requestAuth()
        
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        mapView.stop()
    }
    
    
    // actions
    @IBAction func tapClean(_ sender: UIButton) {
        enterNextState(state: StateCase.start.getSelf())
    }
    
    @IBAction func tapGo(_ sender: UIButton) {
        enterNextState(state: StateCase.navigation.getSelf())
    }
    
    
    @IBAction func tapCancle(_ sender: UIButton) {
        enterNextState(state: StateCase.start.getSelf())
    }


}


protocol ViewControllerDelegate:class {
    func presentViewController(vc:UIViewController)
    func searchMapItems(address:String,completer:@escaping (_ mapItems:[MKMapItem])->())
    func dropPinZoomIn(placemark:MKPlacemark)
    func enterNextState(state:AnyClass)
    func setSearchBarText(text:String)
    func setDestination(placemark:MKPlacemark)
}

extension ViewController:ViewControllerDelegate{
    func presentViewController(vc:UIViewController){
        self.present(vc, animated: true, completion: nil)
    }
    
    func dropPinZoomIn(placemark: MKPlacemark) {
        mapView.dropPinZoomIn(placemark: placemark)
    }
    
    func searchMapItems(address: String, completer: @escaping ([MKMapItem]) -> ()) {
        mapView.searchMapItems(address: address, completer: completer)
    }
    
    func enterNextState(state: AnyClass) {
        stateMachine.enter(state)
    }
    
    func setSearchBarText(text: String) {
        searchManager.resultSearchController?.searchBar.text = text
    }
    
    func setDestination(placemark: MKPlacemark) {
        mapView.destinationLocation = placemark
    }
    
}








