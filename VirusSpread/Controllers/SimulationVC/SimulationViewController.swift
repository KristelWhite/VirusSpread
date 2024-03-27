//
//  SimulationViewController.swift
//  VirusSpread
//
//  Created by Кристина Пастухова on 26.03.2024.
//

import UIKit

struct Person {
    var isInfected: Bool
}
class SimulationViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    private var headerView: HeaderView!
    
    var groupSize: Int = 0
    var infectionFactor: Int = 0
    var peroidUpdating : Int = 0
    
    private var people: [Person] = []
    private var numberOfColumns: Int = 5
    
    private var totalInfectedIndexPaths:  Set<IndexPath> = []
    private var infectedIndexPaths: Set<IndexPath> = [] //
    private var newInfectedIndexPaths: Set<IndexPath> = []
    private var nextRoundInfected: Set<IndexPath> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureProperties()
        configureGesture()
        
        configureBackButton()
        configureHeaderView()
        configureCollectionView(with: collectionView)
        
        self.view.backgroundColor = .systemGray6
        
        if  peroidUpdating > 0 {
            Timer.scheduledTimer(timeInterval: TimeInterval(peroidUpdating), target: self, selector: #selector(recountOfPatients), userInfo: nil, repeats: true)
        }
    }
    
    func configureGesture(){
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture(_:)))
        collectionView.addGestureRecognizer(pinchGesture)
    }
    
    func configureProperties(){
        if groupSize > 0 {
            people = Array(repeating: Person(isInfected: false), count: groupSize)
            //            numberOfColumns = Int(ceil(sqrt(Double(groupSize))))
        }
        
    }
    
    @objc func recountOfPatients(){
        infectPeople()
        let infectedCount = totalInfectedIndexPaths.count
        let healtyCount = people.count - infectedCount
        updateHeader(withHealtyCount: healtyCount, withInfectedCount: infectedCount)
    }
    
    func configureCollectionViewLayout(){
        let layout = UICollectionViewFlowLayout()
        let padding: CGFloat = 10
        layout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        collectionView.collectionViewLayout = layout
        
    }
    
    @objc func handlePinchGesture(_ gesture: UIPinchGestureRecognizer) {
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
        switch gesture.state {
        case .began, .changed:
            let scale = gesture.scale
            let newCellSize = CGSize(width: layout.itemSize.width * scale, height: layout.itemSize.height * scale)
            
            layout.itemSize = newCellSize.clamped(min: CGSize(width: 50, height: 50), max: CGSize(width: 200, height: 200))
            layout.invalidateLayout()
            gesture.scale = 1.0
        default:
            break
        }
    }
    
    
    func configureHeaderView(){
        headerView = HeaderView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 100))
        updateHeader(withHealtyCount: people.count, withInfectedCount: 0)
        view.addSubview(headerView)
        setupConstraints(for: headerView)
    }
    
    private func updateHeader(withHealtyCount: Int, withInfectedCount: Int){
        headerView.configure(withHealtyCount: withHealtyCount, withInfectedCount: withInfectedCount)
    }
    
    private func setupConstraints(for headerView: HeaderView) {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor), headerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: headerView.frame.height), headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor), headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor)])
    }
    
    
    func configureCollectionView(with collectionView: UICollectionView){
        collectionView.register(UINib(nibName: "\(HumanCollectionViewCell.self)", bundle: nil), forCellWithReuseIdentifier: "\(HumanCollectionViewCell.self)")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = true
        setupConstraints(for: collectionView)
        configureCollectionViewLayout()
    }
    
    private func setupConstraints(for collectionView: UICollectionView) {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([collectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 0), collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor), collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor), collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)])
    }
    
    private func configureBackButton(){
        let image = UIImage(named: "back.button")?.withRenderingMode(.alwaysOriginal)
        let backImage = image?.withTintColor(.black)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(backButtonPressed))
    }
    
    @objc func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
    
}

extension SimulationViewController {
    
