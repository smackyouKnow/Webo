//
//  EmotionLayout.swift
//  EmojiInput
//
//  Created by godyu on 2018/5/8.
//  Copyright © 2018年 godyu. All rights reserved.
//

import UIKit

class EmotionLayout: UICollectionViewFlowLayout {

    override func prepare() {
        super.prepare()
        
        self.scrollDirection = .horizontal
        
        guard let collectionView = collectionView else {
            return
        }
        itemSize = collectionView.frame.size
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
    }
    
}
