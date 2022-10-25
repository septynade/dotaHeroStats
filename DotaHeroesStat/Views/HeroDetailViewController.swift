//
//  HeroDetailViewController.swift
//  DotaHeroesStat
//
//  Created by Ade Septian on 22/10/22.
//

import Kingfisher
import UIKit

class HeroDetailViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var attackTypeImageView: UIImageView!
    @IBOutlet weak var roleLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    ///Statistics
    @IBOutlet weak var baseAttackLabel: UILabel!
    @IBOutlet weak var baseStrLabel: UILabel!
    @IBOutlet weak var baseSpeedLabel: UILabel!
    @IBOutlet weak var baseHealthLabel: UILabel!
    @IBOutlet weak var baseIntLabel: UILabel!
    @IBOutlet weak var primaryAttrLabel: UILabel!
    
    //MARK: - Instances
    var vm: HeroDetailViewModel!
    
    //MARK: - Lifecycles
    init(vm: HeroDetailViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.vm = vm
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }
    
    //MARK: - Methods
    private func setUpViews() {
        collectionView.dataSource = self
        collectionView.register(HeroCollectionViewCell.self, forCellWithReuseIdentifier: HeroCollectionViewCell.identifier)
        
        mainImageView.kf.setImage(with: URL(string: "https://api.opendota.com\(vm.imageUrl)"))
        attackTypeImageView.image = UIImage(named: vm.attackTypeImage)
        
        roleLabel.text = vm.roleText
        nameLabel.text = vm.name
        
        baseAttackLabel.text = vm.baseAttack
        baseStrLabel.text = vm.baseStr
        
        baseSpeedLabel.text = vm.baseSpeed
        baseHealthLabel.text = vm.baseHealth
        
        baseIntLabel.text = vm.baseInt
        primaryAttrLabel.text = vm.primaryAttr
        
        roleLabel.superview?.layer.cornerRadius = 6.5
        collectionView.reloadData()
    }
}

//MARK: - CollectionView's methods
extension HeroDetailViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vm.similarHeroes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HeroCollectionViewCell.identifier, for: indexPath) as? HeroCollectionViewCell else {
            fatalError()
        }
        let hero = vm.similarHeroes[indexPath.row]
        let vm = HeroCollectionViewCell.ViewModel(name: hero.name, imageUrl: hero.imageUrl)
        cell.configure(with: vm)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / CGFloat(vm.similarHeroes.count)
        return CGSize(width: width, height: width)
    }
}
