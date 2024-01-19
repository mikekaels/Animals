//
//  Image.swift
//  Animals
//
//  Created by Santo Michael on 16/01/24.
//

import Foundation

internal struct ImageEntity: Hashable {
	let name: String
	var image: String
	var isLiked: Bool = false
	var id: String = UUID().uuidString
}

internal struct ImageURL: Hashable {
	let tiny: String
	let large: String
}
