//
//  TSCalendarCollectionView.swift
//  TSCalendar
//
//  Created by TaeSu Lee on 2016. 7. 25..
//  Copyright © 2016년 TaeSu Lee. All rights reserved.
//

import UIKit

class TSCalendarCollectionView: UICollectionView {

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    private func initialize() {
        scrollsToTop = false
        contentInset = UIEdgeInsetsZero
        
        if #available(iOS 9.0, *) {
            semanticContentAttribute = .ForceLeftToRight
        }
    }
    
}
