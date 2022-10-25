//
//  HeroViewModel.swift
//  DotaHeroesStat
//
//  Created by Ade Septian on 22/10/22.
//

import Combine
import Foundation

final class HeroListViewModel {
    //MARK: - Private properties
    private let networkManager: NetworkService
    private let persistanceManager = PersistanceManager.shared
    private var page = 1
    private let output = PassthroughSubject<AppState, Never>()
    private var subscriptions = Set<AnyCancellable>()
    
    //MARK: - Published properties
    @Published private(set) var roles: [HeroRoles] = [.all, .carry, .support, .nuker, .disabler, .jungler, .durable, .escape, .pusher, .initiator]
    @Published private(set) var selectedFilter: HeroRoles = .all
    @Published private(set) var heroes: [HeroModel] = []
    @Published private(set) var filteredHeroes: [HeroModel] = []
    
    //MARK: - Lifecycles
    init(networkManager: NetworkService = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    //MARK: - Helpers
    public func transform(input: AnyPublisher<AppEvent, Never>) -> EventOutput {
        input.sink { [weak self] event in
            switch event {
            case .viewDidLoad:
                self?.fetchHeroes()
            case .changeFilter(let index):
                self?.filterHeroesBy(role: index)
            }
        }.store(in: &subscriptions)
        
        return output.eraseToAnyPublisher()
    }
    
    public func filterHeroesBy(role index: Int) {
        output.send(.loading)
        selectedFilter = roles[index]
        
        let filtered = heroes.filter { hero in
            hero.roles.contains(selectedFilter.rawValue)
        }
        
        filteredHeroes = selectedFilter == .all ? heroes : filtered
        output.send(.success)
    }
    
    private func fetchHeroesFromCache() {
        output.send(.loading)
        let coreDataHeroes = persistanceManager.fetchHeroes().map { (hero) -> HeroModel in
            HeroModel(model: hero)
        }
        
        heroes = coreDataHeroes
        filteredHeroes = coreDataHeroes
        output.send(.success)
    }
    
    //MARK: - Network calls
    private func fetchHeroes() {
        if persistanceManager.isFirstLaunch() {
            output.send(.loading)
            networkManager.request(expecting: [HeroModel].self)
                .sink { [weak self] completion in
                    if case .failure(let error) = completion {
                        self?.output.send(.failure(error))
                    }
            } receiveValue: { [weak self] heroes in
                guard heroes.count > 0 else {
                    self?.output.send(.failure(.emptyData))
                    return
                }
                
                self?.persistanceManager.createHeroes(heroModels: heroes)
                self?.heroes = heroes
                self?.filteredHeroes = heroes
                self?.output.send(.success)
            }.store(in: &subscriptions)
        } else {
            fetchHeroesFromCache()
        }
    }
}
