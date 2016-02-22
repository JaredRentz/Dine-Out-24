/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Stripe
import Parse
import CoreLocation

// If you want to use any of the UI components, uncomment this line
// import ParseUI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate  {

    var window: UIWindow?
    var locationManager: CLLocationManager?
    var lastProximity: CLProximity?

    //--------------------------------------
    // MARK: - UIApplicationDelegate
    //--------------------------------------

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        Stripe.setDefaultPublishableKey("pk_test_JXHXICfiqrX556C8GqzgkoNr")
        
        // Enable storing and querying data from Local Datastore.
        // Remove this line if you don't want to use Local Datastore features or want to use cachePolicy.
        Parse.enableLocalDatastore()
        

        // ****************************************************************************
        // Uncomment and fill in with your Parse credentials:
        Parse.setApplicationId("naOvP5wU0vrgx7Ank8QcO6MZxDcQmr6Z0WEn2yNF",
            clientKey: "SB17plwqF6osNAh10vqeayB9mVhgNaV3kN2J6lZM")
        //
        // If you are using Facebook, uncomment and add your FacebookAppID to your bundle's plist as
        // described here: https://developers.facebook.com/docs/getting-started/facebook-sdk-for-ios/
        // Uncomment the line inside ParseStartProject-Bridging-Header and the following line here:
        // PFFacebookUtils.initializeFacebook()
        // ****************************************************************************
        
        PFUser.enableAutomaticUser()

        let defaultACL = PFACL();

        // If you would like all objects to be private by default, remove this line.
        defaultACL.publicReadAccess = true
        
        
        
        PFACL.setDefaultACL(defaultACL, withAccessForCurrentUser: true)

        if application.applicationState != UIApplicationState.Background {
            // Track an app open here if we launch with a push, unless
            // "content_available" was used to trigger a background push (introduced in iOS 7).
            // In that case, we skip tracking here to avoid double counting the app-open.

            let preBackgroundPush = !application.respondsToSelector("backgroundRefreshStatus")
            let oldPushHandlerOnly = !self.respondsToSelector("application:didReceiveRemoteNotification:fetchCompletionHandler:")
            var noPushPayload = false;
            if let options = launchOptions {
                noPushPayload = options[UIApplicationLaunchOptionsRemoteNotificationKey] != nil;
            }
            if (preBackgroundPush || oldPushHandlerOnly || noPushPayload) {
                PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
            }
        }

        // iBeacon Information :
        
        let uuidString = "23A01AF0-232A-4518-9C0E-323FB773F5EF"
        let beaconRegionIdentifier = "sarah.iBeacon"
        let beaconUUID:NSUUID = NSUUID(UUIDString: uuidString)!
        
        let beaconRegion: CLBeaconRegion = CLBeaconRegion(proximityUUID: beaconUUID, identifier: beaconRegionIdentifier)
        
        //print(beaconRegion)
        
        locationManager = CLLocationManager()
        
        if ((locationManager?.respondsToSelector("requestAlwaysAuthorization")) != nil) {
            locationManager?.requestAlwaysAuthorization()
        }
        
        locationManager?.delegate = self
        locationManager?.pausesLocationUpdatesAutomatically = false
        locationManager?.startMonitoringForRegion(beaconRegion)
        
        // Start monitoring incase we have a beacon in our region
        
        locationManager?.startRangingBeaconsInRegion(beaconRegion)
        locationManager?.startUpdatingLocation()
        
        // Setup  Notifications (2)
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [UIUserNotificationType.Alert, 	UIUserNotificationType.Sound, UIUserNotificationType.Badge], categories: nil))



        return true
        
       
    }

    
// Enter, Exit & Notification for iBeacon
    
    // Method for entering a region
    
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        manager.startRangingBeaconsInRegion(region as! CLBeaconRegion)
        manager.startUpdatingLocation()
        
        // Local Notification (2)
        let localNotification = UILocalNotification()
        
        localNotification.alertAction = "Menu Found"
        localNotification.alertBody = "Check out local Eats"
        localNotification.fireDate = NSDate(timeIntervalSinceNow: 5)
        localNotification.userInfo = nil
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
        //print ("User entered a region")
    }
    
    // Method for exiting a region
    
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        manager.stopRangingBeaconsInRegion(region as! CLBeaconRegion)
        manager.stopUpdatingLocation()
        
        //print ("User exited the region")
    }
    
    
    
    // Lets get the information on the beacon.
    func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {
        print("number of beacons found =\(beacons.count)")
        
        for aBeacon in beacons {
            
            switch aBeacon.proximity {
            case CLProximity.Unknown:
                //print("unknown Major \(aBeacon.major), Minor \(aBeacon.minor) Accuracy \(aBeacon.accuracy) RSSI = \(aBeacon.rssi)")
                break
            case CLProximity.Far:
                //print("Far Major \(aBeacon.major), Minor \(aBeacon.minor) Accuracy \(aBeacon.accuracy) RSSI = \(aBeacon.rssi)")
                break
                
            case CLProximity.Near:
                //print("Near Major \(aBeacon.major), Minor \(aBeacon.minor) Accuracy \(aBeacon.accuracy) RSSI = \(aBeacon.rssi)")
                break
                
            case CLProximity.Immediate:
                //print("Immediate Major \(aBeacon.major), Minor \(aBeacon.minor) Accuracy \(aBeacon.accuracy) RSSI = \(aBeacon.rssi)")
                break
                
           }

        }
    

    
    // Get the first Beacon in list
    
    if beacons.first == nil {
    return
    }
    
    let currentBeacon = beacons.first
    
    // if the proximity is the same before, dont do anything
    
    if lastProximity != nil && currentBeacon?.proximity == lastProximity {
    return
    } else {
    // Set the proximity
    
    lastProximity = currentBeacon?.proximity
    
    // If we are Near, send notification to anyone interested
    
    if currentBeacon?.proximity == CLProximity.Near {
    NSNotificationCenter.defaultCenter().postNotificationName("ibeaconFoundReceivedNotification", object: nil, userInfo: ["major" : (currentBeacon?.major)!, "minor": (currentBeacon?.minor)!])
    }
    }
    }


}
