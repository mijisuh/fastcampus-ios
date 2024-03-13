//
//  Tab.swift
//  Cafe
//
//  Created by mijisuh on 2024/03/13.
//

import SwiftUI

enum Tab {
    case home
    case other
    
    // associate value: enum의 변수를 특정한 형태로 바로 return 해줌
    var textItem: Text {
        switch self {
        case .home:
            return Text("Home")
        case .other:
            return Text("Other")
        }
    }
    
    var imageItem: Image {
        switch self {
        case .home:
            return Image(systemName: "house.fill")
        case .other:
            return Image(systemName: "ellipsis")
        }
    }
}
