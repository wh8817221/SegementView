//
//  ViewController.swift
//  SegementViewDemo
//  Copyright © 2018年 haoge. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var selectIndex: Int = 0
    fileprivate var currentIndex: Int = -1
    fileprivate var titles: [String]?
    fileprivate var arrVC:[UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "SegementViewDemo"
        titles = ["全部", "电影", "电视剧", "小说", "图片", "综艺节目", "体育节目"]
        segmentViewUI()
    }

    func segmentViewUI() {
        //创建控制器
        for index in 0..<(titles?.count)! {
            let randomColor = UIColor(red: CGFloat(arc4random()%255) / 255, green: CGFloat(arc4random()%255) / 255, blue: CGFloat(arc4random()%255) / 255, alpha: 1.0)
            let targetVC = TestViewController(text: (titles?[index])!, color: randomColor)
            arrVC.append(targetVC)
        }
        
        let segmentView = WHSegmentView(frame: CGRect.zero, arrTitle: titles!, viewControllers: arrVC, parentVc: self, isShowFilterButton: true)
        self.view.addSubview(segmentView)
        segmentView.snp.makeConstraints { (make) in
            make.right.left.equalTo(self.view)
            make.top.equalTo(self.topLayoutGuide.snp.bottom)
            make.bottom.equalTo(self.view)
        }
        segmentView.selectIndex(index: selectIndex, changeIndexCallback: { (value) in
            if let index = value as? Int {
                if self.currentIndex == index { return }
                self.currentIndex = index
                print("当前选择的角标:%d", index)
            }
        })
        segmentView.rightFilterButton.addTarget(self, action: #selector(filterButtonAction(_:)), for: .touchUpInside)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @objc fileprivate func filterButtonAction(_ sender: UIButton) {
        print("点击右边的过滤按钮")
    }
    
}

