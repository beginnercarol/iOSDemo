//
//  Task.swift
//  DailyTasks
//
//  Created by Carol on 2019/5/27.
//  Copyright © 2019 Carol. All rights reserved.
//

import Foundation
import UIKit
import CoreMedia

enum TaskCategory: String {
    case Random = "任意时间"
    case AM = "上午"
    case PM = "下午"
    case Night = "晚上"
}


struct Task {
    var name: String?
    var category: String
    var img: String
    var color: UIColor
    var duration: CMTime
    var current: CMTime
}

struct AllTasks {
    var category: String
    var lists: [Task]
}

class DailyTaskModel: NSObject {
    var categories: [String] = ["上午", "中午", "下午", "晚上", "睡前", "任意时间"]
    var categoryDic: [String: Int] = [
        "上午": 0, "中午": 1, "下午": 2,
        "晚上": 3, "睡前": 4, "任意时间": 5
    ]
    
    var selectedTask: Task?
    
    var timer: Timer?
    
    var allTasks: [AllTasks] = [
        AllTasks(category: "上午", lists: [
            Task(name: "Sport", category: "上午", img: "eggCake", color: UIColor.red, duration: CMTime(value: 5*60*600, timescale: 600), current: CMTime(value: 5*60*600, timescale: 600)),
            Task(name: "Reading", category: "上午", img: "eggCake", color: UIColor.yellow, duration: CMTime(value: 5*60*600, timescale: 600), current: CMTime(value: 5*60*600, timescale: 600)),
            Task(name: "Writing", category: "上午", img: "eggCake", color: UIColor.blue, duration: CMTime(value: 5*60*600, timescale: 600), current: CMTime(value: 5*60*600, timescale: 600)),
            ]),
        AllTasks(category: "中午", lists: [
            Task(name: "Sport", category: "中午", img: "eggCake", color: UIColor.red, duration: CMTime(value: 5*60*600, timescale: 600), current: CMTime(value: 5*60*600, timescale: 600)),
            Task(name: "Reading", category: "中午", img: "eggCake", color: UIColor.yellow, duration: CMTime(value: 5*60*600, timescale: 600), current: CMTime(value: 5*60*600, timescale: 600)),
            Task(name: "Writing", category: "中午", img: "eggCake", color: UIColor.blue, duration: CMTime(value: 5*60*600, timescale: 600), current: CMTime(value: 3*60*600, timescale: 600)),
            ])
    ]
    
    func addNewCategory(category: String) {
        if !categories.contains(category) {
            categories.append(category)
        }
    }
}
