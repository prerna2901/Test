//
//  Article+CoreDataProperties.swift
//  AssigmentApp
//
//  Created by Prerna Chauhan on 02/07/20.
//  Copyright © 2020 Prerna Chauhan. All rights reserved.
//
//

import Foundation
import CoreData


extension Article {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Article> {
        return NSFetchRequest<Article>(entityName: "Article")
    }
    
    @NSManaged public var content: String?
    @NSManaged public var comments: String?
    @NSManaged public var likes: String?
    @NSManaged public var id: String?
    @NSManaged public var createAt: String?
    @NSManaged public var mediaImage: String?
    @NSManaged public var mediaUrl: String?
    @NSManaged public var userAvatar: String?
    @NSManaged public var mediaTitle: String?
    @NSManaged public var mediaBlogId: String?
    @NSManaged public var mediaCreatedAt: String?
    @NSManaged public var mediaId: String?
    @NSManaged public var userAbout: String?
    @NSManaged public var userBlogId: String?
    @NSManaged public var userCity: String?
    @NSManaged public var userCreatedAt: String?
    @NSManaged public var userDesignation: String?
    @NSManaged public var userId: String?
    @NSManaged public var userLastName: String?
    @NSManaged public var userName: String?
    
    
}
