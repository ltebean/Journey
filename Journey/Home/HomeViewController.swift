
//
//  ViewController.swift
//  Journey
//
//  Created by ltebean on 16/2/18.
//  Copyright © 2016年 ltebean. All rights reserved.
//

import UIKit
import LTInfiniteScrollViewSwift

class HomeViewController: UIViewController {

    let momentService = MomentService.sharedInstance
    let homeMomentTransitionDelegate = HomeMomentTransitionDelegate()
    
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var scrollView: LTInfiniteScrollView!
    
    var moments: [Moment] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
        scrollView.maxScrollDistance = 2
        scrollView.dataSource = self
        
        scrollView.delegate = self
        view.addSubview(scrollView)
        view.sendSubviewToBack(scrollView)
        
        let tap = UITapGestureRecognizer(target: self, action: "handleTap:")
        scrollView.addGestureRecognizer(tap)
        
        let pan = UIPanGestureRecognizer(target: self, action: "handlePan:")
        view.addGestureRecognizer(pan)
        
        subscribe(MomentService.Event.MomentUpdated.rawValue, handler: { [weak self] event in
            let momentUuid = event.data as! String
            self?.refresh(initialMomentUuid: momentUuid)
        })
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        view.frame = UIScreen.mainScreen().bounds
        refresh()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.allViews().forEach({ view in
            view.frame.size = self.view.bounds.size
        })
    }
    
    func refresh(initialMomentUuid initialMomentUuid: String?=nil) {
        moments = momentService.loadAllMoments()
        if let uuid = initialMomentUuid {
            var index = 0
            for (i, moment) in moments.enumerate() {
                if uuid == moment.uuid {
                    index = i
                    break
                }
            }
            scrollView.reloadData(initialIndex: index)
        } else {
            let index = min(scrollView.currentIndex, moments.count - 1)
            scrollView.reloadData(initialIndex: index)
        }
    }
    
    func handleTap(recognizer: UITapGestureRecognizer) {
        guard recognizer.state == .Ended else {
            return
        }
        let moment = moments[scrollView.currentIndex]
        let vc = R.storyboard.home.editor()!
        vc.transitioningDelegate = homeMomentTransitionDelegate
        vc.moment = moment
        presentViewController(vc, animated: true, completion: nil)
    }
    
    func handlePan(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translationInView(recognizer.view).y
        if recognizer.state == .Changed {
            allMomentViews().forEach({ view in
                view.pullViewsWithDistance(translation)
            })
        }
        else if recognizer.state == .Ended {
            allMomentViews().forEach({ view in
                view.finishPullViews()
            })
        }
    }
    
    
    @IBAction func menuButtonPressed(sender: AnyObject) {
        let vc = R.storyboard.settings.main()!
        vc.modalTransitionStyle = .CrossDissolve
        vc.modalPresentationStyle = .Custom
        presentViewController(vc, animated: true, completion: nil)
    }
    
    @IBAction func addButtonPressed(sender: AnyObject) {
        let vc = R.storyboard.home.editor()!
        presentViewController(vc, animated: true, completion: nil)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    func allMomentViews() -> [MomentView] {
        return scrollView.allViews().map { view -> MomentView in
            let view = view as! MomentView
            return view
        }
    }
    
    func currentMomentView() -> MomentView {
        return scrollView.viewAtIndex(scrollView.currentIndex) as! MomentView
    }
}

extension HomeViewController: LTInfiniteScrollViewDataSource, LTInfiniteScrollViewDelegate {
    
    func numberOfViews() -> Int {
        return moments.count
    }
    
    func numberOfVisibleViews() -> Int {
        return 1
    }
    
    func viewAtIndex(index: Int, reusingView view: UIView?) -> UIView {
        if let momentView = view as? MomentView {
            momentView.moment = moments[index]
            return momentView
        } else {
            let momentView = MomentView(frame: self.view.bounds)
            momentView.moment = moments[index]
            return momentView
        }
    }
    
    func updateView(view: UIView, withProgress progress: CGFloat, scrollDirection direction: LTInfiniteScrollView.ScrollDirection) {
        if view.tag == scrollView.currentIndex {
            view.superview?.sendSubviewToBack(view)
        }
        let momentView = view as! MomentView
        momentView.updateViewsWithProgress(progress)
    }
    
    func scrollViewDidScrollToIndex(scrollView: LTInfiniteScrollView, index: Int) {
        
    }
}

