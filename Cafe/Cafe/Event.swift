//
//  Event.swift
//  Cafe
//
//  Created by mijisuh on 2024/03/13.
//

import SwiftUI

struct Event: Identifiable {
    let id = UUID()
    
    let image: Image // UIImage
    let title: String // Text로 하지 않는 이유는 font 설정 등 외부에서 더 설정해줘야 하는 것들이 많기 때문(UILabel이 온다고 생각하면 어색)
    let description: String
}
