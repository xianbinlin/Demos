//
//  ViewController.swift
//  DemoCartCollectionView
//
//  Created by xianbin lin on 2017/3/11.
//  Copyright © 2017年 lin. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIGestureRecognizerDelegate {

    
    @IBOutlet weak var horizontalEnterView: UIView!
    
    @IBOutlet weak var verticalEnterView: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setup()



        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("view appear")
//        setup()
    }
    
    
    func setup(){
        self.horizontalEnterView.layer.borderColor = UIColor.white.cgColor
        self.horizontalEnterView.layer.borderWidth = 2
        self.horizontalEnterView.layer.cornerRadius = 10
        self.horizontalEnterView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.tapHorizontalEnterView(_:)))
        tap.delegate = self
        self.horizontalEnterView.addGestureRecognizer(tap)

        
        verticalEnterView.layer.borderColor = UIColor.white.cgColor
        verticalEnterView.layer.borderWidth = 2
        verticalEnterView.layer.cornerRadius = 10
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(ViewController.tapVerticalEnterView))
        tap2.delegate = self
        verticalEnterView.addGestureRecognizer(tap2)
        
    }
    
    func tapHorizontalEnterView(_ recognizer:UITapGestureRecognizer){
        print("tapHorizontalEnterView")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier :"viewcontrol2") as! HorizontalViewController
        
        self.present(viewController, animated: true)     }
    
    
    func tapVerticalEnterView(){

    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

