//
//  HeroDetailViewModel.swift
//  DotaHeroesStat
//
//  Created by Ade Septian on 25/10/22.
//

import Combine
import Foundation

final class HeroDetailViewModel {
    //MARK: - Published properties
    @Published private(set) var name = ""
    @Published private(set) var attackTypeImage = ""
    @Published private(set) var imageUrl = ""
    @Published private(set) var baseAttack = ""
    @Published private(set) var baseStr = ""
    @Published private(set) var baseSpeed = ""
    @Published private(set) var baseHealth = ""
    @Published private(set) var baseInt = ""
    @Published private(set) var primaryAttr = ""
    @Published private(set) var roleText = ""
    @Published private(set) var similarHeroes = [HeroModel]()
    private var heroes: [HeroModel] = []
    
    //MARK: - Lifecycles
    init(model: HeroModel, heroes: [HeroModel]) {
        self.heroes = heroes
        name = model.name
        imageUrl = model.imageUrl
        baseAttack = "\(model.baseAttackMin) - \(model.baseAttackMax)"
        baseStr = "\(model.baseStr)"
        baseSpeed = "\(model.baseSpeed)"
        baseHealth = "\(model.baseHealth)"
        baseInt = "\(model.baseInt)"
        primaryAttr = model.primaryAttr
        attackTypeImage = getAttackTypeImage(type: model.attackType)
        roleText = getRoles(model.roles)
        similarHeroes = getSimilarHeroes()
    }
    
    deinit {
        similarHeroes = []
    }
    
    //MARK: - Helpers
    private func getAttackTypeImage(type: String) -> String {
        let attackType = AttackType(rawValue: type) ?? .melee
        return attackType == .melee ? "ic_melee" : "ic_ranged"
    }
    
    private func getRoles(_ roles: [String]) -> String {
        var string = ""
        for (index, role) in roles.enumerated() {
            if index == roles.count - 1 {
                string.append("\(role)")
            } else {
                string.append("\(role), ")
            }
        }
        
        return string
    }
    
    private func getSimilarHeroes() -> [HeroModel] {
        let attr = primaryAttribute(rawValue: primaryAttr) ?? .str
        let sameAttr = heroes.filter { $0.primaryAttr == primaryAttr }
        
        var sorted: [HeroModel] = []
        var result: [HeroModel] = []
        
        switch attr {
        case .agi:
            sorted = sameAttr.sorted(by: { $0.baseSpeed > $1.baseSpeed })
        case .int:
            sorted = sameAttr.sorted(by: { $0.baseMana > $1.baseMana })
        case .str:
            sorted = sameAttr.sorted(by: { $0.baseAttackMax > $1.baseAttackMax })
        }
        
        for hero in sorted {
            if result.count < 3 {
                result.append(hero)
            } else {
                break
            }
        }
        
        return result
    }
}
