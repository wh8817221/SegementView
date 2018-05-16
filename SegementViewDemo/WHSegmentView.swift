//
//  WHSegmentView.swift
//  SegementViewDemo
//
//  Copyright © 2018年 haoge. All rights reserved.
//
import UIKit
import SnapKit
let screenHeight:CGFloat = UIScreen.main.bounds.height
let screenWidth:CGFloat = UIScreen.main.bounds.width
typealias ObjectCallback = (_ value: Any) -> Void

class WHSegmentView: UIView{
    //按钮文字大小 默认 13
    var buttonFont: UIFont = UIFont.systemFont(ofSize: 13)
    var buttonTextColor: UIColor = UIColor.gray
    var callback: ObjectCallback?
    fileprivate var viewControllers:[UIViewController]?
    fileprivate var arrTitle:[String]?
    fileprivate weak var parentVc: UIViewController?
    fileprivate var btnTag = 100
    fileprivate var isClick = false
    fileprivate var isFistEnter = true
    fileprivate var kWidthArr:[CGFloat] = []
    fileprivate var bWidthArr:[CGFloat] = []
    fileprivate var kPointArr:[CGFloat] = []
    fileprivate var bPointArr:[CGFloat] = []
    fileprivate var btnWidth:[CGFloat] = []
    fileprivate var btnCenter:[CGFloat] = []
    fileprivate var buttonMargin: CGFloat = 20
    
