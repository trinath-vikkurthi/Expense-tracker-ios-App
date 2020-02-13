////
////  ViewController.swift
////  MyGoogleDriveProject
////
////  Created by Nguyen Uy on 15/2/19.
////  Copyright © 2019 Nguyen Uy. All rights reserved.
////
//
//import UIKit
//import GoogleSignIn
//import GoogleAPIClientForREST
//
//class ViewController: UIViewController {
//    fileprivate var googleAPIs: GoogleDriveAPI?
//    let googleDriveService = GTLRDriveService()
//    var btnGoogleSignIn: GIDSignInButton?
//    var btnDisconnect: UIButton?
//    var btnListfile: UIButton?
//    var btnDownload: UIButton?
//    var btnUpload: UIButton?
//   
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view, typically from a nib.
//        
//        self.btnGoogleSignIn = GIDSignInButton(frame: CGRect(x: 0, y: 100, width: self.view.frame.width, height: 50))
//        self.view.addSubview(self.btnGoogleSignIn!)
//        
//        self.btnDisconnect = UIButton(frame: CGRect(x: 0, y: 200, width: self.view.frame.width, height: 50))
//        self.btnDisconnect?.setTitle("Disconnect", for: .normal)
//        self.btnDisconnect?.setTitleColor(UIColor.black, for: .normal)
//        self.btnDisconnect?.addTarget(self, action: #selector(btnDisconnectTouchDown), for: .touchDown)
//        self.view.addSubview(self.btnDisconnect!)
//        
//        self.btnListfile = UIButton(frame: CGRect(x: 0, y: 300, width: self.view.frame.width, height: 50))
//        self.btnListfile?.setTitle("List files", for: .normal)
//        self.btnListfile?.setTitleColor(UIColor.black, for: .normal)
//        self.btnListfile?.addTarget(self, action: #selector(btnListFilesTouchDown), for: .touchDown)
//        self.view.addSubview(self.btnListfile!)
//        
//        self.btnDownload = UIButton(frame: CGRect(x: 0, y: 400, width: self.view.frame.width, height: 50))
//        self.btnDownload?.setTitle("Download", for: .normal)
//        self.btnDownload?.setTitleColor(UIColor.black, for: .normal)
//        self.btnDownload?.addTarget(self, action: #selector(btnDownloadTouchDown), for: .touchDown)
//        self.view.addSubview(self.btnDownload!)
//        
//        self.btnUpload = UIButton(frame: CGRect(x: 0, y: 500, width: self.view.frame.width, height: 50))
//        self.btnUpload?.setTitle("Upload", for: .normal)
//        self.btnUpload?.setTitleColor(UIColor.black, for: .normal)
//        self.btnUpload?.addTarget(self, action: #selector(btnUploadTouchDown), for: .touchDown)
//        self.view.addSubview(self.btnUpload!)
//        
//        self.setupGoogleSignIn()
//    }
//    
//    @objc
//    private func btnUploadTouchDown(){
//        
//        if let documentsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last {
//            let testFilePath = documentsDir.appendingPathComponent("MyExpensesApp.csv").path
//            googleAPIs?.uploadFile("My Expenses App Data", filePath: testFilePath, MIMEType: "text/csv") { (fileID, error) in
//                print("Upload file ID: \(fileID); Error: \(error?.localizedDescription)")
//            }
//        }
//        
//        
//    }
//    
//    var downloadFile: GTLRDrive_FileList?
//    @objc
//    private func btnDownloadTouchDown(){
//        var dataArray: [String] = []
//        let documentsdir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//        let fileurl = documentsdir.appendingPathComponent("MyExpensesApp.csv")
//        
//        let fileName: GTLRDrive_File = (downloadFile?.files?[0])!
//        print(fileName)
////        self.googleAPIs?.download(fileName, onCompleted: { (Data, error) in
////
////
////            let documentsdir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
////            let fileurl = documentsdir.appendingPathComponent(fileName.name!)
////                do {
////                    // writes the image data to disk
////                    try Data?.write(to: fileurl)
////                    print(fileurl)
////                    print("file downloaded")
////                } catch {
////                    print("error saving file:", error)
////                }
////            })
//        
//        
//        let file: FileHandle? = FileHandle(forUpdatingAtPath: fileurl.path)
//              if file == nil {
//                  NSLog("File open failed")
//              } else {
//                  // assuming data contains contents to be written
//                  let content = "\r16/01/2020,Dairy,80.00"
//                  let filecontent = content.data(using: String.Encoding.utf8)
//                  // seek to end of the file to append at the end of the file.
//                  file?.seekToEndOfFile()
//                file?.write(filecontent!)
//                  file?.closeFile()
//              }
//                 
//        
//        do {
//            let data = try Data(contentsOf: fileurl)
//            let dataEncoded = String(data: data, encoding: .utf8)
//                   if  let dataArr = dataEncoded?.components(separatedBy: "\r").map({ $0.components(separatedBy: ",") })
//                 {
//                   for line in dataArr
//                   {
//                    print(line)
//                   }
//               }
//               }
//               catch let jsonErr {
//                   print("\n Error read CSV file: \n ", jsonErr)
//               }
//
//
//        
////        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "newvc")
////        self.navigationController?.pushViewController(vc, animated: true)
//        
//       // var dataArray: [String] = []
//
//  }
//    @objc
//    private func btnListFilesTouchDown() {
//        self.googleAPIs?.search("My Expenses App Data", onCompleted: { (fileItem, error) in
//            guard error == nil, fileItem != nil else {
//                print("error in loading list")
//                return
//            }
//            guard let folderID = fileItem?.identifier else {
//                return
//            }
//            self.googleAPIs?.listFiles(folderID, onCompleted: { (files, error) in
//                self.downloadFile = files
//                print(error as Any)
//                print(files as Any)
//            })
//        })
//    }
//    
//    @objc
//    private func btnDisconnectTouchDown() {
//        GIDSignIn.sharedInstance()?.disconnect()
//    }
//
//    private func setupGoogleSignIn() {
//        GIDSignIn.sharedInstance().delegate = self
//        GIDSignIn.sharedInstance().uiDelegate = self
//        GIDSignIn.sharedInstance().scopes = [kGTLRAuthScopeDrive]
//        GIDSignIn.sharedInstance()?.signInSilently()
//    }
//}
//
//extension ViewController: GIDSignInDelegate {
//    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
//        if let _ = error {
//            
//        } else {
//            print("Authenticate successfully")
//      
//            let service = GTLRDriveService()
//            service.authorizer = user.authentication.fetcherAuthorizer()
//            self.googleAPIs = GoogleDriveAPI(service: service)
//        }
//    }
//    
//    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
//        print("Did disconnect to user")
//    }
//}
//
//extension ViewController: GIDSignInUIDelegate {}
//
