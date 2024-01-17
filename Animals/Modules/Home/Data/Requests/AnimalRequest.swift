//
//  AnimalRequest.swift
//  Animals
//
//  Created by Santo Michael on 16/01/24.
//

import Networking
import UIKit

internal struct AnimalRequest: APIRequest {
	
	typealias Response = [HomeContent]
	
	let numOfAnimal: Int
	
	init(animalName: String, numOfAnimal: Int) {
		self.numOfAnimal = numOfAnimal
		self.path = "v1/animals?name=\(animalName)"
	}
	
	var baseURL: String {
		NetworkConfiguration.BaseURL.animal.rawValue
	}
	
	var method: HTTPMethod = .get
	
	var path: String
	
	var headers: [String : Any] = [
		"X-Api-Key": "pfFQJxLiPMYqvY5rZXbYdw==VBjYVanTRFZdEhx9"
	]
	
	var body: [String : Any] = [:]
	
	func map(_ data: Data) throws -> [HomeContent] {
		let decoded = try JSONDecoder().decode([AnimalResponse].self, from: data)
		return decoded.prefix(upTo: numOfAnimal).map { HomeContent(name: $0.name ?? "", color: UIColor.getRandomPrefixColor()) }
	}
}
