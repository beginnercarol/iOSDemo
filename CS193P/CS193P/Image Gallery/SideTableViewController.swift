
//
//  SideTableViewController.swift
//  CS193P
//
//  Created by Carol on 2019/3/9.
//  Copyright © 2019年 Carol. All rights reserved.
//

import UIKit

class SideTableViewController: UITableViewController {
    var imgDocument: [String]!
    var addNewFileHandler: ((String)->Void)!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(SideTableViewCell.self, forCellReuseIdentifier: Utility.Identifier.SideTableCellIdentifier)
//        tableView.register(SideTableHeaderView.self, forCellReuseIdentifier: Utility.Identifier.SideTableHeaderViewIdentifier)
        tableView.register(SideTableInputViewCell.self, forCellReuseIdentifier: Utility.Identifier.SideTableInputCellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return imgDocument.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let header = SideTableHeaderView()
            header.addNewFileHandler = self.addNewTableCell
            return header
        } else {
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let inputCell = cell as? SideTableInputViewCell {
            inputCell.becomeFirstResponder()
        }
    }
    
    func addNewTableCell() {
        tableView.performBatchUpdates({[weak tableView] in
            imgDocument.insert("Untitled", at: 0)
            tableView?.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        }, completion: nil)
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Utility.Identifier.SideTableCellIdentifier, for: indexPath) as! SideTableViewCell
        cell.titleHandler = addNewFileHandler
        cell.textLabel?.text = imgDocument[indexPath.row]
        return cell
    }
 
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
