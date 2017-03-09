//
//  QRBackgroundView.swift
//  QrCode
//
//  Created by sqluo on 2017/3/2.
//  Copyright © 2017年 sqluo. All rights reserved.
//

import UIKit

class QRBackgroundView: UIView {

    deinit {
        print("QRBackgroundView->释放成功")
    }
    
    
    //屏幕扫描区域视图
    fileprivate var scanView: UIView?
    //扫描线
    fileprivate var scanLine: UIImageView?
    //定时器
    fileprivate var timer: Timer!
    //扫描一次的时间
    fileprivate var duration: TimeInterval = 2.0
    //控制扫描线条上下移动
    fileprivate var isScanLineTop = true
    
    //MARK:需要在其 控制器消失时调用，否则该视图不能释放
    public func timeInvalidate(){
        if self.timer != nil{
            self.timer.invalidate()
            self.timer = nil
        }
    }
    
    public func timeFire(){
        
        if self.timer != nil {
            self.timer.invalidate()
            self.timer = nil
        }
        
        timer = Timer.scheduledTimer(timeInterval: duration, target: self, selector: #selector(self.moveScanLine(_:)), userInfo: nil, repeats: true)
        timer.fire() //立即开始
    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        //扫描视图
        let rect = CGRect(x: 0, y: 0, width: self.frame.width * 0.6, height: self.frame.width * 0.6)
        scanView = UIView(frame: rect)
        scanView?.center = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        scanView?.layer.borderColor = UIColor.orange.cgColor
        scanView?.layer.borderWidth = 1

        self.addSubview(scanView!)
        //扫描线条
        scanLine = UIImageView(frame: CGRect(x: 0, y: 0, width: scanView!.frame.width, height: 5))
        scanLine?.image = UIImage(named: "QRCodeScanLine")
        scanView?.addSubview(scanLine!)
        //四周视图
        self.createBackGroundView()
        //定时器
//        self.timeFire()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    fileprivate func createBackGroundView(){
        
        let alpha: CGFloat = 0.4
        
        //扫描视图的frame
        let frame = self.scanView!.frame
        //1.上
        let topView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: frame.origin.y))
        topView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: alpha)
        self.addSubview(topView)
        //2.下
        let bottomY = frame.origin.y + frame.height
        let bottomView = UIView(frame: CGRect(x: 0, y: bottomY, width: self.frame.width, height: self.frame.height - bottomY))
        bottomView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: alpha)
        self.addSubview(bottomView)
        //3.左
        let leftView = UIView(frame: CGRect(x: 0, y: topView.frame.height, width: frame.origin.x, height: self.frame.height - topView.frame.height - bottomView.frame.height))
        leftView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: alpha)
        self.addSubview(leftView)
        //4.右
        let rightX = frame.origin.x + frame.width
        let rightView = UIView(frame: CGRect(x: rightX, y: topView.frame.height, width: self.frame.width - rightX, height: self.frame.height - topView.frame.height - bottomView.frame.height))
        rightView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: alpha)
        self.addSubview(rightView)
        
        //5.文字
        let label = UILabel(frame: CGRect(x: 0, y: 10, width: bottomView.frame.width, height: 21))
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.white
        label.text = "将二维码/条形码放入扫描框内，即自动扫描"
        
        bottomView.addSubview(label)
        
    }
    
    
    
    
    
    //扫描线移动
    @objc fileprivate func moveScanLine(_ timer: Timer){
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveLinear, animations: {
            if self.isScanLineTop{
                self.scanLine?.frame.origin.y = self.scanView!.frame.height - self.scanLine!.frame.height
            }else{
                self.scanLine?.frame.origin.y = 0
            }
            self.isScanLineTop = !self.isScanLineTop
        }, completion: nil)
   
    }
    

}
