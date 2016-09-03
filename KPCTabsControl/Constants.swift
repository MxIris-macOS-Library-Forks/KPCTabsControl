//
//  Constants.swift
//  KPCTabsControl
//
//  Created by Cédric Foellmi on 15/07/16.
//  Licensed under the MIT License (see LICENSE file)
//

import Foundation

/// The name of the notification upon the selection of a new tab.
public let TabsControlSelectionDidChangeNotification = "TabsControlSelectionDidChangeNotification"

/**
 The position of a tab button inside the control. Used in the Style.
 
 - first:  The most left-hand tab button.
 - middle: Any middle tab button between first and last.
 - last:   The most right-hand tab button
 */
public enum TabButtonPosition {
    case first
    case middle
    case last
    
    static func fromIndex(idx: Int, totalCount: Int) -> TabButtonPosition {
        switch idx {
        case 0: return .first
        case totalCount-1: return .last
        default: return .middle
        }
    }
}

public typealias Offset = NSPoint

public extension Offset {
    
    public init(x: CGFloat) {
        self.x = x
        self.y = 0
    }
    
    public init(y: CGFloat) {
        self.x = 0
        self.y = y
    }
}

/**
 Addition operator to NSPoints and Offsets.
 
 - parameter lhs: lef-hand side point
 - parameter rhs: right-hand side offset to be added to the point.
 
 - returns: A new and offset NSPoint. 
 */
public func +(lhs: NSPoint, rhs: Offset) -> NSPoint {
    return NSPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
}

public struct BorderMask: OptionSetType {
    public let rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    public static func all() -> BorderMask {
        return BorderMask.top.union(BorderMask.left).union(BorderMask.right).union(BorderMask.bottom)
    }
    
    public static let top = BorderMask(rawValue: 1 << 0)
    public static let left = BorderMask(rawValue: 1 << 1)
    public static let right = BorderMask(rawValue: 1 << 2)
    public static let bottom = BorderMask(rawValue: 1 << 3)
}
