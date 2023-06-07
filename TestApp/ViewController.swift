//
//  ViewController.swift
//  TestApp
//
//  Created by mac on 2021/05/18.
//

import UIKit

class ViewController: UIViewController {
    var flag = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        testMethod()
    }
    
    func testMethod() {
        if flag {
            NSLog("flag true")
        } else {
            NSLog("flag false")
        }
    }
}
