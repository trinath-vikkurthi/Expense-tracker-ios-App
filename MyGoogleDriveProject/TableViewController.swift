////
////  TableViewController.swift
////  MyGoogleDriveProject
////
////  Created by Trinath on 23/01/20.
////  Copyright © 2020 Nguyen Uy. All rights reserved.
////
//
//import UIKit
//
//class TableViewController: UITableViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
//        tableView.dataSource = self
//        tableView.reloadData()
//        // Uncomment the following line to preserve selection between presentations
//        // self.clearsSelectionOnViewWillAppear = false
//
//        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//        // self.navigationItem.rightBarButtonItem = self.editButtonItem
//    }
//
//    // MARK: - Table view data source
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//          let label = UILabel()
//          label.text = "Items List"
//          label.backgroundColor = UIColor.lightGray
//          return label
//          
//      }
//     
//          
//      override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//          // #warning Incomplete implementation, return the number of rows
//          return items.count
//      }
//
//      override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//          let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomCell
//          
//          let name = items[i][0]
//          let name2 = items[i][1]
//          let name3 = items[i][2]
//          cell.left.text = name
//          cell.right.text = name2
//          cell.cost.text = name3
//          i += 1
//          //cell.rightLabel.text = items[indexPath.row]
//
//              return cell
//      }
//      
//
//    /*
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
//
//        // Configure the cell...
//
//        return cell
//    }
//    */
//
//    /*
//    // Override to support conditional editing of the table view.
//    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        // Return false if you do not want the specified item to be editable.
//        return true
//    }
//    */
//
//    /*
//    // Override to support editing the table view.
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            // Delete the row from the data source
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        } else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }    
//    }
//    */
//
//    /*
//    // Override to support rearranging the table view.
//    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
//
//    }
//    */
//
//    /*
//    // Override to support conditional rearranging of the table view.
//    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
//        // Return false if you do not want the item to be re-orderable.
//        return true
//    }
//    */
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}
