//
//  PostTileCell.swift
//  Graygram_Practice
//
//  Created by JHJG on 2017. 4. 7..
//  Copyright © 2017년 KangJungu. All rights reserved.
//

import UIKit

final class PostTileCell: UICollectionViewCell {
    
    var didTap: (() -> Void)?
    
    fileprivate let photoView = UIImageView().then {
        $0.backgroundColor = .lightGray
        $0.isUserInteractionEnabled = true
    }
    
    fileprivate let photoViewTapRecognizer = UITapGestureRecognizer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(self.photoView)
        
        self.photoViewTapRecognizer.addTarget(self, action: #selector(photoViewDidTap))
        self.photoView.addGestureRecognizer(self.photoViewTapRecognizer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Configuring
    
    func configure(post: Post) {
        self.photoView.setImage(with: post.photoID, size: .thumbnail)
    }
    
    
    // MARK: Size
    
    class func size(width: CGFloat, post: Post) -> CGSize {
        return CGSize(width: width, height: width) // 정사각형
    }
    
    
    // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.photoView.frame = self.contentView.bounds
    }
    
    
    // MARK: Actions
    
    func photoViewDidTap() {
        self.didTap?()
    }
    
}
