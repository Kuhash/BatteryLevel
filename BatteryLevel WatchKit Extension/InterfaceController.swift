//
//  InterfaceController.swift
//  BatteryLevel WatchKit Extension
//
//  Created by Maciej Kucharski on 01/06/2017.
//  Copyright © 2017 Maciej Kucharski. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController, WCSessionDelegate {
    
    var session: WCSession?
    var lastKnownBatteryLevel: Float = 0.0
    
    @IBOutlet var label: WKInterfaceLabel!
    @IBOutlet var image: WKInterfaceImage!
    
    func checkStatus() {
        
        label.setText("Checking ...")
        
        let session = WCSession.default();
        if session.isReachable {
            var message = [String: Any]()
            message.setLastKnownBatteryLevel(value: self.lastKnownBatteryLevel)
            
            session.sendMessage(message,
                                replyHandler: { (reply) in
                                    
                                    let batteryLevel = reply.getCurrentBatteryLevel()
                                    self.lastKnownBatteryLevel = batteryLevel
                                    self.label.setText("\(Int(batteryLevel * 100))%")
                                    
                                    let array = reply.getImages()
                                    var images = [UIImage]()
                                    for data in array {
                                        images.append(UIImage(data: data)!)
                                    }
                                    let animationImage = UIImage.animatedImage(with: images, duration: 1)
                                    self.image.setImage(animationImage)
//                                    self.image.startAnimating()
                                    self.image.startAnimatingWithImages(in: NSMakeRange(0, array.count),
                                                                        duration: 0.5,
                                                                        repeatCount: 1)
            },
                                errorHandler: { (error) in
                                    self.label.setText("\(error)")
            })
        } else {
            self.label.setText("WCSession is not reachable")
        }
    }

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
    }
    
    override func willActivate() {
        super.willActivate()
        
        session = WCSession.default()
        if (session?.activationState == .notActivated) {
            session?.delegate = self
            session?.activate()
        }
        
        if (session?.activationState == .activated) {
            checkStatus()
        }
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }

    func session(_ session: WCSession,
                 activationDidCompleteWith activationState: WCSessionActivationState,
                 error: Error?) {
        
        if (activationState == .activated) {
            checkStatus()
        }
        
//        self.lblStatus.setText("activationState:\(activationState) error:\(String(describing: error))")
    }
}
