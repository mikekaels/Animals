//
//  ImageResponse.swift
//  Animals
//
//  Created by Santo Michael on 16/01/24.
//

import Foundation

internal struct ImageResponse: Codable {
	internal let totalResults, page, perPage: Int?
	internal let photos: [PhotoResponse]?
	internal let nextPage: String?
	
	enum CodingKeys: String, CodingKey {
		case totalResults = "total_results"
		case page
		case perPage = "per_page"
		case photos
		case nextPage = "next_page"
	}
}

// MARK: - Photo
internal struct PhotoResponse: Codable {
	internal let id, width, height: Int?
	internal let url: String?
	internal let photographer: String?
	internal let photographerUrl: String?
	internal let photographerId: Int?
	internal let avgColor: String?
	internal let src: SrcResponse?
	internal let liked: Bool?
	internal let alt: String?
	
	enum CodingKeys: String, CodingKey {
		case id, width, height, url, photographer
		case photographerUrl = "photographer_url"
		case photographerId = "photographer_id"
		case avgColor = "avg_color"
		case src, liked, alt
	}
}

internal struct SrcResponse: Codable {
	internal let original, large2X, large, medium: String?
	internal let small, portrait, landscape, tiny: String?
	
	enum CodingKeys: String, CodingKey {
		case original
		case large2X = "large2x"
		case large, medium, small, portrait, landscape, tiny
	}
}
