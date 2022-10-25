//
//  Coordinator.swift
//  DotaHeroesStat
//
//  Created by Ade Septian on 24/10/22.
//

import UIKit

class MainCoordinator {
    var navigationController: UINavigationController?
    
    func start() {
        let vc = HeroListViewController(vm: HeroListViewModel(), coordinator: self)
        navigationController?.setViewControllers([vc], animated: true)
    }
    
    func showDetail(of hero: HeroDetailViewModel) {
        let vc = HeroDetailViewController(vm: hero)
        navigationController?.pushViewController(vc, animated: true)
    }
}
