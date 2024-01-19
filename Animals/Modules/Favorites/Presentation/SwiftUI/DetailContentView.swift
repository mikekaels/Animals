//
//  DetailContentView.swift
//  Animals
//
//  Created by Santo Michael on 19/01/24.
//

import SwiftUI
import Kingfisher

struct DetailContentView: View {
	@State private var isLiked = false
	@State private var loveIconSize: CGFloat = 100
	@State private var loveIconOffset: CGSize = CGSize(width: 100, height: 100)
	@State private var loveIconOpacity: Double = 1
	
	let image: String
	let onDoubleTap: () -> Void
	
	var body: some View {
		GeometryReader { geometry in
			ZStack {
				Rectangle()
					.foregroundColor(Color.blue)
				
				KFImage(URL(string: image))
					.resizable()
					.aspectRatio(contentMode: .fill)
					.layoutPriority(-1)
					.clipped()
				
				Image(systemName: "heart.fill")
					.resizable()
					.aspectRatio(contentMode: .fit)
					.frame(width: 25, height: 25)
					.foregroundColor(Color.white)
					.opacity(loveIconOpacity)
					.position(x: 20, y: geometry.size.height - 20)
			}
			.aspectRatio(1, contentMode: .fit)
			.clipped()
			.gesture(
				TapGesture(count: 2)
					.onEnded {
						doubleTapHandler()
					}
			)
		}
	}
	
	private func doubleTapHandler() {
		withAnimation(Animation.easeOut(duration: 0.75)) {
			loveIconOpacity = 0.0
			onDoubleTap()
		}
	}
}
