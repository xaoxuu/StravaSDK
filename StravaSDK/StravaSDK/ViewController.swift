//
//  ViewController.swift
//  StravaSDK
//
//  Created by xaoxuu on 04/07/2017.
//  Copyright © 2017 xaoxuu. All rights reserved.
//

import UIKit


let appSchemes = "stravasdk"


class ViewController: UIViewController {

    
    @IBOutlet weak var clientId: UITextField!
    
    @IBOutlet weak var clientSecret: UITextField!
    
    @IBAction func authorize(_ sender: Any) {
        StravaSDK.authorize()
    }
    
    @IBAction func deauthorize(_ sender: Any) {
        StravaSDK.deauthorize()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        clientId.text = "18583"
        clientSecret.text = "a05fde98a830effde2e0f84cc39d76b040d4d67e"
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

