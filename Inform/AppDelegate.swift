//
//  AppDelegate.swift
//  Inform
//
//  Created by Александр on 18.03.18.
//  Copyright © 2018 Александр. All rights reserved.
//

import UIKit
import CoreData
import AdSupport
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    private var orgId: Int?
    private var cityId: Int?
    private var token: String?
    private var ad: String?
    
    private var rs: Cancelable?
    private var cd: Cancelable?
    
    private var updateTimer: Timer?
    private var ut: Cancelable?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)
        
        // AD ID
        if ASIdentifierManager.shared().isAdvertisingTrackingEnabled {
            let IDFA = ASIdentifierManager.shared().advertisingIdentifier
            if IDFA.uuidString != "" {
                self.ad = IDFA.uuidString
            }
        }
        
        // Token
        let settings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
        UIApplication.shared.registerUserNotificationSettings(settings)
        
        // Push notifications
        if let notification = launchOptions?[.remoteNotification] as? [AnyHashable: Any] {
            self.processNotification(notification)
        }
        UIApplication.shared.applicationIconBadgeNumber = 0
//        
//        let news = NotificationNews(orgId: 2, catalogId: 7, itemId: 17644)
//        let payload = NotificationPayload(news: news)
//        NotificationQue.shared.notify(payload)
        
        // Get saved city
        cityId = self.loadCityId();
        
        // Client data
        self.sendClientData()
        
        // Get is run without orgs
        if (LocalDataStore.hasOrgs()) {
            // Get orgId from local config
            let orgId = self.loadOrgId()
            
            // Reload org from server
            if orgId != nil && orgId! > 0 {
                self.rs = LocalDataStore.loadOrg(
                    orgId!,
                    success: {
                        DispatchQueue.main.async {
                            self.setOrgId(orgId)
                        }
                    },
                    failure: {
                        if !($0 is ErrorCanceled) {
                            print($0)
                            DispatchQueue.main.async {
                                self.setOrgId(orgId)
                            }
                        }
                    }
                )
            } else {
                self.setOrgId(orgId)
            }
        } else {
            // Show start ui
            let mainViewController = UINavigationController()
            let ui = OrgListViewController()
            mainViewController.viewControllers = [ui]
            self.setRootViewController(mainViewController)
        }
        
        self.updateTimer = Timer.scheduledTimer(timeInterval: 5.0 * 60.0, target: self, selector: #selector(self.refreshOrg), userInfo: nil, repeats: true)
        
        return true
    }

    public func setOrgId(_ orgId: Int?) {
        self.orgId = orgId
        
        self.saveOrgId(orgId: orgId)
        
        let orgId = orgId ?? 0
        
        let mainViewController = MainViewController(orgId: orgId)
        self.setRootViewController(mainViewController)
    }
    
    public func getOrgId() -> Int? {
        return self.orgId
    }
    
    public func setCityId(_ cityId: Int?) {
        self.cityId = cityId
        self.saveCityId(cityId: cityId)
    }
    
    public func getCityId() -> Int? {
        return self.cityId
    }
    
    private func loadOrgId() -> Int? {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let fileURL = dir.appendingPathComponent("orgid.config")
            
            do {
                let text = try String(contentsOf: fileURL, encoding: .utf8)
                return Int(text)
            } catch let error {
                print(error)
            }
        }
        
        return nil
    }

    
    private func saveOrgId(orgId: Int?) {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let fileURL = dir.appendingPathComponent("orgid.config")
            
            do {
                if orgId != nil {
                    try String(orgId!).write(to: fileURL, atomically: false, encoding: .utf8)
                } else {
                    try String().write(to: fileURL, atomically: false, encoding: .utf8)
                }
            } catch let error {
                print(error)
            }
        }
    }
    
    private func loadCityId() -> Int? {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let fileURL = dir.appendingPathComponent("cityid.config")
            
            do {
                let text = try String(contentsOf: fileURL, encoding: .utf8)
                return Int(text)
            } catch let error {
                print(error)
            }
        }
        
        return nil
    }
    
    
    private func saveCityId(cityId: Int?) {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let fileURL = dir.appendingPathComponent("cityid.config")
            
            do {
                if cityId != nil {
                    try String(cityId!).write(to: fileURL, atomically: false, encoding: .utf8)
                } else {
                    try String().write(to: fileURL, atomically: false, encoding: .utf8)
                }
            } catch let error {
                print(error)
            }
        }
    }
    
    func setRootViewController(_ viewController: UIViewController) {
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    
    // MARK: - Core Data stack
    private lazy var applicationDocumentsDirectory: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls.last!
    }()
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: "Inform", withExtension: "mom")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    public lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("data.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        
        do {
            try coordinator.addPersistentStore(
                ofType: NSSQLiteStoreType,
                configurationName: nil,
                at: url,
                options: [
                    NSMigratePersistentStoresAutomaticallyOption: true,
                    NSInferMappingModelAutomaticallyOption: true
                ]
            )
        } catch {
            var dict = [String: Any]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    public lazy var managedObjectContext: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    // MARK: - Ad & PUSH
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        if application.applicationState != .active {
            self.processNotification(userInfo)
        }
    }
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        if notificationSettings.types != UIUserNotificationType() {
            application.registerForRemoteNotifications()
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        let token = tokenParts.joined()
        self.token = token
        self.sendClientData()
    }
    
    func processNotification(_ notification: [AnyHashable : Any]) {
        if let payloadData = notification["payload"] as? String  {
            do {
                if let data = payloadData.data(using: .utf8) {
                    let decoder = JSONDecoder()
                    let payload = try decoder.decode(NotificationPayload.self, from: data)
                    NotificationQue.shared.notify(payload)
                }
            } catch {
                print(error)
            }
        }
    }
    
    public func sendClientData() {
        if (self.token == nil && self.ad == nil) {
            return
        }
        let settings: [Settings] = SettingsDAO(context: self.managedObjectContext).list()
        let configs = settings.map { SettingsDTO.topProxy(fromModel: $0) }
        let clientData = ClientDataProxy(token: self.token, ad: self.ad, orgConfigs: configs)
        self.cd = RemoteService.sendClientData(clientData, success: {_ in }, failure: { print($0) })
    }

    @objc func refreshOrg(_ timer: Timer) {
        if self.orgId != nil && self.orgId! > 0 {
            self.ut = LocalDataStore.loadOrg(self.orgId!, success: {}, failure: {_ in })
        }
    }
}

