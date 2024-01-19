//
//  ImageRequest.swift
//  Animals
//
//  Created by Santo Michael on 16/01/24.
//

import Networking

internal struct ImageRequest: APIRequest {
	
	typealias Response = ImageEntity
	
	private var animalName: String
	
	init(animalName: String) {
		self.animalName = animalName
		self.path = "v1/search?query=\(animalName)"
	}
	
	var baseURL: String {
		NetworkConfiguration.BaseURL.image.rawValue
	}
	
	var method: HTTPMethod = .get
	
	var path: String
	
	var headers: [String : Any] = [
		"Authorization": "F0RsC7L6viQO7bzFmZTKs7hwGWhXlwm5TjAozyXUwkTmB8INisxbwjVg"
	]
	
	var body: [String : Any] = [:]
	
	func map(_ data: Data) throws -> ImageEntity {
		let decoded = try JSONDecoder().decode(ImageResponse.self, from: data)
		return ImageEntity(name: animalName, image: decoded.photos?.first?.src?.tiny ?? "")
	}
}

