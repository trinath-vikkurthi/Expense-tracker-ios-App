//
//  ViewController2.swift
//  MyGoogleDriveProject
//
//  Created by TcsMobility on 17/01/20.
//  Copyright © 2020 Nguyen Uy. All rights reserved.
//

import UIKit
import GoogleSignIn
import GoogleAPIClientForREST
class ViewController2: UIViewController {

   let googleDriveService = GTLRDriveService()
    var btnGoogleSignIn : GIDSignInButton?
    var googleAPIs: GoogleDriveAPI?
    var btnDisconnect: UIButton?
    var users: GIDGoogleUser?
    var b:Bool?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnGoogleSignIn = GIDSignInButton(frame: CGRect(x: 100, y: 200, width: (self.view.frame.width) / 2, height: 50))
           self.view.addSubview(self.btnGoogleSignIn!)
        self.btnGoogleSignIn?.isHidden = b!
        self.setupGoogleSigin()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
         self.btnGoogleSignIn?.isHidden = b!
    }
    
    private func setupGoogleSigin(){
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().scopes = [kGTLRAuthScopeDrive]
        GIDSignIn.sharedInstance()?.signInSilently()
    }
    
}

extension ViewController2: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let _ = error {
            
        } else {
            print("Authenticate successfully")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
               // Your code with navigate to another controller
            
                self.users = user
                let vc  = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "mainScreen") as! mainScreen
                vc.userVal = self.users
            self.b = false
             self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    }
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("Did disconnect to user")
    }
}

extension ViewController2: GIDSignInUIDelegate {}

