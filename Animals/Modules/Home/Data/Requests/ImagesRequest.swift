//
//  ImagesRequest.swift
//  Animals
//
//  Created by Santo Michael on 17/01/24.
//

import Networking

internal struct ImagesRequest: APIRequest {
	
	typealias Response = [Image]
	
	private var animalName: String
	
	init(animalName: String) {
		self.animalName = animalName
		self.path = "v1/search?query=\(animalName)&per_page=18"
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
	
	func map(_ data: Data) throws -> [Image] {
		let decoded = try JSONDecoder().decode(ImageResponse.self, from: data)
		guard let photos = decoded.photos else { return [] }
		
		return photos.map {
			let url = ImageURL(tiny: $0.src?.tiny ?? "", large: $0.src?.large ?? "")
			return Image(name: animalName, url: url, showedImage: $0.src?.tiny ?? "")
		}
	}
}


