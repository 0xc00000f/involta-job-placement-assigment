//
//  UITableView+Extension.swift
//  involta-job-placement-assigment
//
//  Created by Maxim Tsyganov on 09.05.2022.
//

import UIKit

extension UITableView {
    /**
     Method to use whenever new items should be inserted at the top of the table view.
     The table view maintains its scroll position using this method.
     - warning: Make sure your data model contains the correct count of items before invoking this method.
     - parameter itemCount: The count of items that should be added at the top of the table view.
     - note: Works with `UITableViewAutomaticDimension`.
     - links: https://bluelemonbits.com/2018/08/26/inserting-cells-at-the-top-of-a-uitableview-with-no-scrolling/
     */
    func insertItemsAtTopWithFixedPosition(_ itemCount: Int, inSection section: Int) {
        layoutIfNeeded() // makes sure layout is set correctly.
        var initialContentOffSet = contentOffset.y

        // If offset is less than 0 due to refresh up gesture, assume 0.
        if initialContentOffSet < 0 {
            initialContentOffSet = 0
        }

        // Reload, scroll and set offset:
        reloadData()
        scrollToRow(
            at: IndexPath(row: itemCount, section: section),
            at: .top,
            animated: false)
        contentOffset.y += initialContentOffSet
    }
}
