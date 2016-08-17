//
//  ViewController.swift
//  DayPhoto
//
//  Created by Kruperfone on 13.02.15.
//  Copyright (c) 2015 Flatstack. All rights reserved.
//

import UIKit
import MagicalRecord
import AVFoundation

class ViewController: UIViewController {
    
    private let flipPresentAnimationController = FlipPresentAnimationController()
    private let flipDismissAnimationController = FlipDismissAnimationController()
    private let swipeInteractionController = SwipeInteractionController()
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var fullImageView: UIImageView!
    @IBOutlet weak var blurButton: UIButton!
    @IBOutlet weak var loginViewContainer: UIView!

    var photoSource = Photo.allPhotos()
    var collectionViewWidth = CGFloat(0);
    var isBlured = false
    var fromFrame: CGRect?
    override func viewDidLoad() {
        super.viewDidLoad()
        if let patternImage = UIImage(named: "Pattern") {
            view.backgroundColor = UIColor(patternImage: patternImage)
        }
        if let layout = self.collectionView?.collectionViewLayout as? DayPhotoLayout {
            layout.delegate = self
        }
        self.collectionView!.contentInset = UIEdgeInsets(top: 23, left: 5, bottom: 10, right: 5)
        self.collectionViewWidth = self.collectionView.frame.width
        self.blurButton.layer.cornerRadius = 70
        self.blurButton.clipsToBounds = true
        self.setBlurForBlurButton()
        self.loginViewContainer.layer.cornerRadius = 10
        self.loginViewContainer.clipsToBounds = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if self.collectionView.frame.width != self.collectionViewWidth {
            let layout = DayPhotoLayout()
            layout.delegate = self
            self.collectionView.collectionViewLayout.invalidateLayout()
            self.collectionView.reloadData()
            self.collectionView.setCollectionViewLayout(layout, animated: false)
            self.collectionViewWidth = self.collectionView.frame.width
        }
        
    }
    
    func setBlurForBlurButton() {
        let blurEffect = UIBlurEffect(style: .Light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        
        let vibrancy = UIVibrancyEffect(forBlurEffect:blurEffect)
        let vibrancyView = UIVisualEffectView(effect: vibrancy)
        blurView.frame = CGRectMake(0, 0, 140, 140)
        blurView.userInteractionEnabled = false
        vibrancyView.frame = CGRectMake(0, 0, 140, 140)
        vibrancyView.userInteractionEnabled = false
        self.blurButton.insertSubview(blurView, atIndex: 0)
        self.blurButton.insertSubview(vibrancyView, atIndex: 0)
    }
    
    @IBAction func blurImage(sender: AnyObject) {
        if self.isBlured == false {
            let blurEffect = UIBlurEffect(style: .Light)
            let blurView = UIVisualEffectView(effect: blurEffect)
            blurView.frame = self.fullImageView.frame
            self.view.insertSubview(blurView, aboveSubview:  self.fullImageView)
            self.isBlured = true
        } else {
            for view in self.view.subviews {
                if view.isKindOfClass(UIVisualEffectView) {
                    view.removeFromSuperview()
                }
            }
            self.isBlured = false
        }
    }
    @IBAction func showHideLoginView(sender: AnyObject) {
        self.loginViewContainer.hidden = !self.loginViewContainer.hidden
    }
   
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("AnnotatedPhotoCell", forIndexPath: indexPath) as! AnnotatedPhotoCell
        cell.photo = photoSource[indexPath.item]
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoSource.count
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if FSIsIPad() == true {
       self.fullImageView.image = photoSource[indexPath.row].image
        } else {
            let vc = self.storyboard?.instantiateViewControllerWithIdentifier("PhotoView") as! PhotoViewController
            vc.photo = photoSource[indexPath.row]
            vc.transitioningDelegate = self
            let cell = collectionView.cellForItemAtIndexPath(indexPath)
            self.fromFrame = cell?.frame
            swipeInteractionController.wireToViewController(vc)
            self.showViewController(vc, sender: self)
        }
    }
    
}

extension ViewController : DayPhotoLayoutDelegate {
    
    func collectionView(collectionView:UICollectionView, heightForPhotoAtIndexPath indexPath:NSIndexPath , withWidth width:CGFloat) -> CGFloat {
        let photo = photoSource[indexPath.item]
        let boundingRect =  CGRect(x: 0, y: 0, width: width, height: CGFloat(MAXFLOAT))
        let rect  = AVMakeRectWithAspectRatioInsideRect(photo.image.size , boundingRect)
        return rect.size.height
    }
    
    func collectionView(collectionView: UICollectionView, heightForAnnotationAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat {
        let annotationPadding = CGFloat(4)
        let annotationHeaderHeight = CGFloat(17)
        
        let photo = photoSource[indexPath.item]
        let font = UIFont(name: "AvenirNext-Regular", size: 10)!
        let commentHeight = photo.heightForComment(font, width: width)
        let height = annotationPadding + annotationHeaderHeight + commentHeight + annotationPadding
        return height
    }
}

extension ViewController: UIViewControllerTransitioningDelegate {
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        flipPresentAnimationController.originFrame = self.fromFrame!
        return flipPresentAnimationController
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        flipDismissAnimationController.destinationFrame = self.view.frame
        return flipDismissAnimationController
    }
    func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return swipeInteractionController.interactionInProgress ? swipeInteractionController : nil
    }
   
}