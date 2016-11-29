//
//  HomeViewController.swift
//  DouYuTV
//
//  Created by 胡明昊 on 16/11/22.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import UIKit

private let kTitleViewH: CGFloat = 40

class HomeViewController: UIViewController {
    
    fileprivate var pageContentView: PageContentView!
    
    fileprivate lazy var pageTitleView: PageTitleView = {
        
        let pageTitleRect = CGRect(x: 0, y: HmhDevice.navigationBarH, width: HmhDevice.screenW, height: kTitleViewH)
        let pageTitleView = PageTitleView(frame: pageTitleRect, isScrollEnable: false, titles: C.pageTitles)
        pageTitleView.delegate = self
        return pageTitleView
    }()
    
    fileprivate lazy var childVcs: [UIViewController]! = {
      
        var childVcs = [UIViewController]()
        let recommentVC = RecommentViewController()
        childVcs.append(recommentVC)
        
        let gameVc = GameViewController()
        childVcs.append(gameVc)
        
        let entertainmentVC = EntertainmentController()
        childVcs.append(entertainmentVC)
        
        let MGameVC = MGameViewController()
        childVcs.append(MGameVC)
        
        let FunVC = FunViewController()
        childVcs.append(FunVC)
        
        return childVcs
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavgationBar()
        
        setupUI()
    }
    
    
    private func setupUI() {
        
        // 创建首页标题栏
        view.addSubview(self.pageTitleView)
        
        // 创建容器视图
        let contentRect = CGRect(x: 0, y: HmhDevice.navigationBarH + kTitleViewH, width: HmhDevice.screenW, height: HmhDevice.screenH - pageTitleView.height - HmhDevice.navigationBarH - HmhDevice.tabBarH)
        
        let pageContentView = PageContentView(frame: contentRect, childVcs: self.childVcs!, parentViewController: self)
        pageContentView.delegate = self
        self.pageContentView = pageContentView
        
        view.addSubview(pageContentView)
        
        // 设置导航栏消失和隐藏
        for vc in childVcs {
            let baseVC = vc as? BaseViewController
            baseVC?.hiddenBlock = { [weak self] in
                self?.navigationController?.setNavigationBarHidden($0, animated: $1)
                let offsetYY: CGFloat = $0 ? -HmhDevice.kNavigationBarH : HmhDevice.kNavigationBarH
                UIView.animate(withDuration: 0.3, animations: {
                    self?.pageTitleView.top += offsetYY
                    self?.pageContentView.top += offsetYY
                    self?.pageContentView.height -= offsetYY
                })
                if offsetYY > 0 {
                    
                    let layout = UICollectionViewFlowLayout()
                    layout.itemSize = (self?.pageContentView.bounds.size)!
                    layout.minimumLineSpacing = 0
                    layout.minimumInteritemSpacing = 0
                    layout.scrollDirection = .horizontal
                    self?.pageContentView.collectionView.setCollectionViewLayout(layout, animated: false)
                    self?.pageContentView.collectionView.height -= offsetYY
                }else {
                    self?.pageContentView.collectionView.height -= offsetYY
                    let layout = UICollectionViewFlowLayout()
                    layout.itemSize = (self?.pageContentView.bounds.size)!
                    layout.minimumLineSpacing = 0
                    layout.minimumInteritemSpacing = 0
                    layout.scrollDirection = .horizontal
                    self?.pageContentView.collectionView.setCollectionViewLayout(layout, animated: false)
                }
            }
        }
    }
    
    
    func RefreshData() {
        print("刷新数据")
    }
}



extension HomeViewController {
    
    // MARK: - 设置导航栏内容
    fileprivate func setupNavgationBar() {

        //不需要调整UIScrollView的内边距
        automaticallyAdjustsScrollViewInsets = false
        
        // 设置导航栏
        setupnavigationLeft()
        setupnavigationRight()
        
    }
    
    fileprivate func setupnavigationLeft() {
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "homeLogoIcon"), highlightImage: nil, size: nil, target: self, action: #selector(RefreshData))
    }
    
    fileprivate func setupnavigationRight() {
        
        let size = CGSize(width: 40, height: 44)
        
        let historyItem = UIBarButtonItem(image: #imageLiteral(resourceName: "viewHistoryIcon"), highlightImage: nil, size: size, target: self, action: #selector(RefreshData))
        let scanItem = UIBarButtonItem(image: #imageLiteral(resourceName: "scanIcon"), highlightImage: nil, size: size, target: self, action: #selector(RefreshData))
        let searchItem = UIBarButtonItem(image: #imageLiteral(resourceName: "searchBtnIcon"), highlightImage: nil, size: size, target: self, action: #selector(RefreshData))
        
        navigationItem.rightBarButtonItems = [historyItem, scanItem, searchItem]
    }
}


extension HomeViewController: PageTitleViewDelegate {
    
    func pageTitleView(_ pageTitleView: PageTitleView, didSelectedIndex index: Int) {
        
        pageContentView.scrollToIndex(index)
    }
}


extension HomeViewController: pageContentViewDelegate {
    
    func pageContentView(pageContentView: PageContentView, sourceIndex: Int, targetIndex: Int, progress: Double) {
        
        pageTitleView.setCurrentTitle(sourceIndex: sourceIndex, targetIndex: targetIndex, progress: CGFloat(progress))
    }
}


