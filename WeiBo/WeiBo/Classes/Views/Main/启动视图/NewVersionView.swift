//
//  NewVersionView.swift
//  WeiBo
//
//  Created by godyu on 2018/4/28.
//  Copyright © 2018年 godyu. All rights reserved.
//

import UIKit

class NewVersionView: UIView {

    var scrollView : UIScrollView!
    
    var pageControl : UIPageControl!
    
    var enterButton : UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func showHome() {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        }) { (finished) in
            self.removeFromSuperview()
        }
    }
    
}

extension NewVersionView {
    
     func setupUI() {
        setupScrollView()
        setupPageControl()
        setupEnterButton()
    }
    
    private func setupScrollView() {
        scrollView = UIScrollView.init(frame: self.bounds)
        scrollView.backgroundColor = UIColor.white.withAlphaComponent(0)
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        self.addSubview(scrollView!)
        scrollView.delegate = self
        
        for i in 0..<4 {
            let imageName = "35_\(i)"
            let image = UIImage.init(named: imageName)
            let x = CGFloat(i) * scrollView!.bounds.size.width
            let y = 0 as CGFloat
            let width = scrollView!.bounds.size.width
            let height = scrollView!.bounds.size.height
            let imageView = UIImageView.init(frame: CGRect.init(x: x, y: y, width: width, height: height))
            imageView.image = image
            scrollView!.addSubview(imageView)
        }
        scrollView!.contentSize = CGSize.init(width: UIScreen.screen_width() * 5, height: 0)
    }
    
    private func setupPageControl() {
        pageControl = UIPageControl.init()
        self.addSubview(pageControl)
        pageControl.backgroundColor = UIColor.clear
        pageControl.currentPageIndicatorTintColor = UIColor.orange
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.numberOfPages = 4
        pageControl.currentPage = 0
        pageControl.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.bottom.equalTo(self.snp.bottom).offset(-25)
            make.width.equalTo(100)
            make.height.equalTo(30)
        }
    }
    
    private func setupEnterButton() {
        enterButton  = UIButton.createButton(withText: "进入微博", fontSize: 17, normalTextColor: UIColor.white, highlightedColor: UIColor.lightGray)
        enterButton.backgroundColor = UIColor.orange
        enterButton.layer.borderWidth = 0
        enterButton.isHidden = true
        enterButton.layer.cornerRadius = 5
        enterButton.addTarget(self, action: #selector(showHome), for: .touchUpInside)
        self.addSubview(enterButton)
        enterButton.snp.makeConstraints({ (make) in
            make.centerX.equalTo(self)
            make.width.equalTo(100)
            make.height.equalTo(35)
            make.bottom.equalTo(self.snp.bottom).offset(-60)
        })
    }
}

extension NewVersionView : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / UIScreen.screen_width() + 0.5)
        pageControl.currentPage = page
        //滑动就隐藏
        enterButton.isHidden = true
        pageControl.isHidden = page == scrollView.subviews.count
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / UIScreen.screen_width())
        if page == scrollView.subviews.count - 1 {
            enterButton.isHidden = false
        }
        if page == scrollView.subviews.count {
            removeFromSuperview()
        }
    }
    
}

