//
//  HeroModel.swift
//  DotaHeroesStat
//
//  Created by Ade Septian on 22/10/22.
//

import CoreData
import Foundation

struct HeroModel: Decodable{
    let name, primaryAttr, imageUrl, attackType : String
    let baseAgi, baseStr, baseInt, baseMana, baseHealth, baseAttackMin, baseAttackMax, baseSpeed: Int
    let roles: [String]
    
    enum CodingKeys: String, CodingKey {
        case imageUrl = "img"
        case name = "localized_name"
        case attackType = "attack_type"
        case primaryAttr = "primary_attr"
        case baseAgi = "base_agi"
        case baseStr = "base_str"
        case baseInt = "base_int"
        case baseHealth = "base_health"
        case baseAttackMin = "base_attack_min"
        case baseAttackMax = "base_attack_max"
        case baseSpeed = "move_speed"
        case baseMana = "base_mana"
        case roles = "roles"
    }
    
    init(model: Hero) {
        name = model.name ?? ""
        primaryAttr = model.primaryAttr ?? ""
        imageUrl = model.imageUrl ?? ""
        attackType = model.attackType ?? ""
        baseAgi = Int(model.baseAgi)
        baseStr = Int(model.baseStr)
        baseInt = Int(model.baseInt)
        baseMana = Int(model.baseMana)
        baseHealth = Int(model.baseHealth)
        baseAttackMin = Int(model.baseAttackMin)
        baseAttackMax = Int(model.baseAttackMax)
        baseSpeed = Int(model.baseSpeed)
        roles = model.roles ?? []
    }
    
    func toCoreDataModel(context: NSManagedObjectContext) -> Hero {
        let hero = Hero(context: context)
        hero.name = name
        hero.primaryAttr = primaryAttr
        hero.imageUrl = imageUrl
        hero.attackType = attackType
        hero.baseAgi = Int64(baseAgi)
        hero.baseStr = Int64(baseStr)
        hero.baseInt = Int64(baseInt)
        hero.baseMana = Int64(baseMana)
        hero.baseHealth = Int64(baseHealth)
        hero.baseAttackMin = Int64(baseAttackMin)
        hero.baseAttackMax = Int64(baseAttackMax)
        hero.baseSpeed = Int64(baseSpeed)
        hero.roles = roles
        return hero
    }
}
