//
//  ShowLogs.swift
//  MyGoogleDriveProject
//
//  Created by TcsMobility on 17/01/20.
//  Copyright © 2020 Nguyen Uy. All rights reserved.
//

import UIKit
import GoogleSignIn
import GoogleAPIClientForREST
struct details{
    var date:String
    var type:String
    var cost:String
}
class ShowLogs: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
   var det = [details]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var fromDate: UIDatePicker!
    @IBOutlet weak var toDate: UIDatePicker!
    var googleAPI: GoogleDriveAPI?
    var dataFile: GTLRDrive_File?
    var user: GIDGoogleUser?
    var selFromDate: String?
    var selToDate: String?
    var kt = [[String:String]]()
    var kp = ["Dt":"Date", "Reason":"Purchase", "Amount":"Amount"]
    
    var p = 0
//    var sendData: TableViewController?
    
    override func viewDidLoad() {
   
        super.viewDidLoad()
        let service = GTLRDriveService()
        service.authorizer = user?.authentication.fetcherAuthorizer()
        self.googleAPI = GoogleDriveAPI(service: service)
    tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.isHidden = true
    }
    @IBAction func buttonclicked(_ sender: Any) {
//        tableView.reloadData()
    }
    
    @IBAction func searchExpenses(_ sender: UIButton) {
        
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)

        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();

        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
        let when = DispatchTime.now() + 2.5
        DispatchQueue.main.asyncAfter(deadline: when){
          // your code with delay
          alert.dismiss(animated: true, completion: nil)
        }
        
        let dateformater = DateFormatter()
        dateformater.dateFormat = "yyyy/MM/dd"
         selFromDate = dateformater.string(from: fromDate.date)
        selToDate   = dateformater.string(from: toDate.date)
        self.kt = []
        kt.append(kp)
        print(self.kt)
        self.googleAPI?.search("My_Expenses_App_Folder", onCompleted: { (fileItem, error) in
            guard error == nil, fileItem != nil else {
            print("error in loading list")
            let alert = UIAlertController(title: "NO Data", message: "You didnot save any expenses", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
            }
            guard let folderID = fileItem?.identifier else {
            return
            }
            self.googleAPI?.listFiles(folderID, onCompleted: { (files, error) in
             var i = 0
                 while(files?.files?[i].name != "My_expenses.csv"){
                    i = i + 1
                        }
                self.dataFile = (files?.files?[i])!
                self.downloadCSVFile(filename: self.dataFile!)
                    })
                })
    //  alert.dismiss(animated: false, completion: nil)
          self.p = 0
        
        }
    
    
    func downloadCSVFile(filename: GTLRDrive_File){
        //self.tableView.reloadData()
        self.googleAPI?.download(filename, onCompleted: { (data,error) in
            let documentsdir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileurl = documentsdir.appendingPathComponent("My_expenses.csv")
            
            do {
                // writes the image data to disk
                try data?.write(to: fileurl)
                print(fileurl)
            } catch {
                 print("error saving file:", error)
            }
            
            do {
                 let data = try Data(contentsOf: fileurl)
                 let dataEncoded = String(data: data, encoding: .utf8)
                if  let dataArr = dataEncoded?.components(separatedBy: "\n").map({ $0.components(separatedBy: ",") })
                    {
                            for line in dataArr
                            {
                                //let range = self.selFromDate!...self.selToDate!
                                                               if (line[0] >= self.selFromDate! && line[0] <= self.selToDate!) || (line[0] <= self.selFromDate! && line[0] >= self.selToDate!){
//                                                               if range.contains(line[0])
                                                                                     var dict = [String:String]()
                                                                   dict["Dt"] = line[0]
                                                                   dict["Reason"] = line[1]
                                                                   dict["Amount"] = line[2]
                                                                   self.kt.append(dict)
                                                               }
                                                           
                              
                            }
                        print(dataArr)
                        //self.kt = dataArr
                        
                        self.p = 0
                        
                    self.tableView.reloadData()
                    self.tableView.isHidden = false
                     }
                }
                catch let jsonErr {
                print("\n Error read CSV file: \n ", jsonErr) }
            
        })
    }
    
      func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
           let label = UILabel()
        label.textAlignment = .center
           label.text = "Expense Records"
    
           label.backgroundColor = UIColor.lightGray
           return label
           
       }
      
           
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           // #warning Incomplete implementation, return the number of rows
           return kt.count
       }

       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
           let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
    
        
        let obj = kt[indexPath.row]
        let dateformater = DateFormatter()
        dateformater.dateFormat = "dd/MM/yyyy"
        
        
        cell.dateLabel.text = obj["Dt"]
            cell.typeLabel.text = obj["Reason"]
            cell.costLabel.text = obj["Amount"]
       
        
           //cell.rightLabel.text = items[indexPath.row]
        
               return cell
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
