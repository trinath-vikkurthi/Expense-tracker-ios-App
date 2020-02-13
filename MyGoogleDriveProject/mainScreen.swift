//
//  mainScreen.swift
//  MyGoogleDriveProject
//
//  Created by TcsMobility on 17/01/20.
//  Copyright © 2020 Nguyen Uy. All rights reserved.
//
import GoogleSignIn
import GoogleAPIClientForREST
import UIKit

class mainScreen: UIViewController{
    
    @IBOutlet weak var vButton: UIButton!
    @IBOutlet weak var aButton: UIButton!
    @IBOutlet weak var butn: UIButton!
    var userVal: GIDGoogleUser?
    @IBAction func logAction(_ sender: UIButton) {
        let showvc: ShowLogs = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "showvc") as! ShowLogs
        showvc.user = userVal
        self.navigationController?.pushViewController(showvc, animated: true)
    }
    
    @IBAction func disconnectUser(_ sender: Any) {
        GIDSignIn.sharedInstance()?.signOut()
        GIDSignIn.sharedInstance()?.disconnect()
        self.navigationController?.popToRootViewController(animated: true)
    }
    @IBAction func addAction(_ sender: UIButton) {
        let addVc: EnterLog = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "EnterLog") as! EnterLog
        addVc.user = userVal
        self.navigationController?.pushViewController(addVc, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        butn.layer.cornerRadius = 5
               butn.layer.borderWidth = 1
        vButton.layer.cornerRadius = 5
        vButton.layer.borderWidth = 1
        aButton.layer.cornerRadius = 5
        aButton.layer.borderWidth = 1
        // Do any additional setup after loading the view.
         navigationItem.hidesBackButton = true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
