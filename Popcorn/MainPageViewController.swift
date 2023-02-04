//
//  MainPageViewController.swift
//  Popcorn
//
//  Created by Admin on 03.02.2023.
//

import UIKit
import Alamofire

class MainPageViewController: UIViewController {

    @IBOutlet weak var segmentedController: UISegmentedControl!
    @IBOutlet weak var popularLabel: UILabel!
    @IBOutlet weak var popularCollectionView: UICollectionView!
    
    var popularMovieArray:[Result] = []
    var popularSerialsArray:[Results] = []
    let cellSize = CGSize(width: 335, height: 385)
    var minItemSpacing: CGFloat = 5
    //let cellCount = 40
    var previousIndex = 0
    
    let popularMovieURL = "https://api.themoviedb.org/3/movie/popular?api_key=7604dc04d5ee57bf0d3989b51605750e&language=ru-RU&page=1&region=UA"
    let popularSerialsURL = "https://api.themoviedb.org/3/tv/popular?api_key=7604dc04d5ee57bf0d3989b51605750e&language=ru-RU&page=1"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        segmentedController.selectedSegmentIndex = 0
        if segmentedController.selectedSegmentIndex == 0 {
            segmentedControllerClicked(self)
        }
        popularCollectionView.register(UINib(nibName: "PopularMovieTVShowCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PopularMovieTVShowCollectionViewCell")
        
        
        setupCollectionView()
    }
    
    @IBAction func segmentedControllerClicked(_ sender: Any) {
        switch segmentedController.selectedSegmentIndex{
            case 0:
                popularLabel.text = "Популярные фильмы"
                AF.request(popularMovieURL).responseDecodable(of: PopularMovie.self){[weak self] data in
                    guard let self = self else { return }
                    self.popularMovieArray = data.value?.results ?? []
                    self.popularCollectionView.reloadData()
                }
            
            case 1:
                popularLabel.text = "Популярные сериалы"
                AF.request(popularSerialsURL).responseDecodable(of: PopularSerials.self){[weak self] data in
                    guard let self = self else { return }
                    self.popularSerialsArray = data.value?.results ?? []
                    self.popularCollectionView.reloadData()
                }
            default:
                break
        }
    }
    
    func setupCollectionView() {
            popularCollectionView.contentInsetAdjustmentBehavior = .never
            let cellWidth: CGFloat = floor(cellSize.width)
            let insetX = (view.bounds.width - cellWidth) / 2.0
            
            popularCollectionView.contentInset = UIEdgeInsets(top: 0, left: insetX, bottom: 0, right: insetX)
            popularCollectionView.decelerationRate = .normal
            popularCollectionView.delegate = self
            popularCollectionView.dataSource = self
        }
    
    

}

extension MainPageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return popularMovieArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PopularMovieTVShowCollectionViewCell", for: indexPath) as! PopularMovieTVShowCollectionViewCell
        if segmentedController.selectedSegmentIndex == 0 {
            cell.configureCollectionViewForMovies(with: popularMovieArray[indexPath.item])
        }
        else{
            cell.configureCollectionViewForSerial(with: popularSerialsArray[indexPath.item])
        }
        //cell.configureCollectionViewForMovies(with: popularMovieArray[indexPath.item])
        
        return cell
    }
}

extension MainPageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return minItemSpacing
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }
        
        // MARK: Paging Effect
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let cellWidthIncludeSpacing = cellSize.width + minItemSpacing
            
        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludeSpacing
        let roundedIndex: CGFloat = round(index)
            
        offset = CGPoint(x: roundedIndex * cellWidthIncludeSpacing - scrollView.contentInset.left, y: scrollView.contentInset.top)
        targetContentOffset.pointee = offset
    }
    
    // MARK: Carousel Effect
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let cellWidthIncludeSpacing = cellSize.width + minItemSpacing
        let offsetX = popularCollectionView.contentOffset.x
        let index = (offsetX + popularCollectionView.contentInset.left) / cellWidthIncludeSpacing
        let roundedIndex = round(index)
        let indexPath = IndexPath(item: Int(roundedIndex), section: 0)
        if let cell = popularCollectionView.cellForItem(at: indexPath) {
            animateZoomforCell(zoomCell: cell)
        }
            
        if Int(roundedIndex) != previousIndex {
            let preIndexPath = IndexPath(item: previousIndex, section: 0)
                if let preCell = popularCollectionView.cellForItem(at: preIndexPath) {
                    animateZoomforCellremove(zoomCell: preCell)
                }
                previousIndex = indexPath.item
        }
    }
    
    func animateZoomforCell(zoomCell: UICollectionViewCell) {
            UIView.animate(
                withDuration: 0.2,
                delay: 0,
                options: .curveEaseOut,
                animations: {
                    zoomCell.transform = .identity
            },
                completion: nil)
    }
        
    func animateZoomforCellremove(zoomCell: UICollectionViewCell) {
            UIView.animate(
                withDuration: 0.2,
                delay: 0,
                options: .curveEaseOut,
                animations: {
                    zoomCell.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            },
                completion: nil)
            
    }
}
