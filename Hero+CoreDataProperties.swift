//
//  Hero+CoreDataProperties.swift
//  DotaHeroesStat
//
//  Created by Ade Septian on 25/10/22.
//
//

import Foundation
import CoreData


extension Hero {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Hero> {
        return NSFetchRequest<Hero>(entityName: "Hero")
    }

    @NSManaged public var name: String?
    @NSManaged public var primaryAttr: String?
    @NSManaged public var imageUrl: String?
    @NSManaged public var attackType: String?
    @NSManaged public var baseAgi: Int64
    @NSManaged public var baseStr: Int64
    @NSManaged public var baseInt: Int64
    @NSManaged public var baseSpeed: Int64
    @NSManaged public var baseMana: Int64
    @NSManaged public var baseHealth: Int64
    @NSManaged public var baseAttackMin: Int64
    @NSManaged public var baseAttackMax: Int64
    @NSManaged public var roles: [String]?

}

extension Hero : Identifiable {

}
