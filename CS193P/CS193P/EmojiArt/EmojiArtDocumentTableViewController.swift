
//
//  EmojiArtDocumentTableControllerViewTableViewController.swift
//  CS193P
//
//  Created by Carol on 2019/1/25.
//  Copyright © 2019年 Carol. All rights reserved.
//

import UIKit

class EmojiArtDocumentTableViewController: UITableViewController {
    var emojiArtDocuments = ["One", "Two", "Three"]
    
    var emojiArtSections = ["default"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(EmojiTableCell.self, forCellReuseIdentifier: "emoji.table.cell")
        emojiArtDocuments = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).compactMap { ($0.pathExtension == "json") ? $0.absoluteString : nil}
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emojiArtDocuments.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "emoji.table.cell", for: indexPath) as! EmojiTableCell
        cell.textLabel?.text = emojiArtDocuments[indexPath.row]
        cell.accessoryType = .checkmark
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "default"
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let header = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 48))
            let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewDocuments(_:)))
            
            let toolBar = UIToolbar(frame: header.frame)
            header.addSubview(toolBar)
            toolBar.setItems([UIBarButtonItem(barButtonSystemItem:.flexibleSpace, target: nil, action: nil), button], animated: true)
            return header
        } else {
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 50
        } else {
            return 0
        }
    }
    
    @objc func addNewDocuments(_ sender: UIBarButtonItem) {
        let title = "Untitled\(emojiArtDocuments.count)"
        emojiArtDocuments += [title]
        tableView.reloadData()
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            emojiArtDocuments.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with:  .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
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


//extension String {
//    func unique(in array: [String]) -> String {
//        
//    }
//}
