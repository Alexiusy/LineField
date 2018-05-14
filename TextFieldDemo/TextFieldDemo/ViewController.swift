//
//  ViewController.swift
//  TextFieldDemo
//
//  Created by mac on 2018/4/25.
//  Copyright © 2018年 zeacone. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var first: LineField!
    
    @IBOutlet weak var second: LineField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        let btn = UIButton()
        btn.frame.size = CGSize(width: 35, height: 14.5)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        btn.setTitle("+86", for: .normal)
        btn.setTitleColor(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), for: .normal)
        btn.setTitleColor(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), for: .highlighted)
        btn.addTarget(self, action: #selector(selectArea(_:)), for: .touchUpInside)
        btn.titleEdgeInsets = UIEdgeInsets.zero
        
        self.first.leftView = btn
        self.first.leftViewMode = .always
    }
    
    @objc func selectArea(_ sender: UIButton) {
        print("Button clicked")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

