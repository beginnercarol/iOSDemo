//
//  Person.swift
//  DTSlidebarAnimation
//
//  Created by Carol on 2019/6/26.
//  Copyright © 2019 Carol. All rights reserved.
//

import Foundation
import JavaScriptCore


protocol PersonJSExport: JSExport {
    var firstName: String { get set }
    var lastName: String { get set }
    var birthYear: NSNumber { get set }
}

class Person: NSObject, PersonJSExport {
    var firstName: String
    
    var lastName: String
    
    var birthYear: NSNumber
    
    init(firstName: String, lastName: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.birthYear = NSNumber(integerLiteral: 1994)
    }
}
