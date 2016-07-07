//
//  AppDelegate.swift
//  hackerbooks
//
//  Created by Juan Arillo Ruiz on 5/7/16.
//  Copyright © 2016 Juan Arillo Ruiz. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var model : Library?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        // Model instance
        func decodeJSON() ->[Book]?{
            
            var result : [Book]? = nil
            // Obtener la url del fichero
            // Leemos el fichero JSON a un NSDATA (esto puede salir mal)
            // Lo parseamos
            do{
                let documents = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
                let writePath = documents.stringByAppendingString("/books_readable.json")
                
                let firstLaunch = !NSUserDefaults.standardUserDefaults().boolForKey("FirstLaunch")
                let fileExist = NSFileManager.defaultManager().fileExistsAtPath(writePath)
                if firstLaunch {
                    if let url = NSURL(string: "https://t.co/K9ziV0z3SJ"),
                        data = NSData(contentsOfURL: url),
                        booksArray = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as? JSONArray{
                                saveData(data)
                        // Todo es fabuloso!!!
                        result = decode(books: booksArray)
                        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "FirstLaunch")
                    }
                }
                else if fileExist {
                    result = try loadJSONLocally()
                }else{
                    NSUserDefaults.standardUserDefaults().setBool(false, forKey: "FirstLaunch")
                }
            }catch{
                // Error al parsear el JSON
                fatalError()
            }
            
            return result;
            
        }
        
        if let books = decodeJSON(){
            var uniqueTags = [Tag]()
            for book in books{
                for tag in book.tags{
                    if !uniqueTags.contains(tag){
                        uniqueTags.append(tag)
                    }
                }
            }
            model = Library(booksArray: books, tagArray: uniqueTags)
        }else{
            fatalError("Everything goes wrong")
        }
        
        // New window
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        // VC
        let vc = LibraryTableViewController(model: model!)
        
        // Insert in a navigation
        let nav = UINavigationController(rootViewController: vc)
        
        // nav as root
        window?.rootViewController = nav
        
        // visible and key
        window?.makeKeyAndVisible()
        
        // MARK: - Utils
        
        func saveData(data: NSData){
            let documents = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
            let writePath = NSURL(fileURLWithPath: documents).URLByAppendingPathComponent("books_readable.json")
            data.writeToURL(writePath, atomically: false)
        }
        
        func loadJSONLocally() throws -> [Book]?{
            do{
                let documents = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
                let writePath = NSURL(fileURLWithPath: documents).URLByAppendingPathComponent("books_readable.json")
                if let data = NSData(contentsOfURL: writePath),
                    booksArray = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as? JSONArray{
                    // Todo es fabuloso!!!
                    return decode(books: booksArray)
                }
            }catch{
                fatalError()
            }
            
            
            return nil
        }
        
        return true
        
        
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

