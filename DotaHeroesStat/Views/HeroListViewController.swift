//
//  HeroListViewController.swift
//  DotaHeroesStat
//
//  Created by Ade Septian on 22/10/22.
//

import Combine
import UIKit

class HeroListViewController: UIViewController {
    //MARK: - Outlets
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let screenWidth = UIScreen.main.bounds.width
        let width = (screenWidth/3)-5
        layout.itemSize = CGSize(width: width, height: width)
        layout.minimumLineSpacing = 2.5
        layout.minimumInteritemSpacing = 2.5
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.systemBackground
        cv.delegate = self
        cv.dataSource = self
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(HeroCollectionViewCell.self, forCellWithReuseIdentifier: HeroCollectionViewCell.identifier)
        cv.showsVerticalScrollIndicator = false
        cv.collectionViewLayout = layout
        return cv
    }()
    
    private lazy var errorLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .secondaryLabel
        lbl.font = .systemFont(ofSize: 15)
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private lazy var indicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        indicator.style = .large
        indicator.color = .secondaryLabel
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private lazy var refreshButton: UIButton = {
        let button = UIButton()
        button.setTitle("Refresh", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.tintColor = .systemBlue
        button.backgroundColor = .systemBackground
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //MARK: - Instances
    private var vm: HeroListViewModel!
    private var coordinator: MainCoordinator!
    private var subscriptions = Set<AnyCancellable>()
    private let heroSubject = PassthroughSubject<AppEvent, Never>()

    
    //MARK: - Lifecycles
    init(vm: HeroListViewModel, coordinator: MainCoordinator) {
        super.init(nibName: nil, bundle: nil)
        self.vm = vm
        self.coordinator = coordinator
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bind()
        heroSubject.send(.viewDidLoad)
        PersistanceManager.shared.appHasLaunched()
    }
    
    //MARK: - Methods
    private func setupViews() {
        title = "Hero list"
        var menuItems: [UIAction] {
            return [
                UIAction(title: vm.roles[0].rawValue, state: .on, handler: { _ in self.changeFilter(to: 0) }),
                UIAction(title: vm.roles[1].rawValue, handler: { _ in self.changeFilter(to: 1) }),
                UIAction(title: vm.roles[2].rawValue, handler: { _ in self.changeFilter(to: 2) }),
                UIAction(title: vm.roles[3].rawValue, handler: { _ in self.changeFilter(to: 3) }),
                UIAction(title: vm.roles[4].rawValue, handler: { _ in self.changeFilter(to: 4) }),
                UIAction(title: vm.roles[5].rawValue, handler: { _ in self.changeFilter(to: 5) }),
                UIAction(title: vm.roles[6].rawValue, handler: { _ in self.changeFilter(to: 6) }),
                UIAction(title: vm.roles[7].rawValue, handler: { _ in self.changeFilter(to: 7) }),
                UIAction(title: vm.roles[8].rawValue, handler: { _ in self.changeFilter(to: 8) }),
                UIAction(title: vm.roles[9].rawValue, handler: { _ in self.changeFilter(to: 9) })
            ]
        }
        
        let menu = UIMenu(image: nil, identifier: nil, options: [.singleSelection], children: menuItems)
        let navItem = UIBarButtonItem(title: "Filter", menu: menu)
        navigationItem.rightBarButtonItem = navItem
        [indicatorView, errorLabel, collectionView, refreshButton].forEach { view.addSubview($0) }
        refreshButton.addTarget(self, action: #selector(didTapRefresh), for: .touchUpInside)
        setupConstraints()
    }
    
    private func setupConstraints() {
        collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 5).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -5).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        indicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        indicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        
        refreshButton.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 20).isActive = true
        refreshButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    private func bind() {
        let output = vm.transform(input: heroSubject.eraseToAnyPublisher())
        output.receive(on: RunLoop.main)
            .sink { [weak self] state in
            self?.render(state)
        }.store(in: &subscriptions)
    }
    
    private func render(_ state: AppState) {
        self.refreshButton.isHidden = true
        switch state {
        case .idle:
            self.collectionView.isHidden = true
            self.indicatorView.isHidden = true
            self.errorLabel.text = "Heroes will be shown here"
        case .loading:
            self.collectionView.isHidden = true
            self.errorLabel.isHidden = true
            self.indicatorView.isHidden = false
            self.indicatorView.startAnimating()
        case .success:
            self.indicatorView.stopAnimating()
            self.errorLabel.isHidden = true
            self.collectionView.isHidden = false
            self.collectionView.reloadData()
        case .failure(let error):
            self.indicatorView.stopAnimating()
            self.collectionView.isHidden = true
            self.errorLabel.isHidden = false
            self.refreshButton.isHidden = false
            self.errorLabel.text = error.errorMessage
        }
    }
    
    //MARK: - Events
    private func changeFilter(to index: Int) {
        heroSubject.send(.changeFilter(index))
    }
    
    @objc
    private func didTapRefresh() {
        heroSubject.send(.viewDidLoad)
    }
    
}

//MARK: - CollectionView's methods
extension HeroListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vm.filteredHeroes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HeroCollectionViewCell.identifier, for: indexPath) as? HeroCollectionViewCell else {
            fatalError()
        }
        let hero = vm.filteredHeroes[indexPath.row]
        let vm = HeroCollectionViewCell.ViewModel(name: hero.name, imageUrl: hero.imageUrl)
        cell.configure(with: vm)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vm = HeroDetailViewModel(model: vm.heroes[indexPath.row], heroes: vm.heroes)
        coordinator.showDetail(of: vm)
    }
}
