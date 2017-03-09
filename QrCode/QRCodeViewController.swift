//
//  QRCodeViewController.swift
//  QrCode
//
//  Created by sqluo on 2017/3/2.
//  Copyright © 2017年 sqluo. All rights reserved.
//

import UIKit
import AVFoundation


/*
 需要打开相机权限
 需要打开网络权限
 */

class QRCodeViewController: UIViewController ,AVCaptureMetadataOutputObjectsDelegate{

    deinit {
        print("QRCodeViewController->释放成功")
        
    }
    
    fileprivate var cameraView: QRBackgroundView?
    
    fileprivate let captureSession = AVCaptureSession()
    
    
    //记录扫描成功
    fileprivate var isQROK = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        
        
        cameraView = QRBackgroundView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.view.addSubview(cameraView!)
        
        //初始化
        self.initOutputAndInput()
        
    }
    
    //初始化扫描
    func initOutputAndInput(){
        //初始化捕捉设备（AVCaptureDevice），类型AVMdeiaTypeVideo
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        //申明流媒体输入
        var input: AVCaptureDeviceInput!
        //创建媒体数据输出流
        let output = AVCaptureMetadataOutput()
        
        //捕捉异常
        do{
            //创建输入流
            input = try AVCaptureDeviceInput(device: captureDevice)
            //把输入流添加到会话
            captureSession.addInput(input)
            //把输出流添加到会话
            captureSession.addOutput(output)
            
        }catch{
            print("异常")
            print(error)
            
            let alert = UIAlertView(title: "", message: "该设备不支持二维码扫描", delegate: nil, cancelButtonTitle: "确定")
            alert.show()
        }
        
        if input != nil{
            //创建串行队列
            let dispatchQueue = DispatchQueue(label: "queue")
            //设置输出流的代理
            output.setMetadataObjectsDelegate(self, queue: dispatchQueue)
            //设置输出媒体的数据类型
            output.metadataObjectTypes = [AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code]
            //创建预览图层
            let videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            //设置预览图层的填充方式
            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            //设置预览图层的frame
            videoPreviewLayer?.frame = self.cameraView!.bounds
            //将预览图层添加到预览视图上
            self.cameraView?.layer.insertSublayer(videoPreviewLayer!, at: 0)
            //设置扫描范围
            output.rectOfInterest = CGRect(x: 0.2, y: 0.2, width: 0.6, height: 0.6)
        }
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.scannerStart()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //释放定时器
        self.scannerStop()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //开始扫描
    fileprivate func scannerStart(){
        self.isQROK = false
        captureSession.startRunning()
        self.cameraView?.timeFire()
    }
    //停止扫描
    fileprivate func scannerStop(){
        captureSession.stopRunning()
        self.cameraView?.timeInvalidate()
    }

    
    
    //扫描代理
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        print("扫描代理---------")
        
        if self.isQROK == false{
            
            self.isQROK = true
            
            if metadataObjects != nil && metadataObjects.count > 0 {
                
                let metaData = metadataObjects.first as! AVMetadataMachineReadableCodeObject
                
                print(metaData.stringValue)
                
                DispatchQueue.main.async(execute: {
                    

                    
                    let alertCtl = UIAlertController(title: "试试", message: metaData.stringValue, preferredStyle: .alert)
                    
                    alertCtl.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.default, handler: { (act) in
                        self.isQROK = false
                    }))
                    
                    self.present(alertCtl, animated: true, completion: nil)
                    
                    
                    //其他处理，跳转界面
//                    self.scannerStop()
//                    let resultVC = WebViewController()
//                    resultVC.url = metaData.stringValue
//                    
//                    self.navigationController?.pushViewController(resultVC, animated: true)
                    
                })
            }
  
        }

    }
 
}
