//
//  StarProgressBar.swift
//  starprogress
//
//  Created by zouwei on 16/5/26.
//  Copyright © 2016年 zouwei. All rights reserved.
//

import UIKit

protocol StarProgressBarDelegate : NSObjectProtocol {
    
    func starProgressBarTouchBegin(starProgressBar: StarProgressBar, progress:CGFloat)
    
    func starProgressBarTouchMove(starProgressBar: StarProgressBar, progress:CGFloat)
    
    func starProgressBarTouchEnded(starProgressBar: StarProgressBar, progress:CGFloat)
}

public enum StarProgressBarType : Int {
    
    case Horizontal
    case Vertical
}

class StarProgressBar: UIView {
    
    lazy private var starViews=[StarView]()
    
    weak var delegate: StarProgressBarDelegate?{
        didSet{
            
        }
    }
    
    var starProgressBarType:StarProgressBarType=StarProgressBarType.Horizontal{
        didSet{
            self.setNeedsLayout()
        }
    };
    
    //星星的数量
    var starNum : Int = 1{
        didSet{
            starViews.removeAll();
            self.addStarView();
        }
    };
    //进度条的百分比
    var progress : CGFloat = 0.0 {
        didSet{
            if(progress<minProgress){
                progress=minProgress
            }else if(progress>1.0){
                progress=1.0
            }
            self.setNeedsLayout()
        }
    }
    var minProgress : CGFloat = 0.0 {
        didSet{
            if(minProgress<0.0){
                minProgress=0.0
            }else if(minProgress>1.0){
                minProgress=1.0
            }
            self.setNeedsLayout()
        }
    }
    
    //星星之间的间距
    var margin :CGFloat = 0.0 {
        didSet{
            
            self.setNeedsLayout()
        }
    }
    
    convenience init(){
        self.init(frame:CGRectZero)
    }
    //初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addStarView()
        
    }
    //添加starView
    func addStarView(){
        for _ in 0..<self.starNum{
            let starView=StarView()
            starView.backgroundColor=UIColor.whiteColor()
            starView.starViewType=StarViewType.Normal
            self .addSubview(starView)
            self.starViews.append(starView)
        }
    }
    //计算各控件位置
    func countFrame(){
        let starW:CGFloat=(self.starViews[0].image?.size.width)!;
        let starH:CGFloat=(self.starViews[0].image?.size.height)!;
        //计算每个星星的位置
        for i in 0..<self.starViews.count{
            let star=self.starViews[i]
            var starX:CGFloat=0.0;
            var starY:CGFloat=0.0;
            switch (self.starProgressBarType){
            case StarProgressBarType.Horizontal:
                starX=CGFloat(i)*(margin+starW);
            case StarProgressBarType.Vertical:
                starY=CGFloat(i)*(margin+starH);
            }
            star.frame=CGRectMake(starX, starY, starW, starH)
        }
        //计算控件本身的bound
        let lastStar=self.starViews[self.starViews.count-1]
        var width:CGFloat=0.0;
        var height:CGFloat=0.0;
        switch (self.starProgressBarType){
        case StarProgressBarType.Horizontal:
            width=lastStar.frame.maxX
            height=starH
        case StarProgressBarType.Vertical:
            width=starW
            height=lastStar.frame.maxY
        }
        
        self.bounds=CGRectMake(0, 0, width, height)
    }
    //根据参数设置星星的显示
    func setStarViewType(){
        let norSelectedW:CGFloat=self.progress*CGFloat(self.starViews.count)
        let minSelectedW:CGFloat=self.minProgress*CGFloat(self.starViews.count)
        var selectedW:CGFloat=0.0
        if(norSelectedW>0){
            selectedW=minSelectedW > norSelectedW ? minSelectedW : norSelectedW
        }
        for i in 0..<self.starViews.count{
            let star=self.starViews[i]
            let num=selectedW-CGFloat(i);
            if(num>0.5){
                star.starViewType=StarViewType.Selected
            }else if(num<=0.5&&num>0){
                star.starViewType=StarViewType.HalfSelected
            }else{
                star.starViewType=StarViewType.Normal
            }
        }
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.countFrame()
        self.setStarViewType()
    }
    //计算进度条的值
    func setTouchStarViewType(touches: Set<UITouch>){
        let touch = (touches as NSSet).anyObject()!
        let point = touch.locationInView(touch.view)
        var n:Int=0
        var pointXY=point.x
        var boundsWH=self.bounds.size.width
        switch (self.starProgressBarType){
        case StarProgressBarType.Horizontal:
            boundsWH=self.bounds.size.width
            pointXY=point.x
        case StarProgressBarType.Vertical:
            boundsWH=self.bounds.size.height
            pointXY=point.y
        }
        for i in 0..<self.starViews.count{
            let star=self.starViews[i]
            var starXY=star.frame.origin.x
            switch (self.starProgressBarType){
            case StarProgressBarType.Horizontal:
                starXY=star.frame.origin.x
            case StarProgressBarType.Vertical:
                starXY=star.frame.origin.y
            }
            
            if(CGRectContainsPoint(star.frame, point)){
                n=i;
                break;
            }else if(starXY>pointXY){
                n=i;
                break;
            }
        }
        let totalMargin:CGFloat=CGFloat(n)*self.margin
        self.progress=(pointXY-totalMargin)/(boundsWH-CGFloat(self.starViews.count-1)*self.margin)
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.setTouchStarViewType(touches)
        var progress:CGFloat=0.0
        if(self.progress>0.0){
            progress=self.progress>self.minProgress ? self.progress : self.minProgress
        }
        self.delegate?.starProgressBarTouchBegin(self, progress:progress)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.setTouchStarViewType(touches)
        var progress:CGFloat=0.0
        if(self.progress>0.0){
            progress=self.progress>self.minProgress ? self.progress : self.minProgress
        }
        self.delegate?.starProgressBarTouchEnded(self, progress:progress)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.setTouchStarViewType(touches)
        var progress:CGFloat=0.0
        if(self.progress>0.0){
            progress=self.progress>self.minProgress ? self.progress : self.minProgress
        }
        self.delegate?.starProgressBarTouchMove(self, progress:progress)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
