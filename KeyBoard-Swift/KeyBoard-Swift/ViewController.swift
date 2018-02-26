//
//  ViewController.swift
//  KeyBoard-Swift
//
//  Created by yangqianhua on 2018/2/26.
//  Copyright © 2018年 yangqianhua. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textfield: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let kv = KeyBoardView.init()
        self.textfield.inputView = kv
        kv.inputSource = self.textfield
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

