//
//  FeedViewController.swift
//  Graygram_Practice
//
//  Created by JHJG on 2017. 4. 7..
//  Copyright © 2017년 KangJungu. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {
    
    
    //MARK:Constants
    fileprivate struct Metric{
        static let cardCellSpacing = CGFloat(20)
        static let tileCellSpacing = CGFloat(3)
    }
    
    //MARK: Properties
    
    fileprivate var viewMode:FeedViewMode = .card{
        didSet{
            switch self.viewMode {
            case .card:
                self.navigationItem.leftBarButtonItem = self.tileButtonItem
            case .tile:
                self.navigationItem.leftBarButtonItem = self.cardButtonItem
            }
            self.collectionView.reloadData()
        }
    }
    fileprivate var posts:[Post] = []
    fileprivate var nextURLString: String?
    fileprivate var isLoading:Bool = false
    
    //MARK: UI
    
    fileprivate let tileButtonItem = UIBarButtonItem(image: UIImage(named:"icon-tile"), style: .plain, target: nil, action: nil)
    fileprivate let cardButtonItem = UIBarButtonItem(image: UIImage(named:"icon-card"), style: .plain, target: nil, action: nil)
    fileprivate let refreshControler = UIRefreshControl()
    fileprivate let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.backgroundColor = .white
        //이 property를 true로 설정해, bounces가 true의 경우, 컨텐츠가 스크롤 · 뷰의 경계보다 작은 경우에서도, 수직 방향의 드래그는 허가됩니다. 기본값은 false입니다.
        $0.alwaysBounceVertical = true
        //Identifier로 셀모양을 미리 등록해놓는것인듯함.
        $0.register(PostCardCell.self, forCellWithReuseIdentifier: "cardCell")
        $0.register(PostTileCell.self, forCellWithReuseIdentifier: "tileCell")
    }
    
    //MARK:Initializing
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        self.tabBarItem.title = "Feed"
        self.tabBarItem.image = UIImage(named: "tab-feed")
        self.tabBarItem.selectedImage = UIImage(named: "tab-feed-selected")
        self.navigationItem.leftBarButtonItem = self.tileButtonItem
        
        self.tileButtonItem.target = self
        self.tileButtonItem.action = #selector(tileButtonItemDidTap)
        self.cardButtonItem.target = self
        self.cardButtonItem.action = #selector(cardButtonItemDidTap)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView = UILabel().then{
            $0.font = UIFont(name: "IowanOldStyle-BoldItalic", size: 20)
            $0.text = "Graygram"
            $0.sizeToFit()
        }
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(CollectionActivityIndicatorView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "activityIndicatorView")
        
        self.refreshControler.addTarget(self, action: #selector(self.refreshControlDidChangeValue), for: .valueChanged)
        
        NotificationCenter.default.addObserver(self, selector: #selector(postDidLike), name: .postDidLike, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(postDidUnlike), name: .postDidUnlike, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(postDidCreate), name: .postDidCreate, object: nil)
        
        self.collectionView.addSubview(self.refreshControler)
        self.view.addSubview(self.collectionView)
        
        self.collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.fetchFeed(paging:.refresh)
        
    }
    // MARK: Networking
    
    fileprivate func fetchFeed(paging:Paging){
        guard !self.isLoading else{return}
        self.isLoading = true
    
        FeedService.feed(paging: paging) { [weak self] response in
            guard let `self` = self else{
                return
            }
            self.refreshControler.endRefreshing()
            self.isLoading = false
            
            switch response.result{
            case .success(let feed):
                let newPosts = feed.value?.posts ?? []
                switch paging {
                case .refresh:
                    self.posts = newPosts
                case .next:
                    self.posts.append(contentsOf: newPosts)
                }
                self.nextURLString = feed.value?.nextURLString
                self.collectionView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // MARK: Actions
    
    fileprivate dynamic func tileButtonItemDidTap() {
        self.viewMode = .tile
    }
    
    fileprivate dynamic func cardButtonItemDidTap() {
        self.viewMode = .card
    }
    fileprivate dynamic func refreshControlDidChangeValue() {
        self.fetchFeed(paging: .refresh)
    }
    
    // MARK: Notifications
    
    func postDidLike(_ notification: Notification) {
        guard let postID = notification.userInfo?["postID"] as? Int else { return }
        for (i, var post) in self.posts.enumerated() {
            if post.id == postID {
                post.likeCount! += 1
                post.isLiked = true
                self.posts[i] = post
                self.collectionView.reloadData()
                break
            }
        }
    }

    
    
    func postDidUnlike(_ notification: Notification) {
        guard let postID = notification.userInfo?["postID"] as? Int else { return }
        for (i, var post) in self.posts.enumerated() {
            if post.id == postID {
                post.likeCount! = max(0, post.likeCount! - 1)
                post.isLiked = false
                self.posts[i] = post
                self.collectionView.reloadData()
                break
            }
        }
    }
    
    func postDidCreate(_ notification:Notification){
        guard let post = notification.userInfo?["post"] as? Post else{
            return
        }
        self.posts.insert(post, at: 0)
        self.collectionView.reloadData()
    }

}

// MARK: - UICollectionViewDataSource

extension FeedViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let post = self.posts[indexPath.item]
        switch self.viewMode {
        case .card:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cardCell", for: indexPath) as! PostCardCell
            cell.configure(post: post, isMessageTrimmed: true)
            cell.didTap = { [weak self] in
                let postViewController = PostViewController(postID: post.id, post: post)
                self?.navigationController?.pushViewController(postViewController, animated: true)
            }
            return cell
            
        case .tile:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tileCell", for: indexPath) as! PostTileCell
            cell.configure(post: post)
            cell.didTap = { [weak self] in
                let postViewController = PostViewController(postID: post.id, post: post)
                self?.navigationController?.pushViewController(postViewController, animated: true)
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let isLastSection = indexPath.section == collectionView.numberOfSections - 1
        let isFooter = kind == UICollectionElementKindSectionFooter
        if isLastSection && isFooter {
            return collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: "activityIndicatorView",
                for: indexPath
            )
        }
        return UICollectionReusableView()
    }
    
}


// MARK: - UICollectionViewDelegateFlowLayout

extension FeedViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.frame.width
        switch self.viewMode {
        case .card:
            return PostCardCell.size(
                width: collectionViewWidth,
                post: self.posts[indexPath.item],
                isMessageTrimmed: true
            )
            
        case .tile:
            let cellWidth = round((collectionViewWidth - 2 * Metric.tileCellSpacing) / 3)
            return PostTileCell.size(width: cellWidth, post: self.posts[indexPath.item])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch self.viewMode {
        case .card:
            return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
            
        case .tile:
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch self.viewMode {
        case .card:
            return Metric.cardCellSpacing
            
        case .tile:
            return Metric.tileCellSpacing
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        switch self.viewMode {
        case .card:
            return 0
            
        case .tile:
            return Metric.tileCellSpacing
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetBottom = scrollView.contentOffset.y + scrollView.height
        let didReachBottom = scrollView.contentSize.height > 0
            && contentOffsetBottom >= scrollView.contentSize.height - 300
        if let nextURLString = self.nextURLString, didReachBottom{
            self.fetchFeed(paging: .next(nextURLString))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let height: CGFloat = (self.nextURLString != nil || self.posts.isEmpty) ? 44 : 0
        return CGSize(width: collectionView.width, height: height)
    }
    
}
