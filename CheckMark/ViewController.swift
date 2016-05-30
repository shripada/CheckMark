//
//  ViewController.swift
//  CheckMark
//
//  Created by Shripada Hebbar on 27/05/16.
//  Copyright © 2016 Shripada Hebbar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var checkMarkView: CheckMarkView!
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func animate(sender: AnyObject) {
        
        checkMarkView.animate()
    }
}

