//
//  ImageCoreDataEntity+CoreDataProperties.swift
//  Animals
//
//  Created by Santo Michael on 18/01/24.
//
//

import Foundation
import CoreData


extension ImageCoreDataEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ImageCoreDataEntity> {
        return NSFetchRequest<ImageCoreDataEntity>(entityName: "ImageCoreDataEntity")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var image: String?
    @NSManaged public var isLiked: Bool

}

extension ImageCoreDataEntity : Identifiable {

}
