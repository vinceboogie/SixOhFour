//
//  RepeatOnDaysCollectionView.swift
//  SixOhFour
//
//  Created by jemsomniac on 7/17/15.
//  Copyright (c) 2015 vinceboogie. All rights reserved.
//

import UIKit

class RepeatOnDaysCollectionView: UICollectionView {

    
    var indexPath: NSIndexPath!
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
