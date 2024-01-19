//
//  ImagesRequest.swift
//  Animals
//
//  Created by Santo Michael on 17/01/24.
//

import Networking

internal struct ImagesRequest: APIRequest {
	
	typealias Response = [ImageEntity]
	
	private var animalName: String
	
	init(animalName: String, page: Int, perPage: Int) {
		self.animalName = animalName
		self.path = "v1/search?query=\(animalName)&per_page=\(perPage)&page=\(page)"
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
	
	func map(_ data: Data) throws -> [ImageEntity] {
		let decoded = try JSONDecoder().decode(ImageResponse.self, from: data)
		guard let photos = decoded.photos else { return [] }
		
		return photos.map {
			return ImageEntity(name: animalName, image: $0.src?.tiny ?? "")
		}
	}
}


