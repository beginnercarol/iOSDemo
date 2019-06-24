//
//  MenuDataSource.swift
//  DTSlidebarAnimation
//
//  Created by Carol on 2019/6/10.
//  Copyright © 2019 Carol. All rights reserved.
//

import Foundation
import UIKit

class MenuDataSource: NSObject, UITableViewDataSource {
    var menuItems: [MenuItem] = []
    
    override init() {
        super.init()
        prepare()
    }
    
    func prepare() {
        guard let url = Bundle.main.url(forResource: "MenuItems", withExtension: "json") else {
            assertionFailure("Can not find json file")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            menuItems = try JSONDecoder().decode([MenuItem].self, from: data)
        } catch {
            assertionFailure("Loading json file failed")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MenuItem.cell", for: indexPath) as? MenuTableViewCell else {
            fatalError("Cell init failed")
        }
        let menuItem = menuItems[indexPath.row]
        cell.configureCell(menuItem)
        return cell
    }
    
    
}
