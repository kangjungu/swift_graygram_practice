//
//  PostCardCell.swift
//  Graygram_Practice
//
//  Created by JHJG on 2017. 4. 7..
//  Copyright © 2017년 KangJungu. All rights reserved.
//

import UIKit

final class PostCardCell: UICollectionViewCell {

    // MARK: Constants
    
    fileprivate struct Constant{
        static let messageLabelNumberOfLines = 3
    }
    
    fileprivate struct Metric{
        static let userPhotoViewLeft = 10.f
        static let userPhotoViewSize = 30.f
        
        static let usernameLabelLeft = 8.f
        static let usernameLabelRight = 10.f
        
        static let photoViewTop = 10.f
        
        static let likeButtonTop = 10.f
        static let likeButtonLeft = 10.f
        static let likeButtonSize = 20.f
        
        static let likeCountLabelLeft = 6.f
        
        static let messageLabelTop = 10.f
        static let messageLabelLeft = 10.f
        static let messageLabelRight = 10.f
    }
    
    fileprivate struct Font {
        static let usernameLabel = UIFont.boldSystemFont(ofSize: 13)
        static let likeCountLabel = UIFont.boldSystemFont(ofSize: 12)
        static let messageLabel = UIFont.systemFont(ofSize: 13)
    }

    
    // MARK: Properties
    
    fileprivate var post:Post?
    var didTap:(()->Void)?
    
    // MARK: UI
    
    fileprivate let userPhotoView = UIImageView().then{
        $0.layer.cornerRadius = Metric.userPhotoViewSize / 2
        //clipsToBounds : view 의 크기에 맞게 컨텐츠나 서브뷰가 잘려보이도록 할 수 있다.
        $0.clipsToBounds = true
    }
    
    fileprivate let usernameLabel = UILabel().then{
        $0.font = Font.usernameLabel
    }
    
    fileprivate let photoView = UIImageView().then{
        $0.backgroundColor = .lightGray
        //isUserInteractionEnabled:true로 설정하면 이벤트가 정상적으로 뷰로 전달됩니다. 이 속성의 기본값은 true입니다.
        $0.isUserInteractionEnabled = true
    }
    
    fileprivate let likeButton = UIButton().then{
        $0.setBackgroundImage(UIImage(named: "icon-like"), for: .normal)
        $0.setBackgroundImage(UIImage(named: "icon-like-selected"), for: .selected)
    }
    
    fileprivate let likeCountLabel = UILabel().then {
        $0.font = Font.likeCountLabel
    }
    
    fileprivate let messageLabel = UILabel().then {
        $0.font = Font.messageLabel
    }
    
    fileprivate let photoViewTapRecognizer = UITapGestureRecognizer()
    
