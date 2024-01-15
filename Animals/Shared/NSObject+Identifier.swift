//
//  NSObject+Identifier.swift
//  Animals
//
//  Created by Santo Michael on 16/01/24.
//

import Foundation

extension NSObject {
	public var identifier: String {
		String(describing: type(of: self))
	}
	
	public static var identifier: String {
		String(describing: self)
	}
}

