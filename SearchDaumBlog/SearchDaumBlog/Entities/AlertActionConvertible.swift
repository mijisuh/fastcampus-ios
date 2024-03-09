//
//  AlertActionConvertible.swift
//  SearchDaumBlog
//
//  Created by mijisuh on 2024/03/09.
//

import UIKit

protocol AlertActionConvertible {
    
    var title: String { get }
    var style: UIAlertAction.Style { get }
    
}
