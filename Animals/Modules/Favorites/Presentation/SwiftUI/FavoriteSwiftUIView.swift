//
//  FavoriteSwiftUIView.swift
//  Animals
//
//  Created by Santo Michael on 19/01/24.
//

import SwiftUI
import Combine

struct FavoriteView: View {
	@State private var dataSource: [ImageEntity] = []
	private var cancellables = CancelBag()
	
	var body: some View {
		NavigationView {
			ScrollView {
				LazyVGrid(columns: [
					GridItem(.flexible(), spacing: 7),
					GridItem(.flexible(), spacing: 7),
					GridItem(.flexible(), spacing: 7)
				], spacing: 7) {
					ForEach(dataSource, id: \.self) { item in
						DetailContentView(image: item.image) {
							deleteImage(item)
						}
						.aspectRatio(contentMode: .fit)
						.frame(maxWidth: .infinity, maxHeight: .infinity)
					}
					
				}
			}
			.scrollBounceBehavior(.basedOnSize)
			.toolbar(.hidden)
			.background(Color(UIColor(hex: "1E1C1C")))
			.frame(maxWidth: .infinity, maxHeight: .infinity)
			.listStyle(InsetGroupedListStyle())
			.onAppear {
				getImages()
			}
		}
	}
	
	private func getImages() {
		FavoriteUseCase().getImages()
			.map { Result.success($0) }
			.catch { Just(Result.failure($0)) }
			.sink { result in
				if case .failure = result {
					// Handle failure
				}
				
				if case let .success(images) = result {
					dataSource = images.map { $0 }
				}
			}
			.store(in: cancellables)
	}
	
	private func deleteImage(_ image: ImageEntity) {
		FavoriteUseCase().delete(image: image.image)
			.map { Result.success($0) }
			.catch { Just(Result.failure($0)) }
			.sink { result in
				if case .success = result {
					getImages()
				}
			}
			.store(in: cancellables)
	}
}
