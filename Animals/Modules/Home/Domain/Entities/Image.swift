//
//  Image.swift
//  Animals
//
//  Created by Santo Michael on 16/01/24.
//

import Foundation

internal struct Image: Hashable {
	let name: String
	let url: ImageURL
	var showedImage: String
	var isLiked: Bool = false
}

internal struct ImageURL: Hashable {
	let tiny: String
	let large: String
}
