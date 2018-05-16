//
//  TestViewController.swift
//  SegementViewDemo
//  Copyright © 2018年 haoge. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

    convenience init(text: String, color: UIColor) {
        self.init()
        let lbl = UILabel()
        lbl.text = text
        lbl.textAlignment = .center
        lbl.textColor = UIColor.white
        self.view.addSubview(lbl)
        lbl.snp.makeConstraints { (make) in
            make.centerX.centerY.equalTo(self.view)
        }
        self.view.backgroundColor = color
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