    // MARK: Initializing
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.likeButton.addTarget(self, action: #selector(likeButtonDidTap), for: .touchUpInside)
        
        self.contentView.addSubview(self.userPhotoView)
        self.contentView.addSubview(self.usernameLabel)
        self.contentView.addSubview(self.photoView)
        self.contentView.addSubview(self.likeButton)
        self.contentView.addSubview(self.likeCountLabel)
        self.contentView.addSubview(self.messageLabel)
        
        self.photoViewTapRecognizer.addTarget(self, action: #selector(photoViewDidTap))
        self.photoView.addGestureRecognizer(self.photoViewTapRecognizer)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Configuring
    
    func configure(post:Post,isMessageTrimmed:Bool){
        self.post = post
        self.userPhotoView.setImage(with: post.user.photoID, size: .tiny)
        self.usernameLabel.text = post.user.username
        self.photoView.setImage(with: post.photoID, size: .hd)
        self.likeButton.isSelected = post.isLiked
        self.configureLikeCountLabel()
        self.messageLabel.text = post.message
        self.messageLabel.numberOfLines = isMessageTrimmed ? Constant.messageLabelNumberOfLines : 0
        self.messageLabel.isHidden = post.message?.isEmpty != false
        self.setNeedsLayout()
    }
    
    fileprivate func configureLikeCountLabel() {
        guard let likeCount = self.post?.likeCount else { return }
        if likeCount > 0 {
            self.likeCountLabel.text = "\(likeCount)명이 좋아합니다."
        } else {
            self.likeCountLabel.text = "가장 먼저 좋아요를 눌러보세요."
        }
    }
    
    // MARK: Size
    
    class func size(width: CGFloat, post: Post, isMessageTrimmed: Bool) -> CGSize {
        var height: CGFloat = 0
        height += Metric.userPhotoViewSize
        height += Metric.photoViewTop
        height += width // photoView height
        
        height += Metric.likeButtonTop
        height += Metric.likeButtonSize
        
        if let message = post.message, !message.isEmpty {
            let numberOfLines = isMessageTrimmed ? Constant.messageLabelNumberOfLines : 0
            let messageLabelSize = message.size(
                width: width - Metric.messageLabelLeft - Metric.messageLabelRight,
                font: Font.messageLabel,
                numberOfLines: numberOfLines
            )
            height += Metric.messageLabelTop
            height += messageLabelSize.height // messageLabel height
        }
        return CGSize(width: width, height: height)
    }
    
    // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.userPhotoView.left = Metric.userPhotoViewLeft
        self.userPhotoView.width = Metric.userPhotoViewSize
        self.userPhotoView.height = Metric.userPhotoViewSize
        
        self.usernameLabel.sizeToFit()
        self.usernameLabel.left = self.userPhotoView.right + Metric.usernameLabelLeft
        self.usernameLabel.width = min(
            self.usernameLabel.width,
            self.contentView.width - self.usernameLabel.left - Metric.usernameLabelRight
        )
        self.usernameLabel.centerY = self.userPhotoView.centerY
        
        self.photoView.top = self.userPhotoView.bottom + Metric.photoViewTop
        self.photoView.width = self.contentView.width
        self.photoView.height = self.photoView.width
        
        self.likeButton.top = self.photoView.bottom + Metric.likeButtonTop
        self.likeButton.left = Metric.likeButtonLeft
        self.likeButton.width = Metric.likeButtonSize
        self.likeButton.height = Metric.likeButtonSize
        
        self.likeCountLabel.sizeToFit()
        self.likeCountLabel.left = self.likeButton.right + Metric.likeCountLabelLeft
        self.likeCountLabel.centerY = self.likeButton.centerY
        
        if !self.messageLabel.isHidden {
            self.messageLabel.top = self.likeButton.bottom + Metric.messageLabelTop
            self.messageLabel.left = Metric.messageLabelLeft
            self.messageLabel.width = self.contentView.width - Metric.messageLabelLeft - Metric.messageLabelRight
            self.messageLabel.sizeToFit()
        }
    }
    
    // MARK: Networking
    
    func like() {
        guard let postID = self.post?.id else { return }
        NotificationCenter.default.post(
            name: .postDidLike,
            object: self,
            userInfo: ["postID": postID]
        )
        
        PostService.like(postID: postID) { response in
            switch response.result {
            case .success,
                 .failure where response.response?.statusCode != 409:
                print("post-\(postID) 좋아요 성공!")
                
            case .failure:
                print("post-\(postID) 좋아요 실패 ㅠㅠ")
                NotificationCenter.default.post(
                    name: .postDidUnlike,
                    object: self,
                    userInfo: ["postID": postID]
                )
            }
        }
        
    }
    
    func unlike() {
        guard let post = self.post, let postID = post.id else { return }
        NotificationCenter.default.post(
            name: .postDidUnlike,
            object: self,
            userInfo: ["postID": postID]
        )
        
        PostService.unlike(postID: postID) { response in
            switch response.result {
            case .success,
                 .failure where response.response?.statusCode != 409:
                print("post-\(postID) 좋아요 취소 성공!")
                
            case .failure:
                print("post-\(postID) 좋아요 취소 실패 ㅠㅠ")
                NotificationCenter.default.post(
                    name: .postDidLike,
                    object: self,
                    userInfo: ["postID": postID]
                )
            }
        }
    }
    
    // MARK: Actions
    
    func photoViewDidTap() {
        self.didTap?()
    }
    
    func likeButtonDidTap() {
        if !self.likeButton.isSelected {
            self.like()
        } else {
            self.unlike()
        }
    }
}
