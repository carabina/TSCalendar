//
//  UIView+TSCalendar.swift
//  TSCalendar
//
//  Created by TaeSu Lee on 2016. 8. 1..
//  Copyright © 2016년 TaeSu Lee. All rights reserved.
//

import UIKit

extension UIView  {
    var ts_width: CGFloat {
        get {
            return CGRectGetWidth(frame)
        }
        
        set(width) {
//            frame = CGRectMake(self.ts_left, self.ts_t, <#T##width: CGFloat##CGFloat#>, <#T##height: CGFloat##CGFloat#>)
        }
    }
    
    var ts_height: CGFloat {
        get {
            return CGRectGetHeight(frame)
        }
        
        set(width) {
            //            frame = CGRectMake(self.ts_left, self.ts_t, <#T##width: CGFloat##CGFloat#>, <#T##height: CGFloat##CGFloat#>)
        }
    }
    
    var ts_top: CGFloat {
        get {
            return CGRectGetMinY(frame)
        }
        
        set(width) {
            //            frame = CGRectMake(self.ts_left, self.ts_t, <#T##width: CGFloat##CGFloat#>, <#T##height: CGFloat##CGFloat#>)
        }
    }
    
    var ts_bottom: CGFloat {
        get {
            return CGRectGetMaxY(frame)
        }
        
        set(width) {
            //            frame = CGRectMake(self.ts_left, self.ts_t, <#T##width: CGFloat##CGFloat#>, <#T##height: CGFloat##CGFloat#>)
        }
    }
    
    var ts_left: CGFloat {
        get {
            return CGRectGetMinX(frame)
        }
        
        set(width) {
            //            frame = CGRectMake(self.ts_left, self.ts_t, <#T##width: CGFloat##CGFloat#>, <#T##height: CGFloat##CGFloat#>)
        }
    }
    
    var ts_right: CGFloat {
        get {
            return CGRectGetMaxX(frame)
        }
        
        set(width) {
            //            frame = CGRectMake(self.ts_left, self.ts_t, <#T##width: CGFloat##CGFloat#>, <#T##height: CGFloat##CGFloat#>)
        }
    }
}
