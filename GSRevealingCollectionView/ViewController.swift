//
//  ViewController.swift
//  CustomCollection
//
//  Created by Gurdeep Singh on 13/01/16.
//  Copyright © 2016 Gurdeep Singh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        collectionView.collectionViewLayout = GSCustomFlowLayout()
        collectionView.dataSource = self
        
        collectionView.delegate = self
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


extension ViewController : UICollectionViewDataSource {

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
        return 20
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    
        let theCell = collectionView.dequeueReusableCellWithReuseIdentifier("dummyCell", forIndexPath: indexPath)
    
        let imgview = theCell.viewWithTag(1) as! UIImageView
        
        imgview.image = UIImage(named: "\(indexPath.row%7 + 1).jpg")
        imgview.clipsToBounds = true
        
        return theCell
    }
    
}

extension ViewController : UICollectionViewDelegate {

    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        print("scrollView.contentOffset.x : \(scrollView.contentOffset.x)")
    }
}

extension UIColor {
    
    class func randomColor() -> UIColor {
        
        let randomRed:CGFloat = CGFloat(drand48())
        
        let randomGreen:CGFloat = CGFloat(drand48())
        
        let randomBlue:CGFloat = CGFloat(drand48())
        
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
        
    }
    
}