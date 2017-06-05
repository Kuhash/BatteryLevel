//
//  UIImageExtension.swift
//  BatteryLevel
//
//  Created by Maciej Kucharski on 05/06/2017.
//  Copyright © 2017 Maciej Kucharski. All rights reserved.
//

import UIKit

extension UIImage {
    
    public class func drawBattery(size: CGSize, percentageCover: Float, cornerRadius: Float) -> UIImage {
        
        let renderer = UIGraphicsImageRenderer(size: size)
        
        let image = renderer.image { _ in
            
            let bgColor = UIColor(red: 0.294, green: 0.40, blue: 0.556, alpha: 1.000)
            let greenColor = UIColor(red: 0.303, green: 0.850, blue: 0.390, alpha: 1.000)
            let redColor = UIColor(red: 0.709, green: 0.007, blue: 0.011, alpha: 1.000)
            
            let bodyWidth = size.width * 0.955
            let bodyHeight = size.height
            
            let capWidth = size.width - bodyWidth - bodyWidth * 0.014
            let capHeigth = bodyHeight * 0.35
            let capX = bodyWidth + bodyWidth * 0.014
            let capY = (size.height - capHeigth)/2
            
            // background coverage
            let rectanglePath = UIBezierPath(roundedRect: CGRect(x: 0,
                                                                 y: 0,
                                                                 width: bodyWidth,
                                                                 height: bodyHeight),
                                             cornerRadius: CGFloat(cornerRadius))
            bgColor.setFill()
            rectanglePath.fill()
            
            let pathCap = UIBezierPath()
            pathCap.move(to: CGPoint(x: capX, y: capY))
            pathCap.addQuadCurve(to: CGPoint(x: capX + capWidth, y: size.height/2),
                                 controlPoint: CGPoint(x: capX + capWidth * 1.1, y: size.height/2 - capHeigth/3))
            pathCap.addQuadCurve(to: CGPoint(x: capX, y: capY + capHeigth),
                                 controlPoint: CGPoint(x: capX + capWidth * 1.1, y: size.height/2 + capHeigth/3))
            
            bgColor.setFill()
            pathCap.fill()
            
            if (0 < percentageCover && percentageCover <= 0.20) {
                
                rectanglePath.addClip()
                
                let redRect = UIBezierPath(roundedRect: CGRect(x: 0,
                                                               y: 0,
                                                               width: bodyWidth * CGFloat(percentageCover),
                                                               height: bodyHeight),
                                           cornerRadius: CGFloat(cornerRadius))
                redColor.setFill()
                redRect.fill()
                
            } else {
                
                let greenRect = UIBezierPath(roundedRect: CGRect(x: 0,
                                                                 y: 0,
                                                                 width: bodyWidth * CGFloat(percentageCover),
                                                                 height: bodyHeight),
                                             cornerRadius: CGFloat(cornerRadius))
                greenColor.setFill()
                greenRect.fill()
            }
            
            if (percentageCover == 1.0) {
                greenColor.setFill()
                pathCap.fill()
            }
        }
        
        return image;
    }
}
