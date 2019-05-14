//
//  Notification+CAEvent.swift
//  CAEventBus
//
//  Created by Carol on 2019/4/24.
//  Copyright © 2019 Carol. All rights reserved.
//

import Foundation

extension Notification: CAEventProtocol {
    var eventType: String {
        return self.name.rawValue
    }
}