    lazy var rightFilterButton: UIButton =  {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named:"filter_button"), for: .normal)
        btn.backgroundColor = UIColor.white
        
        return btn
    }()
    
    fileprivate lazy var line: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray
        return view
    }()
    
    //右边过滤的按钮的宽度  默认 0
    fileprivate var rightFilterWidht: CGFloat = 0
    fileprivate lazy var topScrollView:UIScrollView = {
        let scroll = UIScrollView()
        scroll.delegate = self
        scroll.alwaysBounceHorizontal = true
        scroll.showsHorizontalScrollIndicator = false
        scroll.backgroundColor = UIColor.white
        return scroll
    }()
    
    fileprivate lazy var topAnotherScrollView:UIView = {
        let scroll = UIView()
        scroll.clipsToBounds = true
        return scroll
    }()
    
    fileprivate lazy var bottomView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.blue
        view.layer.cornerRadius = 2
        view.layer.masksToBounds = true
        return view
    }()
    
    fileprivate lazy var viewConrtollerScroll:UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsHorizontalScrollIndicator = false
        scroll.showsVerticalScrollIndicator = false
        scroll.alwaysBounceHorizontal = false
        scroll.alwaysBounceVertical = false
        scroll.bounces = false
        scroll.delegate = self
        scroll.isPagingEnabled = true
        return scroll
    }()
    
    fileprivate var dicForVC:[Int:UIViewController] = [:]
    
    fileprivate var currentPage:Int = -1 {
        didSet {
            if let vc = self.viewControllers {
                guard let _ = dicForVC[currentPage]  else {
                    dicForVC[currentPage] = vc[currentPage]
                    self.viewConrtollerScroll.addSubview(vc[currentPage].view)
                    self.parentVc?.addChildViewController(vc[currentPage])
                    vc[currentPage].view.snp.makeConstraints({ (make) in
                        make.left.equalTo(CGFloat(self.currentPage)*screenWidth)
                        make.top.equalTo(0)
                        make.size.equalTo(CGSize.init(width: screenWidth, height: self.bounds.size.height - 44))
                    })
                    return
                }
            }
        }
    }
    
    convenience init(frame: CGRect, arrTitle:[String], viewControllers:[UIViewController], parentVc: UIViewController, isShowFilterButton: Bool) {
        self.init(frame: frame)
        
        self.arrTitle = arrTitle
        self.viewControllers = viewControllers
        self.parentVc = parentVc
        if isShowFilterButton {
            rightFilterWidht = 44.0
        } else {
            rightFilterWidht = 0.0
        }
        createUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        guard let viewControllers = viewControllers,viewControllers.count > 0 else {return}
        super.layoutSubviews()
        let width = CGFloat(viewControllers.count)*screenWidth
        let height = self.bounds.size.height  - 88
        viewConrtollerScroll.contentSize = CGSize.init(width: width, height: height)
        
        for (_,vc) in dicForVC {
            vc.view.snp.updateConstraints({ (make) in
                make.size.equalTo(CGSize.init(width: screenWidth, height: self.bounds.size.height - 44))
            })
        }
    }
    
    func createUI() {
        guard let viewControllers = viewControllers,viewControllers.count > 0 else {return}
        self.addSubview(rightFilterButton)
        rightFilterButton.snp.makeConstraints { (make) in
            make.right.equalTo(self.snp.right)
            make.top.equalTo(self.snp.top)
            make.width.equalTo(rightFilterWidht)
            make.height.equalTo(44)
        }
        
        self.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.top.equalTo(rightFilterButton.snp.top).offset(5)
            make.bottom.equalTo(rightFilterButton.snp.bottom).offset(-5)
            make.right.equalTo(rightFilterButton.snp.left).offset(1)
            make.width.equalTo(1)
        }
        
        self.addSubview(topScrollView)
        topScrollView.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left)
            make.top.equalTo(0)
            make.right.equalTo(rightFilterButton.snp.left)
            make.height.equalTo(44)
        }
        //计算按钮间距
        calculateButtonMargin()
        //创建按钮
        createtopScrollBtn()
        topScrollView.addSubview(topAnotherScrollView)
        createtopAnotherScrollBtn()
        topAnotherScrollView.addSubview(bottomView)
        bottomView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(topAnotherScrollView)
            make.height.equalTo(4)
        }
        
        let width = CGFloat(viewControllers.count)*screenWidth
        let height = self.bounds.size.height  - 88
        viewConrtollerScroll.contentSize = CGSize.init(width: width, height: height)
        self.addSubview(viewConrtollerScroll)
        viewConrtollerScroll.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self)
            make.top.equalTo(self.topScrollView.snp.bottom)
        }
        xianXinHanShu()
    }
    
    public func xianXinHanShu() {
        guard let arrTitle = arrTitle else {return}
        
        for index in 0..<arrTitle.count - 1 {
            let startPointX = btnCenter[index] - btnWidth[index]/2
            let endPointX = btnCenter[index+1] + btnWidth[index+1]/2
            let distance = endPointX - startPointX
            let midpointX =  startPointX + distance/2
            let width = screenWidth
            let k1 = 2*(distance - btnWidth[index])/width
            let b1 = btnWidth[index] - k1 * CGFloat(2*index) * width/2
            kWidthArr.append(k1)
            bWidthArr.append(b1)
            
            let k2 = 2*( btnWidth[index+1] - distance )/width
            let b2 = distance - k2 * CGFloat(2*index+1) * width/2
            kWidthArr.append(k2)
            bWidthArr.append(b2)
            
            let k11 = 2*(midpointX - btnCenter[index])/width
            let b11 = btnCenter[index] - k11 * CGFloat(2*index)*width/2
            kPointArr.append(k11)
            bPointArr.append(b11)
            
            let k22 = 2*( btnCenter[index+1] - midpointX )/width
            let b22 = midpointX - k22 * CGFloat(2*index+1)*width/2
            kPointArr.append(k22)
            bPointArr.append(b22)
            
        }
    }
    //MARK:-计算按钮间距
    fileprivate func calculateButtonMargin() {
        guard let arrTitle = arrTitle else {return}
        var widthTotal:CGFloat = 0
        for (_,title) in arrTitle.enumerated() {
            let width = (title as NSString).size(withAttributes: [NSAttributedStringKey.font:buttonFont]).width
            widthTotal += width
        }
        
        if (widthTotal+CGFloat(arrTitle.count)*buttonMargin) > screenWidth {
            //大于的时候取默认值
            //            print("大于的时候取默认值")
        } else {
            buttonMargin = (screenWidth-widthTotal)/CGFloat(arrTitle.count)
        }
        
    }
    
    public func createtopScrollBtn() {
        guard let arrTitle = arrTitle else {return}
        var tempBtn:UIButton?
        var widthTotal:CGFloat = 0
        for (index,title) in arrTitle.enumerated() {
            let btn = UIButton()
            btn.tag = self.btnTag + index
            btn.setTitle(title, for: .normal)
            btn.setTitleColor(buttonTextColor, for: .normal)
            btn.titleLabel?.font = buttonFont
            btn.titleLabel?.textAlignment = .center
            btn.addTarget(self, action: #selector(btnSelector(btn:)), for: .touchUpInside)
            topScrollView.addSubview(btn)
            let width = (title as NSString).size(withAttributes: [NSAttributedStringKey.font:buttonFont]).width
            btnWidth.append(width+buttonMargin)
            btnCenter.append((width+buttonMargin)/2+widthTotal)
            widthTotal += width + buttonMargin
            btn.snp.makeConstraints { (make) in
                if let tempBtn = tempBtn {
                    make.left.equalTo(tempBtn.snp.right)
                }else {
                    make.left.equalTo(0)
                }
                make.top.equalTo(0)
                make.width.equalTo(width+buttonMargin)
                make.height.equalTo(44)
            }
            
            tempBtn = btn
            topScrollView.contentSize = CGSize.init(width: widthTotal, height: 44)
        }
        
        
    }
    //MARK:-选中的位置
    func selectIndex(index:Int, changeIndexCallback: ObjectCallback?) {
        self.callback = changeIndexCallback
        self.layoutIfNeeded()
        self.selectButton(tag: index)
    }
    
    func selectButton(tag: Int) {
        if let btn = topScrollView.viewWithTag(tag + self.btnTag) as? UIButton {
            btnSelector(btn: btn)
        }
    }
    
    @objc func btnSelector(btn:UIButton){
        let btnCenterX = btn.center.x
        let topScrollWidth = topScrollView.frame.size.width
        let topScrollConsizeWidth = topScrollView.contentSize.width
        
        if btnCenterX < topScrollWidth/2 {
            topScrollView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
        }else if btnCenterX + topScrollWidth/2 < topScrollConsizeWidth {
            topScrollView.setContentOffset(CGPoint.init(x: btnCenterX-topScrollWidth/2, y: 0), animated: true)
            
        }else {
            topScrollView.setContentOffset(CGPoint.init(x: topScrollConsizeWidth-topScrollWidth, y: 0), animated: true)
        }
        isClick = true
        topAnotherScrollView.snp.updateConstraints { (make) in
            make.centerX.equalTo(self.topScrollView.snp.left).offset(btnCenterX)
            make.width.equalTo(btn.frame.width - 8)
        }
        if btn.tag==self.btnTag {
            //强制滚动一下
            viewConrtollerScroll.contentOffset.x = 1
            viewConrtollerScroll.contentOffset.x = 0
        } else {
            viewConrtollerScroll.contentOffset.x = CGFloat(btn.tag - self.btnTag)*screenWidth
        }
        
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
        
        self.callback?(self.currentPage)
    }
    
    public func createtopAnotherScrollBtn() {
        guard let arrTitle = arrTitle,arrTitle.count > 0 else {return}
        
        let widthFirst = (arrTitle[0] as NSString).size(withAttributes: [NSAttributedStringKey.font:buttonFont]).width
        topAnotherScrollView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.centerX.equalTo(self.topScrollView.snp.left).offset((widthFirst+buttonMargin)/2)
            make.width.equalTo(widthFirst + buttonMargin - 8)
            make.height.equalTo(44)
        }
        
        var tempBtn:UIButton?
        var widthTotal:CGFloat = 0
        for title in arrTitle {
            let btn = UIButton()
            btn.setTitle(title, for: .normal)
            btn.setTitleColor(UIColor.blue, for: .normal)
            btn.titleLabel?.font = buttonFont
            btn.titleLabel?.textAlignment = .center
            topAnotherScrollView.addSubview(btn)
            let width = (title as NSString).size(withAttributes: [NSAttributedStringKey.font:buttonFont]).width
            widthTotal += width + buttonMargin
            btn.snp.makeConstraints { (make) in
                if let tempBtn = tempBtn {
                    make.left.equalTo(tempBtn.snp.right)
                }else {
                    make.left.equalTo(self.topScrollView.snp.left)
                }
                make.top.equalTo(0)
                make.width.equalTo(width+buttonMargin)
                make.height.equalTo(44)
            }
            tempBtn = btn
        }
    }
    
    fileprivate func widthInfor(offsetX:CGFloat) -> CGFloat {
        if kPointArr.count == 0 || bPointArr.count == 0{
            return 0
        }
        var index = Int(offsetX*1.999/self.frame.width)
        if index >= kPointArr.count {
            index = kPointArr.count - 1
        }
        let k = kWidthArr[index]
        let b = bWidthArr[index]
        return k*offsetX + b
    }
    
    fileprivate func centerInfor(offsetX:CGFloat) -> CGFloat {
        if kPointArr.count == 0 || bPointArr.count == 0{
            return 0
        }
        var index = Int(offsetX*1.999/self.frame.width)
        if index >= kPointArr.count {
            index = kPointArr.count - 1
        }
        
        let k = kPointArr[index]
        let b = bPointArr[index]
        
        return k*offsetX + b
    }
}

