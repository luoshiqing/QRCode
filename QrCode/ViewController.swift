//
//  ViewController.swift
//  QrCode
//
//  Created by sqluo on 2017/3/2.
//  Copyright © 2017年 sqluo. All rights reserved.
//

import UIKit



class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 30))
        btn.backgroundColor = UIColor.orange
        btn.setTitle("扫一扫", for: .normal)
        btn.center = self.view.center
        
        btn.addTarget(self, action: #selector(self.btnAct(_:)), for: .touchUpInside)
        
        self.view.addSubview(btn)
        
        
        
        //生成二维码
        let img = "我的qq号".creatQRCodeImage(size: 80)
        print(img.size)
        let imgView = UIImageView(frame: CGRect(x: 80, y: 80, width: 80, height: 80))
        imgView.image = img
        self.view.addSubview(imgView)
        
    }
    func btnAct(_ sender: UIButton) {
        
        let qrVC = QRCodeViewController()
        
        self.navigationController?.pushViewController(qrVC, animated: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}

