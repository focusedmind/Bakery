//
//  ItemsListUpdateEvent.swift
//  Bakery
//
//  Created by iOS Developer on 6/16/20.
//  Copyright © 2020 Bakery Union. All rights reserved.
//

import Foundation

enum ItemsListUpdateEvent {
    
    case append(_ indices: [IndexPath])
    case update(_ indices: [IndexPath])
    case remove(_ indices: [IndexPath])
}
