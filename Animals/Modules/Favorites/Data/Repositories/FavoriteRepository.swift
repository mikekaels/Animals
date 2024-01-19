//
//  FavoriteRepository.swift
//  Animals
//
//  Created by Santo Michael on 18/01/24.
//

import Foundation
import CoreData
import Combine

internal protocol ImageCoreDataRepositoryProtocol {
	func getAll() -> AnyPublisher<[ImageEntity], Error>
	func delete(image: String) -> AnyPublisher<Bool, Error>
	func create(image: ImageEntity) -> AnyPublisher<Bool, Error>
	func checkLikeStatusBy(image: String) -> Bool
}

internal class ImageCoreDataRepository {
	let container: NSPersistentContainer
	
	init(){
		container = NSPersistentContainer(name: "ImageCoreData")
		container.loadPersistentStores { description, error in
			if error != nil {
				fatalError("Cannot Load Core Data Model")
			}
		}
	}
}

extension ImageCoreDataRepository: ImageCoreDataRepositoryProtocol {
	func checkLikeStatusBy(image: String) -> Bool {
		let request = ImageCoreDataEntity.fetchRequest()
		request.fetchLimit = 1
		request.predicate = NSPredicate(
			format: "image = %@", image)
		let context =  container.viewContext
		
		do {
			if let todoCoreDataEntity = try context.fetch(request).first {
				return todoCoreDataEntity.isLiked
			}
			return false
		} catch {
			return false
		}
	}
	
	func getAll() -> AnyPublisher<[ImageEntity], Error> {
		let request = ImageCoreDataEntity.fetchRequest()
		do {
			let result: [ImageEntity] = try container.viewContext.fetch(request).map { item in
				return ImageEntity(name: item.name!, image: item.image!, isLiked: item.isLiked, id: item.id!)
			}
			
			return Future<[ImageEntity], Error> { promise in
				promise(.success(result))
			}.eraseToAnyPublisher()
		} catch {
			return Future<[ImageEntity], Error> { promise in
				promise(.failure(NSError(domain: "", code: 0)))
			}.eraseToAnyPublisher()
		}
	}
	
	func delete(image: String) -> AnyPublisher<Bool, Error> {
		let todoCoreDataEntity = getEntityByImage(image)!
		let context = container.viewContext;
		context.delete(todoCoreDataEntity)
		do{
			try context.save()
			return Future<Bool, Error> { promise in
				promise(.success(true))
			}.eraseToAnyPublisher()
		}catch{
			context.rollback()
		}
		return Future<Bool, Error> { promise in
			promise(.failure(NSError(domain: "can not delete", code: -1)))
		}.eraseToAnyPublisher()
	}
	
	func create(image: ImageEntity) -> AnyPublisher<Bool, Error> {
		let entity = ImageCoreDataEntity(context: container.viewContext)
		entity.id = image.id
		entity.isLiked = image.isLiked
		entity.name = image.name
		entity.image = image.image
		return saveContext()
	}
	
	
	private func getEntityByImage(_ image: String)  -> ImageCoreDataEntity? {
		let request = ImageCoreDataEntity.fetchRequest()
		request.fetchLimit = 1
		request.predicate = NSPredicate(
			format: "image = %@", image)
		let context = container.viewContext
		
		do {
			let todoCoreDataEntity = try context.fetch(request)[0]
			return todoCoreDataEntity
		} catch {
			return nil
		}
	}
	
	private func saveContext() -> AnyPublisher<Bool, Error> {
		let context = container.viewContext
		if context.hasChanges {
			do{
				try context.save()
				return Future<Bool, Error> { promise in
					promise(.success(true))
				}.eraseToAnyPublisher()
			}catch{
				return Future<Bool, Error> { promise in
					promise(.failure(NSError(domain: "can not save", code: -1)))
				}.eraseToAnyPublisher()
			}
		}
		
		return Future<Bool, Error> { promise in
			promise(.failure(NSError(domain: "can not save", code: -1)))
		}.eraseToAnyPublisher()
	}
	
}
