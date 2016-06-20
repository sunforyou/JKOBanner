//
//  JKOScrollView.swift
//  JKOBanner
//
//  Created by 宋旭 on 16/4/3.
//  Copyright © 2016年 sky. All rights reserved.
//

import UIKit

class JKOScrollView: UIView, UIScrollViewDelegate {
    
    //MARK: >>>>>>>>>>>>>>>>>>>>>>> 外部控制接口 <<<<<<<<<<<<<<<<<<<<<<<<<<
    /**
     轮播控制接口
     */
    //轮播开关
    var autoScrollEnabled: Bool = true
    //轮播间隔
    var autoScrollTimeInterval: Double = 2.0
    
    //MARK: >>>>>>>>>>>>>>>>>>>>>>>> 内部参数 <<<<<<<<<<<<<<<<<<<<<<<<<<<<
    /**
     本地数据
     */
    var myScrollView: UIScrollView!
    var myPageControl: UIPageControl!
    
    //本地图片
    private var localImageGroup: NSMutableArray = []
    //当前页数
    private var currentPicture: NSInteger = 0
    //当前scrollView的frame值
    private var pictureFrame: CGRect = CGRectZero
    //scrollView横坐标
    private var originXOfScrollView: CGFloat = 0.0
    
    private var timer: NSTimer?
    
    //MARK: >>>>>>>>>>>>>>>>>>>>>>>> 初始化数据 <<<<<<<<<<<<<<<<<<<<<<<<<<<
    init(frame: CGRect, images: NSMutableArray) {
        localImageGroup = images
        pictureFrame = frame
        super.init(frame: frame)
        contentMode = UIViewContentMode.ScaleToFill
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    ///构造工厂方法，方便外部调用
    class func createScrollViewWithFrame(frame: CGRect, imageGroup: NSMutableArray) -> (JKOScrollView) {
        
        let theView: JKOScrollView = JKOScrollView.init(frame: frame, images: imageGroup)
        
        theView.setupPageControl(frame)
        theView.setupScrollView(frame)
        
        theView.addSubview(theView.myScrollView)
        theView.addSubview(theView.myPageControl)
        
        theView.setupTimer()
        
        return theView
    }
    
    //MARK: >>>>>>>>>>>>>>>>>>>>>> 初始化scrollView <<<<<<<<<<<<<<<<<<<<<<<<
    ///初始化PageControl
    func setupPageControl(pageControlFrame: CGRect) {
        
        var thePageControlRect: CGRect = pageControlFrame
        thePageControlRect.origin.y    = pageControlFrame.origin.y + pageControlFrame.size.height - 36
        thePageControlRect.size.width  = pageControlFrame.size.width
        thePageControlRect.size.height = 36
        
        let pageControl: UIPageControl = UIPageControl.init(frame: thePageControlRect)
        
        pageControl.numberOfPages = localImageGroup.count
        pageControl.currentPage = currentPicture
        pageControl.hidesForSinglePage = true
        pageControl.currentPageIndicatorTintColor = UIColor.orangeColor()
        pageControl.pageIndicatorTintColor = UIColor.blackColor()
        pageControl.backgroundColor = UIColor.clearColor()
        
        myPageControl = pageControl
    }
    
    ///初始化ScrollView & ImageView
    func setupScrollView(scrollViewFrame: CGRect) {
        
        let scrollView: UIScrollView = UIScrollView.init(frame: scrollViewFrame)
        
        scrollView.delegate = self
        scrollView.backgroundColor = UIColor.whiteColor()
        scrollView.canCancelContentTouches = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.clipsToBounds = true
        scrollView.scrollEnabled = true
        scrollView.pagingEnabled = true
        scrollView.bounces = true
        
        for item in localImageGroup {
            
            let theImageView = UIImageView.init(frame: CGRectZero)
            theImageView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.6)
            theImageView.image = item as? UIImage
            var rect: CGRect = scrollViewFrame
            rect.origin.x = originXOfScrollView
            rect.origin.y = 0
            rect.size.width = scrollViewFrame.size.width
            rect.size.height = scrollViewFrame.size.height
            theImageView.frame = rect
            theImageView.contentMode = UIViewContentMode.ScaleToFill
            scrollView.addSubview(theImageView)
            //下一张图片的x坐标:
            originXOfScrollView += scrollView.frame.size.width
        }
        //设置滚动视图的位置
        scrollView.contentSize = CGSizeMake(originXOfScrollView, scrollViewFrame.size.height)
        
        myScrollView = scrollView
    }
    
    //MARK: >>>>>>>>>>>>>>>>>>>>>>>> 滚动功能实现 <<<<<<<<<<<<<<<<<<<<<<<<<<
    ///启动轮播
    func setupTimer() {
        if autoScrollEnabled {
            let timer = NSTimer.scheduledTimerWithTimeInterval(autoScrollTimeInterval,
                                                               target: self,
                                                               selector: #selector(JKOScrollView.autoScroll),
                                                               userInfo: nil,
                                                               repeats: true)
            self.timer = timer;
            NSRunLoop.mainRunLoop().addTimer(self.timer!, forMode: NSRunLoopCommonModes)
        }
    }
    
    ///轮播实现
    func autoScroll() {
        if autoScrollEnabled {
            let nextPage = (currentPicture + 1) % localImageGroup.count
            
            var rect: CGRect = pictureFrame
            rect.origin.x = CGFloat(nextPage) * pictureFrame.size.width
            rect.origin.y = 0
            myScrollView.scrollRectToVisible(rect, animated: true)
            
            currentPicture = nextPage
            myPageControl.currentPage = currentPicture
        }
    }
    
    //MARK: >>>>>>>>>>>>>>>>>>>> UIScrollViewDelegate <<<<<<<<<<<<<<<<<<<<<<<
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        //获取当前视图宽度
        let pageWidth = pictureFrame.size.width
        let page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1
        myPageControl.currentPage = NSInteger(page)
        currentPicture = NSInteger(page)
    }
    
    ///手势滑动停止轮播
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        if autoScrollEnabled {
            timer!.invalidate()
            timer = nil;
        }
    }
    
    ///手势结束继续轮播
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if autoScrollEnabled {
             setupTimer()
        }
    }
}
