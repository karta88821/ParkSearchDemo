//
//  AppDelegate.swift
//  ParkSearchDemo
//
//  Created by liao yuhao on 2019/2/15.
//  Copyright © 2019 liao yuhao. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    lazy var mediator: Mediator = {
        let network = Network(session: URLSession.shared)
        let apiService = APIService(network: network)
        let persistency = Persistency.shared
        
        let mediator = Mediator(apiService: apiService,
                                persistency: persistency)

        return mediator
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let parkingRecordsViewController = ParkingRecordsViewController(mediator: mediator)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController(rootViewController: parkingRecordsViewController)
        window?.makeKeyAndVisible()
        
        return true
    }


}

