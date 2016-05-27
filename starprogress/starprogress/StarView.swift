//
//  StarView.swift
//  starprogress
//
//  Created by zouwei on 16/5/26.
//  Copyright © 2016年 zouwei. All rights reserved.
//

import UIKit

public enum StarViewType : Int {
    
    case Normal
    case HalfSelected
    case Selected
}


class StarView: UIImageView {

    var starViewType:StarViewType=StarViewType.Normal{
        didSet{
            switch (starViewType){
            case StarViewType.Normal:
                self.image=UIImage(named: "iconfont-xingunselected.png")
            case StarViewType.HalfSelected:
                self.image=UIImage(named: "iconfont-banxing.png")
            case StarViewType.Selected:
                self.image=UIImage(named: "iconfont-xing.png")
            }
        }
    };
    
    convenience init(){
        self.init(frame:CGRectZero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.starViewType=StarViewType.Normal
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}

