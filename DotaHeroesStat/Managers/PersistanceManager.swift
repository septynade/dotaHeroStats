//
//  PersistanceManager.swift
//  DotaHeroesStat
//
//  Created by Ade Septian on 22/10/22.
//

import CoreData
import UIKit

final class PersistanceManager {
    static let shared = PersistanceManager()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func fetchHeroes() -> [Hero] {
        do {
            let heroes = try context.fetch(Hero.fetchRequest())
            return heroes
        } catch let error as NSError {
            print(error)
        }
        
        return []
    }
    
    func createHeroes(heroModels: [HeroModel]) {
        deleteAll()
        
        for heroModel in heroModels{
            let _ = heroModel.toCoreDataModel(context: context)
        }
        
        do {
            try context.save()
        } catch let error as NSError {
            print(error)
        }
    }
    
    func deleteAll(){
        let heroes = fetchHeroes()
        for a in heroes{
            context.delete(a)
        }
        
        do {
            try context.save()
        } catch let error as NSError {
            print(error)
        }
    }
    
    func isFirstLaunch() -> Bool {
        let isFirstLaunch = UserDefaults.standard.bool(forKey: "isFirstLaunch")
        return isFirstLaunch
    }
    
    func appHasLaunched() {
        UserDefaults.standard.set(false, forKey: "isFirstLaunch")
    }
}