extension WHSegmentView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == viewConrtollerScroll {
            if scrollView.contentOffset.x < 0 || scrollView.contentOffset.x > scrollView.contentSize.width - topScrollView.frame.width {
                return
            }
            self.currentPage  = Int((scrollView.contentOffset.x + screenWidth/2)/screenWidth)
            //第一次进入回调位置
            if isFistEnter {
                self.callback?(self.currentPage)
                isFistEnter = false
            }
            
            if isClick {
                isClick = false
                return
            }
            
            topAnotherScrollView.snp.updateConstraints({ (make) in
                make.centerX.equalTo(self.topScrollView.snp.left).offset(self.centerInfor(offsetX: scrollView.contentOffset.x))
                make.width.equalTo(self.widthInfor(offsetX: scrollView.contentOffset.x) - 8)
            })
            
            let  btnCenterX = self.centerInfor(offsetX: scrollView.contentOffset.x)
            let  topScrollWidth = topScrollView.frame.width
            let topScrollConsizeWidth = topScrollView.contentSize.width
            if btnCenterX < topScrollWidth/2 {
                topScrollView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
            }else if btnCenterX + topScrollWidth/2 < topScrollConsizeWidth {
                topScrollView.setContentOffset(CGPoint.init(x: btnCenterX-topScrollWidth/2, y: 0), animated: true)
                
            }else {
                topScrollView.setContentOffset(CGPoint.init(x: topScrollConsizeWidth-topScrollWidth, y: 0), animated: true)
            }
        }
    }
    
    //MARK: - scrollView delegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == viewConrtollerScroll {
            self.callback?(self.currentPage)
        }
    }
    
}
