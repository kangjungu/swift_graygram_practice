//
//  PostViewController.swift
//  Graygram_Practice
//
//  Created by JHJG on 2017. 4. 7..
//  Copyright © 2017년 KangJungu. All rights reserved.
//

import UIKit

class PostViewController: UIViewController {
    // MARK: Properties
    
    fileprivate let postID: Int
    fileprivate var post: Post?
    

    // MARK: UI
    
    fileprivate let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    fileprivate let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
        ).then {
            $0.backgroundColor = .clear
            $0.alwaysBounceVertical = true
            $0.register(PostCardCell.self, forCellWithReuseIdentifier: "cardCell")
    }
    fileprivate let errorMessageLabel = UILabel()
    fileprivate let refreshButton = UIButton(type: .system).then {
        $0.setTitle("새로고침", for: .normal)
    }
    
    
    // MARK: Initializing
    
    init(postID: Int, post: Post? = nil) {
        self.postID = postID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
