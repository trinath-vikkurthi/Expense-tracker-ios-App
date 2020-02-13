//
//  EnterLog.swift
//  MyGoogleDriveProject
//
//  Created by TcsMobility on 17/01/20.
//  Copyright © 2020 Nguyen Uy. All rights reserved.
//
import UIKit
import GoogleAPIClientForREST
import GoogleSignIn
class EnterLog: UIViewController {

    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var date: UIDatePicker?
    @IBOutlet weak var amount: UITextField?
    @IBOutlet weak var details: UITextField?
    var googleAPIs: GoogleDriveAPI?
    var user: GIDGoogleUser?
    override func viewDidLoad() {
        
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        super.viewDidLoad()
        let service = GTLRDriveService()
                    service.authorizer = user?.authentication.fetcherAuthorizer()
                    self.googleAPIs = GoogleDriveAPI(service: service)
    }
    
    @IBAction func Addrecords(_ sender: UIButton) {
        
        let alert1 = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)

               let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
               loadingIndicator.hidesWhenStopped = true
               loadingIndicator.style = UIActivityIndicatorView.Style.gray
               loadingIndicator.startAnimating();

               alert1.view.addSubview(loadingIndicator)
               present(alert1, animated: true, completion: nil)
        let when = DispatchTime.now() + 3
               DispatchQueue.main.asyncAfter(deadline: when){
                 // your code with delay
                 alert1.dismiss(animated: true, completion: nil)
                let alert = UIAlertController(title: "Saved", message: "Your details has been saved", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                self.amount?.text = ""
                       self.details?.text = ""
               }
               
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let selectedDate = dateFormatter.string(from: date!.date)
     print(selectedDate)
//        print(date?.date)
//        print(amount?.text!)
//        print(details?.text!)
        var content:String = ""
        content.append("\n")
        content.append(selectedDate)
        content.append(",")
        content.append((details?.text!)!)
        content.append(",")
        content.append((amount?.text!)!)
        print(content)
        
        //Searching for file MyExpensesApp.csv in  "My Expenses App Data" folder  of user drive
        
        self.googleAPIs?.search("My_Expenses_App_Folder", onCompleted: {(fileItem, error) in
            guard error == nil, fileItem != nil else {
                print("error in loading list")
                self.googleAPIs?.createFolder("My_Expenses_App_Folder", onCompleted: { (identifier,error) in
                    print(identifier as Any)
                let fileName = "My_expenses.csv"
                    let csvText = "Date,Reason,Amount"
                    let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
                    do {
                        try csvText.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
                        print(path as Any)

                    } catch {
                        print("Failed to create file")
                        print("\(error)")
                    }
                    let newpath: String = path!.relativePath
                    print(newpath)
                    self.googleAPIs?.uploadFile("My_Expenses_App_Folder", filePath: newpath, MIMEType:"text/csv" , onCompleted: { (fileID, error) in
                    print("Upload file ID: \(fileID); Error: \(error?.localizedDescription)")
                         self.searchForFile(folderid: identifier! , content: content)
                    })
                   
                })
                return
            }
            guard let folderID = fileItem?.identifier else {
                return
            }
            print("floder id",folderID)
            self.searchForFile(folderid: folderID, content: content)
            
        })
        
       
    }
    
    func searchForFile(folderid: String,content: String )  {
        var filename: GTLRDrive_File?
        self.googleAPIs?.listFiles(folderid, onCompleted: {(files, error) in
                       var i = 0
                        while(files?.files?[i].name != "My_expenses.csv"){
                           i = i + 1
                               }
                       filename = (files?.files?[i])!
                       self.downloadCSVFile(fileName: filename!, content: content)
                   })
    }
    
    func downloadCSVFile(fileName: GTLRDrive_File,content: String) {
        var response: String?
         self.googleAPIs?.download(fileName, onCompleted: { (Data, error) in
            let documentsdir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                    let fileurl = documentsdir.appendingPathComponent(fileName.name!)
          
                        do {
                            // writes the image data to disk
                            try Data?.write(to: fileurl)
                            print(fileurl)
                            response = "File Downloaded"
                        } catch {
                             print("error saving file:", error)
                        }
            self.deleteFileFromDrive(file: fileName)
            self.writeDataToFile(filename: (fileName.name!), content: content )
                    })
        
       
    }
    func writeDataToFile(filename: String,content: String) {
        let documentsdir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileurl = documentsdir.appendingPathComponent(filename)
         let file: FileHandle? = FileHandle(forUpdatingAtPath: fileurl.path)
                      if file == nil {
                          NSLog("File open failed")
                      } else {
                          // assuming data contains contents to be written
                          let filecontent = content.data(using: String.Encoding.utf8)
                          // seek to end of the file to append at the end of the file.
                          file?.seekToEndOfFile()
                        file?.write(filecontent!)
                          file?.closeFile()
                         self.UploadFile(filename: filename)
                      }
       
    }
    func UploadFile(filename: String)  {
        if let documentsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last {
                let testFilePath = documentsDir.appendingPathComponent(filename).path
                googleAPIs?.uploadFile("My_Expenses_App_Folder", filePath: testFilePath, MIMEType: "text/csv") { (fileID, error) in
                    print("Upload file ID: \(fileID); Error: \(error?.localizedDescription)")
                     self.deteleFileFromDevice(filename: filename)
                    }
           
                }
    }
    func deleteFileFromDrive(file: GTLRDrive_File)  {
        self.googleAPIs?.delete(file, onCompleted: {(error) in
            print(error as Any)
            print("File Deleted")
        })
    }
    func deteleFileFromDevice(filename: String) {
        let documentsdir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileurl = documentsdir.appendingPathComponent(filename)
        if FileManager.default.fileExists(atPath: fileurl.path) {
                  do {
                    try FileManager.default.removeItem(at: fileurl)
                  } catch {
                      print("Could not delete file: \(error)")
                  }
              }
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
