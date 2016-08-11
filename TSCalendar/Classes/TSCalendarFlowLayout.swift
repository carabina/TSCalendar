//
//  TSCalendarFlowLayout.swift
//  TSCalendar
//
//  Created by TaeSu Lee on 2016. 7. 25..
//  Copyright © 2016년 TaeSu Lee. All rights reserved.
//

import UIKit

class TSCalendarFlowLayout: UICollectionViewFlowLayout {
    
    override init() {
        super.init()
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    private func initialize() {
        scrollDirection = .Vertical
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        itemSize = CGSize(width: 30, height: 30)
        sectionInset = UIEdgeInsetsZero
    }
    
    override func prepareLayout() {
        super.prepareLayout()
        
        let itemSize = CGSize(width: collectionView!.ts_width/7.0, height: collectionView!.ts_height/6.0)
        self.itemSize = itemSize
    }
    
}

extension TSCalendarFlowLayout: UICollectionViewDelegateFlowLayout {
    
}