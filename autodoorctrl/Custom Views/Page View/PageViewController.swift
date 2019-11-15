//
//  PageViewController.swift
//  MusicStatistics
//
//  Created by Jing Wei Li on 8/1/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import UIKit

public class PageViewController: UIPageViewController {
    let pageViewControllers: [UIViewController]
    let isCyclic: Bool
    private var pageControl = UIPageControl()
    
    // MARK: - Init
    
    /// Designated Initializer.
    /// - Parameter viewControllers: a set of views controllers to show in the page view controller.
    /// - Parameter isCyclic: indicates whether the view controllers can be cycled through.
    public init(viewControllers: [UIViewController], isCyclic: Bool = false) {
        guard !viewControllers.isEmpty else {
            fatalError("View Controllers must not be empty")
        }
        
        pageViewControllers = viewControllers
        self.isCyclic = isCyclic
        super.init(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal,
            options: nil)
    }
    
    /// Uses the provided data sets to make the first view controllers, and append the final action view controller to the end.
    /// - Parameter dataSets: The data to display before the action view controller
    /// - Parameter actionVC: the vc after all dataset vcs, should have a button that either dismisses the vc or does something
    /// - Parameter isCyclic: whether or the not the pager should cycle thru all its view controllers.
    public convenience init(
        dataSets: [PageContentDataSet],
        actionVC: PageContentViewController,
        isCyclic: Bool = false)
    {
        self.init(
            viewControllers: dataSets.map { PageContentViewController(dataSet: $0) } + [actionVC],
            isCyclic: isCyclic)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        configurePageControl()
        if let firstViewController = pageViewControllers.first {
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    override public var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    // MARK: Configure Page Control Dots
    
    private func configurePageControl() {
        // The total number of pages that are available is based on how many available pages we have.
        var safeAreaBottom: CGFloat = 0
        if #available(iOS 11.0, *), let safeArea = UIApplication.shared.keyWindow?.safeAreaInsets.bottom {
            safeAreaBottom += safeArea
        }
        
        pageControl = UIPageControl(frame: CGRect(
            x: 0,
            y: UIScreen.main.bounds.maxY - 50 - safeAreaBottom,
            width: UIScreen.main.bounds.width,
            height: 50))
        pageControl.numberOfPages = pageViewControllers.count
        pageControl.currentPage = 0
        pageControl.tintColor = UIColor.black
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.currentPageIndicatorTintColor = UIColor.white
        // prevent the pager dots from being user-controllable
        pageControl.isUserInteractionEnabled = false
        view.addSubview(pageControl)
    }
    
}

// MARK: - UIPageViewController Delegates and DataSources
extension PageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    public func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController) -> UIViewController?
    {
        guard let viewControllerIndex = pageViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        let previousIndex = viewControllerIndex - 1
        
        // User is on the first view controller and swiped left will do nothing
        guard previousIndex >= 0 else {
            return isCyclic ? pageViewControllers.last : nil
        }
        
        guard pageViewControllers.count > previousIndex else {
            return nil
        }
        
        return pageViewControllers[previousIndex]
    }
    
    public func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        guard let viewControllerIndex = pageViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = pageViewControllers.count
        
        // User is on the last view controller and swiped right will do nothing
        guard orderedViewControllersCount != nextIndex else {
            return isCyclic ? pageViewControllers.first : nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return pageViewControllers[nextIndex]
    }
    
    public func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool)
    {
        if let pageContentViewController = pageViewController.viewControllers?.first,
            let index = pageViewControllers.firstIndex(of: pageContentViewController) {
            pageControl.currentPage = index
        }
    }
}
