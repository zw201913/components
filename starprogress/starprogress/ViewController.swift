//
//  ViewController.swift
//  starprogress
//
//  Created by zouwei on 16/5/26.
//  Copyright © 2016年 zouwei. All rights reserved.
//

import UIKit

class ViewController: UIViewController,StarProgressBarDelegate {

    private weak var starProgressBar:StarProgressBar?
    
    private weak var label:UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let label=UILabel();
        self.label=label
        label.frame=CGRectMake(100, 100, 50,50)
        
        self.view .addSubview(label)
        
        let starProgressBar=StarProgressBar()
        self.starProgressBar=starProgressBar
        
        starProgressBar.margin=0
        starProgressBar.starNum=5
        starProgressBar.minProgress=0.2
        starProgressBar.progress=0.1
        
        starProgressBar.backgroundColor=UIColor.orangeColor()
        starProgressBar.frame=CGRectMake(10, 100, 300, 200)
        starProgressBar.delegate=self
        self.view .addSubview(starProgressBar)

    }
    
    func starProgressBarTouchBegin(starProgressBar: StarProgressBar, progress:CGFloat){
        self.label?.text=progress.description
    }
    
    func starProgressBarTouchMove(starProgressBar: StarProgressBar, progress:CGFloat){
        self.label?.text=progress.description
    }
    
    func starProgressBarTouchEnded(starProgressBar: StarProgressBar, progress:CGFloat){
        self.label?.text=progress.description
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

