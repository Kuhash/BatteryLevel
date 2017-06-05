//
//  ViewController.swift
//  BatteryLevel
//
//  Created by Maciej Kucharski on 01/06/2017.
//  Copyright © 2017 Maciej Kucharski. All rights reserved.
//

import UIKit
import UserNotifications
import WatchConnectivity

class ViewController: UIViewController, WCSessionDelegate {
    
    @IBOutlet weak private var lblStatus: UILabel!

    @IBOutlet weak private var image: UIImageView!
    
    let center = UNUserNotificationCenter.current()
    
    var currentBatteryLevel: Float {
        return UIDevice.current.batteryLevel
    }
    var lastKnownBatteryLevel: Float = 0.0
    
    var session: WCSession!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        lblStatus.text = "\(Int(currentBatteryLevel * 100))%"
        image.image = UIImage.drawBattery(size: CGSize(width: 500, height: 200),
                                          percentageCover: currentBatteryLevel,
                                          cornerRadius: 15)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        var array = [UIImage]()
//        for i in 0 ... 1000 {
//            array.append(UIImage.drawBattery(size: CGSize(width: 500, height: 200), percentageCover: 0.001*Float(i), cornerRadius: 15))
//        }
//        image.animationImages = array
//        image.animationDuration = 5
//        image.animationRepeatCount = 0
//        image.startAnimating()
        
        if (WCSession.isSupported()) {
            session = WCSession.default()
            session.delegate = self;
            session.activate()
        }
        
        let options: UNAuthorizationOptions = [.alert, .sound];
        center.requestAuthorization(options: options) {
            (granted, error) in
            if !granted {
                print("Something went wrong")
            }
        }
        center.getNotificationSettings { (settings) in
            if settings.authorizationStatus != .authorized {
                print("Not allowed")
            }
        }
        
        UIDevice.current.isBatteryMonitoringEnabled = true
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(batteryLevelDidChange),
                                               name: .UIDeviceBatteryLevelDidChange,
                                               object: nil)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func batteryLevelDidChange(_ notification: Notification) {
        lblStatus.text = "\(Int(currentBatteryLevel * 100))%"
        lastKnownBatteryLevel = currentBatteryLevel
        
        image.image = UIImage.drawBattery(size: CGSize(width: 500, height: 200),
                                          percentageCover: currentBatteryLevel,
                                          cornerRadius: 15)
        
        if (currentBatteryLevel == 1.0) {
            let content = UNMutableNotificationContent()
            content.title = "Fully charged"
            content.body = "You can unplug your iPhone"
            content.sound = UNNotificationSound.default()
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 300,
                                                            repeats: false)
            
            let identifier = "BatteryLevelLocalNotification"
            let request = UNNotificationRequest(identifier: identifier,
                                                content: content,
                                                trigger: trigger)
            center.add(request, withCompletionHandler: { (error) in
                if let error = error {
                    print("\(error)")
                }
            })
        }
    }

    // MARK: WCSessionDelegate
    
    func session(_ session: WCSession,
                 activationDidCompleteWith activationState: WCSessionActivationState,
                 error: Error?) {
        print("\(String(describing: error))")
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
    func session(_ session: WCSession,
                 didReceiveMessage message: [String : Any],
                 replyHandler: @escaping ([String : Any]) -> Swift.Void) {

        let watchLastKnownBatteryLevel = message.getLastKnownBatteryLevel()
        let numberOfFrames = 50
        
        var uniformStart = Int(watchLastKnownBatteryLevel * Float(numberOfFrames))
        var uniformEnd = Int(self.currentBatteryLevel * Float(numberOfFrames))
        var shouldReverse = false
        
        if (self.currentBatteryLevel < watchLastKnownBatteryLevel) {
            let tmp = uniformStart
            uniformStart = uniformEnd
            uniformEnd = tmp
            shouldReverse = true
        }
        
        let step = Float(1.0 / Float(numberOfFrames))
        
        var imagesData = [Data]()
        for i in uniformStart ... uniformEnd {
            let image = UIImage.drawBattery(size: CGSize(width: 75, height: 30),
                                            percentageCover: step*Float(i),
                                            cornerRadius: 3)
            imagesData.append(UIImagePNGRepresentation(image)!)
        }
        
        if (shouldReverse) {
            imagesData = imagesData.reversed()
        }
        
        var dict = [String: Any]()
        dict.setCurrentBatteryLevel(value: currentBatteryLevel)
        dict.setImages(value: imagesData)
        
        replyHandler(dict)
    }
}

