//
//  TestViewController.swift
//  SegementViewDemo
//
//  Created by 王浩 on 2018/5/16.
//  Copyright © 2018年 haoge. All rights reserved.
//

import UIKit
let randomColor = UIColor(red: CGFloat(arc4random()%255) / 255, green: CGFloat(arc4random()%255) / 255, blue: CGFloat(arc4random()%255) / 255, alpha: 1.0)
class TestViewController: UIViewController {

    convenience init(text: String) {
        self.init()
        let lbl = UILabel()
        lbl.text = text
        lbl.textAlignment = .center
        lbl.textColor = UIColor.red
        self.view.addSubview(lbl)
        lbl.snp.makeConstraints { (make) in
            make.centerX.centerY.equalTo(self.view)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = randomColor
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
