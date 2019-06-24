//
//  MenuTableViewController.swift
//  DTSlidebarAnimation
//
//  Created by Carol on 2019/6/9.
//  Copyright © 2019 Carol. All rights reserved.
//

import UIKit

protocol MenuDelegate: class {
    func didSelectMenuItem(_ item: MenuItem)
}

class MenuTableViewController: UITableViewController {
    var dataSource: MenuDataSource = MenuDataSource()
    weak var delegate: MenuDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(MenuTableViewCell.self, forCellReuseIdentifier: "MenuItem.cell")
        self.tableView.dataSource = dataSource
        let indexPath = IndexPath(row: 0, section: 0)
        let item = dataSource.menuItems[indexPath.row]
        self.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        delegate?.didSelectMenuItem(item)
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = dataSource.menuItems[indexPath.row]
        delegate?.didSelectMenuItem(item)
        
        DispatchQueue.main.async {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

}
