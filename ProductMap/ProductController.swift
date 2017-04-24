//
//  ProductController.swift
//  ProductMap
//
//  Created by Bob De Kort on 4/22/17.
//  Copyright © 2017 Trevin Wisaksana. All rights reserved.
//

import UIKit

class ProductDetailController: UICollectionViewController, UICollectionViewDelegateFlowLayout, TopSpaceViewDelegate {
    
    // MARK: Fileprivate Variables
    
    fileprivate let reuseIdentifier = "Cell"
    fileprivate let descriptionId = "descriptionId"
    fileprivate let imageCellId = "imageCellId"
    fileprivate let titleCellId = "titleCellId"
    fileprivate let buttonsCellId = "buttonsCellId"
    
    // MARK: Variables
    
    let activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        return ai
    }()
    
    var product: Product?
    
    // MARK: ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .white
        // Register cell classes
        collectionView?.register(ImageScrollerCollectionViewCell.self, forCellWithReuseIdentifier: imageCellId)
        collectionView?.register(ProductDescriptionCell.self, forCellWithReuseIdentifier: descriptionId)
        collectionView?.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: titleCellId)
        collectionView?.register(ProductDetailButtons.self, forCellWithReuseIdentifier: buttonsCellId)
        
        collectionView?.backgroundColor = .white
        collectionView?.alwaysBounceVertical = true
        
        setupActivityMonitor()
    }
    
    func handleDirections(){
        print("map")
    }
    
    func handleContact(){
        print("contact")
    }
    
    func setupActivityMonitor(){
        activityIndicator.center = self.view.center
        self.view.addSubview(activityIndicator)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
    }
    
    func dismissViewController() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        // With map
        switch indexPath.item {
            // Image scroller
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imageCellId, for: indexPath) as! ImageScrollerCollectionViewCell
            if let url = product?.imageUrl {
                cell.imagesUrls = [url]
            }
            cell.delegate = self
            
            return cell
            // Title and city Label cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: titleCellId, for: indexPath) as! TitleCollectionViewCell
            cell.titleLabel.text = product?.title
            cell.cityLabel.text = product?.city
            return cell
            // Navigation and contact buttons
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: buttonsCellId, for: indexPath) as! ProductDetailButtons
            cell.navigationButton.addTarget(self, action: #selector(handleDirections), for: .touchUpInside)
            cell.contactButton.addTarget(self, action: #selector(handleContact), for: .touchUpInside)
            return cell
            // Description Cell
        case 3:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: descriptionId, for: indexPath) as! ProductDescriptionCell
            cell.textView.text = product?.productDescription
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch indexPath.item {
            // Image Scroller
        case 0:
            return CGSize(width: view.frame.width, height: 200)
            // Title and city label
        case 1:
            return CGSize(width: view.frame.width, height: 60)
            // Navigation and contact Button
        case 2:
            return CGSize(width: view.frame.width, height: 40)
            // Description
        case 3:
            let dummySize = CGSize(width: view.frame.width - 8 - 8, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin)
            let rect = descriptionAttributedText().boundingRect(with: dummySize, options: options, context: nil)
            
            return CGSize(width: view.frame.width, height: rect.height + 60)
        default:
            return CGSize(width: view.frame.width, height: 170)
        }
    }
    
    fileprivate func descriptionAttributedText() -> NSAttributedString {
        let attributedText = NSMutableAttributedString(string: "", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14)])
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 10
        
        let range = NSMakeRange(0, attributedText.string.characters.count)
        attributedText.addAttribute(NSParagraphStyleAttributeName, value: style, range: range)
        
        if let desc = product?.productDescription {
            attributedText.append(NSAttributedString(string: desc, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 15), NSForegroundColorAttributeName: UIColor.darkGray]))
        }
        
        return attributedText
    }
}
