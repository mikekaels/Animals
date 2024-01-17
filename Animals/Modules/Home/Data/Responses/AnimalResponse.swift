//
//  AnimalResponse.swift
//  Animals
//
//  Created by Santo Michael on 16/01/24.
//

import Foundation

// MARK: - Element
internal struct AnimalResponse: Codable {
	internal let name: String?
	enum CodingKeys: String, CodingKey {
		case name
	}
}
