//
//  CIImage+UIImage.swift
//  QrCode
//
//  Created by sqluo on 2017/3/2.
//  Copyright © 2017年 sqluo. All rights reserved.
//

import UIKit

extension String{
    
    func creatQRCodeImage(size: CGFloat) -> UIImage{
        
        let filter = CIFilter(name: "CIQRCodeGenerator")!
        
        filter.setDefaults()
        
        let data = self.data(using: String.Encoding.utf8)
        filter.setValue(data, forKey: "inputMessage")
        
        let ciImage = filter.outputImage!
        
        return ciImage.creatNonInterPolatedUIImage(size)
    }
}


extension CIImage{
    
    func creatNonInterPolatedUIImage(_ size: CGFloat) -> UIImage{
        
        let extent = self.extent.integral
        
        let scale: CGFloat = min(size/extent.width, size/extent.height)
        
        let width = extent.width * scale
        let height = extent.height * scale
        
        let cs = CGColorSpaceCreateDeviceGray()
        
        let bitmapRef = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: cs, bitmapInfo: 0)!
        
        let context = CIContext(options: nil)
        
        let bitmapImage = context.createCGImage(self, from: extent)
        
        bitmapRef.interpolationQuality = CGInterpolationQuality.none
        bitmapRef.scaleBy(x: scale, y: scale);
        
        
        
        bitmapRef.draw(bitmapImage!, in: extent)
        
        let scaledImage: CGImage = bitmapRef.makeImage()!
        
        return UIImage(cgImage: scaledImage)
    }
    
    
}
