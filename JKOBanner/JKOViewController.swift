//
//  JKOViewController.swift
//  JKOBanner
//
//  Created by 宋旭 on 16/4/3.
//  Copyright © 2016年 sky. All rights reserved.
//

import UIKit

class JKOViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let images:NSMutableArray = [UIImage.init(named: "h1.jpg")!,
                                     UIImage.init(named: "h2.jpg")!,
                                     UIImage.init(named: "h3.jpg")!,
                                     UIImage.init(named: "h4.jpg")!,
                                     UIImage.init(named: "h5.jpg")!]
        
        let rect = CGRectMake(0, 0, 320, 480)
        
        let myScrollView = JKOScrollView.createScrollViewWithFrame(rect, imageGroup: images)
        
        //轮播开关 默认true
        //        myScrollView.autoScrollEnabled = false
        
        //轮播间隔 默认2.0s
        myScrollView.autoScrollTimeInterval = 2.5
        
        self.view.addSubview(myScrollView)
    }
}

