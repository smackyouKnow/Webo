//
//  EmotionInputView.swift
//  EmojiInput
//
//  Created by godyu on 2018/5/8.
//  Copyright © 2018年 godyu. All rights reserved.
//

import UIKit

private let EmotionCellId = "EmotionCellId"

class EmotionInputView: UIView {

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var toolBar: EmoticonToollBar!
    
    @IBOutlet weak var pageControl: UIPageControl!
    class func show() -> EmotionInputView {
        
        let v = Bundle.main.loadNibNamed("EmotionInputView", owner: nil, options: nil)?.last as! EmotionInputView
        
        return v
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.register(UINib.init(nibName: "EmotionCell", bundle: nil), forCellWithReuseIdentifier: EmotionCellId)
        collectionView.register(EmotionCell.self, forCellWithReuseIdentifier: EmotionCellId)
        
        toolBar.delegate = self
        
        //设置pageControl
        pageControl.setValue(UIImage.init(named: "normalPage"), forKey: "_pageImage")
        pageControl.setValue(UIImage.init(named: "selectedPage"), forKey: "_currentPageImage")
        
        
    }

}

extension EmotionInputView : UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return EmotionManager.shared.packages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let package = EmotionManager.shared.packages[section] else {
            return 0
        }
        return package.numberOfCells
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmotionCellId, for: indexPath) as! EmotionCell
        
        if let package = EmotionManager.shared.packages[indexPath.section] {
            cell.emotions = package.emotion(page: indexPath.row)
        }

        return cell
    }
}

extension EmotionInputView : UICollectionViewDelegateFlowLayout {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //获取中心点
        var center = scrollView.center
        center.x += scrollView.contentOffset.x
        
        let paths = collectionView.indexPathsForVisibleItems
        
        var targetIndexPath : IndexPath?
        for indexPath in paths {
            let cell = collectionView.cellForItem(at: indexPath)
            
            if cell?.frame.contains(center) == true {
                targetIndexPath = indexPath
                break
            }
        }
        
        guard let target = targetIndexPath else {
            return
        }
        toolBar.selectedIndex = target.section
        
        pageControl.numberOfPages = collectionView.numberOfItems(inSection: target.section)
        pageControl.currentPage = target.item
    }
}

//MARK: EmoticonToollBarDelegate
extension EmotionInputView : EmoticonToollBarDelegate {
    func toolBarItemClickForIndex(index: Int) {
        collectionView.scrollToItem(at: IndexPath.init(row: 0, section: index), at: .left, animated: true)
    }
}
