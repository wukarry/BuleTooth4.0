//
//  ViewController.swift
//  BluetoothProject
//
//  Created by 超级无敌呆萌瑶 on 16/4/20.
//  Copyright © 2020 超级无敌呆萌瑶. All rights reserved.
//
import CoreLocation
import UIKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var distanceRanding: UILabel!
    var locationManager:CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        view.backgroundColor = .gray
        
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways{
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    //do stuff
                    startScanning()
                }
            }
        }
    }


    
    func startScanning() {
        let uuid = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!
        let beaconRegion = CLBeaconRegion(uuid: uuid, major: 123, minor: 456, identifier: "MyBeacon")
        //let beaconRegion = CLBeaconRegion(uuid: <#T##UUID#>, identifier: <#T##String#>)
        //let beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: 123, minor: 456, identifier: "MyBeacon")
        locationManager?.startMonitoring(for: beaconRegion)
        locationManager?.startRangingBeacons(in: beaconRegion)
        
    }
    func update(distance: CLProximity) {
        UIView.animate(withDuration: 0.5) {
            switch distance {
            case .unknown:
                self.view.backgroundColor = .gray
                self.distanceRanding.text = "UNKNOWN"
                
            case .far:
                self.view.backgroundColor = .blue
                self.distanceRanding.text = "FAR"
                
            case .near:
                self.view.backgroundColor = .orange
                self.distanceRanding.text = "NEAR"
            
            case .immediate:
                self.view.backgroundColor = .red
                self.distanceRanding.text = "RIGHT HERE"
                
            default:
               self.view.backgroundColor = .gray
               self.distanceRanding.text = "UNKNOWN"
            }
        }
    }
         
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if let beacon = beacons.first {
            update(distance: beacon.proximity)
        } else {
            update(distance: .unknown)
        }
    }


}

