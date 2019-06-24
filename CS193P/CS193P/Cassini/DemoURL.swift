//
//  DemoURL.swift
//  CS193P
//
//  Created by Carol on 2019/1/18.
//  Copyright © 2019年 Carol. All rights reserved.
//

import Foundation

struct DemoURL {
    static let background = Bundle.main.url(forResource: "palace", withExtension: "jpg")
    static var LIFE: Dictionary<String, URL> = {
        let LIFEURLStrings = [
            "Light": "https://images.unsplash.com/photo-1451187580459-43490279c0fa?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1504&q=80",
            "Moon": "https://images.unsplash.com/photo-1523597020744-b68b1edd3e1c?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1267&q=80",
            "Earth": "https://images.unsplash.com/photo-1538291323976-37dcaafccb12?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60"
        ]
        var urls = Dictionary<String, URL>()
        for (key, value) in LIFEURLStrings {
            urls[key] = URL(string: value)
        }
        return urls
    }()
}
