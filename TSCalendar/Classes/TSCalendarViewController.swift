//
//  TSCalendarViewController.swift
//  TheDay
//
//  Created by TaeSu Lee on 2016. 7. 7..
//  Copyright © 2016년 TaeSu Lee. All rights reserved.
//

import UIKit

class TSCalendarViewController: UIViewController {

    @IBOutlet weak var calendar: TSCalendar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        calendar.scrollDirection = .Vertical
//        let indexPath = NSIndexPath(forItem: 0, inSection: 1)
//        calendar.collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .Top, animated: false)
//        let indexPath = NSIndexPath(forItem: 0, inSection: 1)
//        calendar.collectionView.selectItemAtIndexPath(indexPath, animated: false, scrollPosition: .None)
//        calendar.collectionView.setContentOffset(CGPointMake(0, calendar.collectionView.fs_height), animated: false)
        
//        print(view.bounds)
//        print("(fs_width,fs_height) = (\(view.fs_width),\(view.fs_height))")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
