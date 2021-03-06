//
//  SearchViewController.swift
//  Giphy
//
//  Created by Admin on 9/2/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import SDWebImage

class SearchViewController: UIViewController {
    
    //MARK: - Types
    
    struct StoryboardIds {
        
        static let kGiphyCollectionViewCellReuseIdentifier = "GiphyCollectionViewCell"
        static let kSegueToDetailsVC = "segueToDetailsVC"
    }
    
    struct LayoutConstants {
        
        static let cellSectionInsetsLeft: CGFloat = 10.0
        static let cellSectionInsetsRight: CGFloat = 10.0
        static let cellMinSpacing: CGFloat = 10.0
        static let cellMultiplier: CGFloat = 58/67
    }
    
    // MARK: - Properties
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchTextFild: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    fileprivate var searchTag = ""
    fileprivate var giphys = [Giphy]()
    fileprivate let refreshControl = UIRefreshControl()
    
    // MARK: - Controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        
        flowLayout.invalidateLayout()
    }
    
    // MARK: - Private methods
    
    @objc private func refreshData(_ sender: Any) {
        view.endEditing(true)
        fetchAllGiphys(tag: searchTag)
    }
    
    //MARK: - Keyboard
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - Actions
    
    @IBAction func searchTextFieldEditingChanged(_ sender: UITextField) {
        
        if (sender.text?.characters.count)! > 0 {
            searchButton.isEnabled = true
        } else {
            searchButton.isEnabled = false
        }
    }
    
    @IBAction func searchAction(_ sender: Any) {
        view.endEditing(true)
        searchTag = searchTextFild.text!
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        fetchAllGiphys(tag: searchTag)
    }
    
    // APIs
    
    private func fetchAllGiphys(tag: String) {
    
        GiphyProvider.getGiphys(tag: tag, completion: { [weak self] (result) in
            guard let strongSelf = self else {
                return
            }
            
            switch(result) {
                
            case .success(let giphys):
                
                strongSelf.giphys = giphys
                strongSelf.collectionView.reloadData()
                strongSelf.refreshControl.endRefreshing()
                strongSelf.activityIndicator.stopAnimating()
                strongSelf.activityIndicator.isHidden = true
                break
            case .failure(_):
                strongSelf.refreshControl.endRefreshing()
                strongSelf.activityIndicator.stopAnimating()
                strongSelf.activityIndicator.isHidden = true
                break
            default: break
            }
        })
    }
    
    //MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == StoryboardIds.kSegueToDetailsVC{
            let vc = segue.destination as! DetailsViewController
            vc.giphy = sender as! Giphy
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.setNeedsLayout()
    }
}


// MARK: -  UICollectionViewDataSource

extension SearchViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return giphys.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell( withReuseIdentifier: StoryboardIds.kGiphyCollectionViewCellReuseIdentifier, for: indexPath) as! GiphyCollectionViewCell
        
        let giphy = giphys[indexPath.row]
        
        cell.imageView.sd_setImage(with:giphy.url , placeholderImage: #imageLiteral(resourceName: "ic_placeholder"))
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension SearchViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let giphy = giphys[indexPath.row]
        performSegue(withIdentifier: StoryboardIds.kSegueToDetailsVC, sender: giphy)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        let cellWidth = (UIScreen.main.bounds.size.width - (LayoutConstants.cellMinSpacing + LayoutConstants.cellSectionInsetsLeft + LayoutConstants.cellSectionInsetsRight)) / 2
        let cellHeight = cellWidth * LayoutConstants.cellMultiplier
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
}
