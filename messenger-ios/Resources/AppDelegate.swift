//
//  AppDelegate.swift
//  messenger-ios
//
//  Created by Dima on 20.12.2020.
//

import UIKit
import Firebase
import GoogleSignIn

@main
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }
    // MARK: UISceneSession Lifecycle
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        if let error = error {
            print("Error while signing in with google: \(error)")
        }
        
        DatabaseManager.shared.userExists(with: user.profile.email) { [weak self] exists in
            let chatUser = ChatAppUser(firstname: user.profile.name,
                                         lastName: user.profile.familyName,
                                         emailAddress: user.profile.email)
            
            if !exists {
                DatabaseManager.shared.insertUser(with: chatUser){ [weak self] result, error  in
                    if let error = error, error != nil, !result{
                        
                        print("User has been inserted successfully")
                    } else {
                        print("ERROR \(error)")
                        print("User has not been inserted")
                    }
                }
            }
            
        }

        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                     accessToken: authentication.accessToken)
        Firebase.Auth.auth().signIn(with: credential){[weak self] (authResult, error) in
            if let error = error, error != nil {
                print("Error: \(error)")
                return
            }
            NotificationCenter.default.post(name: Notification.Name("LoggedIn"), object: nil)
        }
    }

    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("Signed out successfully")
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