    func infectPeople() {
        newInfectedIndexPaths = []
        nextRoundInfected = []
        
        let dispatchGroup = DispatchGroup()
        let infectionQueue = DispatchQueue(label: "com.VirusSpread.infectionQueue", attributes: .concurrent)
        
        for indexPath in infectedIndexPaths {
            dispatchGroup.enter()
        
            infectionQueue.async {
                self.processInfection(for: indexPath, infectionQueue: infectionQueue, dispatchGroup: dispatchGroup)

                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.wait()
        
        let allNextRoundInfected = nextRoundInfected.union(newInfectedIndexPaths)
        infectedIndexPaths = allNextRoundInfected
        totalInfectedIndexPaths.formUnion(infectedIndexPaths)
       
        DispatchQueue.main.async { [weak self] in
            self?.updateCollectionView(newInfectedIndexPaths: self?.newInfectedIndexPaths ?? [])
            self?.newInfectedIndexPaths.removeAll()
        }
        
    }
    
    private func updateCollectionView(newInfectedIndexPaths: Set<IndexPath>){
        self.collectionView.performBatchUpdates({
            self.collectionView.reloadItems(at: Array(newInfectedIndexPaths))
        }, completion: nil)
    }
    
    private func processInfection(for indexPath: IndexPath, infectionQueue: DispatchQueue, dispatchGroup: DispatchGroup)  {
        dispatchGroup.enter()
        
        let index = indexPath.item
        let row = index / numberOfColumns
        let col = index % numberOfColumns
        
        var localNewInfected = Set<IndexPath>()
        var localNextRound = Set<IndexPath>()
        
        let neighbors = [((row-1)*numberOfColumns + col), ((row+1)*numberOfColumns + col), (row*numberOfColumns + col-1), (row*numberOfColumns + col+1), ((row-1)*numberOfColumns + col-1), ((row-1)*numberOfColumns + col+1), ((row+1)*numberOfColumns + col-1), ((row+1)*numberOfColumns + col+1) ]
        
        var allNeighborsInfected = true
        
        var existNeighbors: [Int] = []
        for neighborIndex in neighbors where neighborIndex >= 0 && neighborIndex < people.count {
            existNeighbors.append(neighborIndex)
        }
        
        var newInfectedArray: [Int] = []
        if existNeighbors.count <= self.infectionFactor {
            newInfectedArray = existNeighbors
        } else {
            newInfectedArray = [Int](existNeighbors.shuffled().prefix(self.infectionFactor))
        }
        
        existNeighbors.forEach { neighborIndex in
            if !people[neighborIndex].isInfected{
                allNeighborsInfected = false
            }
        }
        
        if !allNeighborsInfected {
            infectionQueue.async(flags: .barrier) {
                localNextRound.insert(indexPath)
            }
        }
        infectionQueue.async(flags: .barrier) {
            
            newInfectedArray.forEach{ infected in
                if !self.people[infected].isInfected {
                    localNewInfected.insert(IndexPath(item: infected, section: 0))
                    self.people[infected].isInfected = true
                }
            }
            self.newInfectedIndexPaths.formUnion(localNewInfected)
            self.nextRoundInfected.formUnion(localNextRound)
            dispatchGroup.leave()
        }
        
    }
    
}




//MARK: - UICollectionViewDataSource
extension SimulationViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        people.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(HumanCollectionViewCell.self)", for: indexPath) as? HumanCollectionViewCell
        guard let cell = cell else { return UICollectionViewCell() }
        let person = people[indexPath.item]
        cell.configure(with: person.isInfected)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        infectedIndexPaths.insert(indexPath)
        if let cell = collectionView.cellForItem(at: indexPath) as? HumanCollectionViewCell {
            cell.configure(with: true)
            let infectedCount = totalInfectedIndexPaths.count
            let healtyCount = people.count - infectedCount
            updateHeader(withHealtyCount: healtyCount, withInfectedCount: infectedCount)
        }
        
    }
    
    
}
//MARK: - UICollectionViewDelegate
extension SimulationViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout  {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size: CGFloat = (collectionView.frame.width - 20) / CGFloat(numberOfColumns)
        return CGSize(width: size, height: size)
    }
    
    
}


extension CGSize {
    func clamped(min: CGSize, max: CGSize) -> CGSize {
        let newWidth = Swift.max(min.width, Swift.min(self.width, max.width))
        let newHeight = Swift.max(min.height, Swift.min(self.height, max.height))
        return CGSize(width: newWidth, height: newHeight)
    }
}
