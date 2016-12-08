//
//  MGameViewController.swift
//  DouYuTV
//
//  Created by 胡明昊 on 16/11/23.
//  Copyright © 2016年 CMCC. All rights reserved.
//  手游

import UIKit
import MBProgressHUD

private let kGameSection = 15

class MGameViewController: BaseAnchorViewController {
    
    fileprivate lazy var mgameVM: MGameViewModel = MGameViewModel()
    
    fileprivate lazy var headerView: MyHeaderView = {
        let headerView = MyHeaderView(frame: CGRect(x: 0, y: -S.ColHeaderViewH, width: HmhDevice.screenW, height: S.ColHeaderViewH))
        return headerView
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        collectionView.addSubview(headerView)
        collectionView.contentInset = UIEdgeInsets(top: S.ColHeaderViewH, left: 0, bottom: 0, right: 0)
        
        headerView.headerViewCellMoreClosure = { [unowned self] in
            self.gotoMoreViewVC()
        }
    }

}


extension MGameViewController {
    
    override func loadData() {
        super.loadData()
        
        mgameVM.requestHederData(complectioned: { [weak self] in
            
            guard let models = self?.mgameVM.mModels else {return}
            if models.count == 0 {return}
            var headrModels = [HotModel]()
            // 最多加载15个(去掉最热)
            for i in 1..<16 {
                headrModels.append(models[i])
            }
            self?.headerView.headerData = headrModels
            self?.headerView.isAddMoreBtn = true
            
            self?.collectionView.reloadData()
            
            self?.loadDataFinished()
            self?.refreshControl?.endRefreshing()
            }, failed: {[weak self] (error) in
                MBProgressHUD.showError(error.errorMessage!)
                self?.loadDataFailed()
        })
    }
}


// MARK: - CollectionViewDataSource
extension MGameViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        if mgameVM.mModels.count == 0 {
            return 0
        }else {
            return kGameSection
        }
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! RecommentNormalCell
            let anchorModels = mgameVM.mModels[indexPath.section]
            cell.anchorModel = anchorModels.room_list?[indexPath.item]
        
            return cell
        }
    


    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let sectionHeaderView = super.collectionView(collectionView, viewForSupplementaryElementOfKind: kind, at: indexPath) as! RecommendSectionHeaderView
        
        if indexPath.section == 0 {
            sectionHeaderView.titleLabel.text = "最热"
            sectionHeaderView.iconImage.image = UIImage(named: "home_header_hot")
        }else {
            let hotModels = mgameVM.mModels[indexPath.section]
            sectionHeaderView.dataModel = hotModels
            
        }
        
        return sectionHeaderView
    }
    
}

extension MGameViewController {
    
    func gotoMoreViewVC() {
        let allVC = AllGameViewController()
        allVC.dataModels = mgameVM.mModels
        self.pushViewController(allVC, true)
    }
    
    func loadDataDidClick(failedView: BaseFailedView, _ button: UIButton) {
        failedView.removeFromSuperview()
        startAnimation()
        
        loadData()
    }
    
}
