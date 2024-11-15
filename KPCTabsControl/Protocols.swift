//
//  TabsControlProtocols.swift
//  KPCTabsControl
//
//  Created by Cédric Foellmi on 15/07/16.
//  Licensed under the MIT License (see LICENSE file)
//

import AppKit

@objc public protocol TabsControlDataSource: NSObjectProtocol {
    /**
     Returns the number of tabs
     
     - parameter control: The instance of the tabs control.
     
     - returns: A unsigned integer indicating the number of tabs to display.
     */
    func tabsControlNumberOfTabs(_ control: TabsControl) -> Int

    /**
     Return the item for the tab at the given index, similarly to a "representedObject" in a cell view.
     
     - parameter control: The instance of the tabs control.
     - parameter index:   The index of the given item.
     
     - returns: An instance of an object representing the tab.
     */
    func tabsControl(_ control: TabsControl, itemAtIndex index: Int) -> Any

    /**
     Return the title for the tab of the given item
     
     - parameter control: The instance of the tabs control.
     - parameter item:    The item representing the given tab.
     
     - returns: A string to be used as title of the tab.
     */
    func tabsControl(_ control: TabsControl, titleForItem item: Any) -> String

    /**
     If any, returns a menu for the tab, to be place to the right side of it. It is your responsability to fully
     configure its targets and actions before returning it to the tabs control.
     
     - parameter control: The instance of the tabs control.
     - parameter item:    The item representing the given tab.
     
     - returns: A menu instance.
     */
    @objc optional func tabsControl(_ control: TabsControl, menuForItem item: Any) -> NSMenu?

    /**
     If any, returns an icon for the tab, to be placed to the left side of it.
     
     - parameter control: The instance of the tabs control.
     - parameter item:    The item representing the given tab.
     
     - returns: An image instance for the icon.
     */
    @objc optional func tabsControl(_ control: TabsControl, iconForItem item: Any) -> NSImage?

    @objc optional func tabsControl(_ control: TabsControl, closeIconForItem item: Any) -> NSImage?
    
    @objc optional func tabsControl(_ control: TabsControl, closePositionForItem item: Any) -> ClosePosition
    /**
     If the width of the tab is not large enough to draw the title, it is possible to provide here an alternate
     icon to replace it. The threshold at which one switch between the title and the icon is computed individually
     for each title.
     
     - parameter control: The instance of the tabs control.
     - parameter item:    The item representing the given tab.
     
     - returns:  An image instance for the alternate icon.
     */
    @objc optional func tabsControl(_ control: TabsControl, titleAlternativeIconForItem item: Any) -> NSImage?
}

@objc public protocol TabsControlDelegate: NSControlTextEditingDelegate {
    /**
     *  Determine if the tab can be selected.
     *
     *  - parameter tabControl: The instance of the tabs control.
     *  - parameter item:       The item representing the given tab.
     *
     *  - returns: A boolean value indicating whether the tab can be selected or not.
     */
    @objc optional func tabsControl(_ control: TabsControl, canSelectItem item: Any) -> Bool

    /**
     *  If implemented, the delegate is informed that the selected tab did change.
     *  See also TabsControlSelectionDidChangeNotification
     *
     *  - parameter tabControl: The instance of the tabs control.
     *  - parameter item:       The item representing the selected tab.
     */
    @objc optional func tabsControlDidChangeSelection(_ control: TabsControl, item: Any)

    /**
     *  Return `true` if the tab is allowed to be reordered (by being dragged with the mouse).
     *  This method has no effect if the one below is not implemented.
     *
     *  - parameter tabControl: The instance of the tabs control.
     *  - parameter item:       The item representing the given tab.
     *
     *  - returns: A boolean value indicating whether the tab can be reordered or not.
     */
    @objc optional func tabsControl(_ control: TabsControl, canReorderItem item: Any) -> Bool

    /**
     *  If implemented, the delegate is informed that the tabs have been reordered. It is the delegate responsability
     *  to store the new order of items. If not stored, the tabs will recover their original order.
     *
     *  - parameter tabControl: The instance of the tabs control.
     *  - parameter items:      The array the items following the new orders.
     */
    @objc optional func tabsControl(_ control: TabsControl, didReorderItems items: [Any])

    /**
     *  Return `true` if you allow the editing of the title of the tab. By default, titles are not editable.
     *  This method has no effect if the one below is not implemented.
     *
     *  - parameter tabControl: The instance of the tabs control.
     *  - parameter item:       The item representing the given tab.
     *
     *  - returns: A boolean value indicating whether the tab title can be edited or not.
     */
    @objc optional func tabsControl(_ control: TabsControl, canEditTitleOfItem item: Any) -> Bool

    /**
     *  If implemented, the delegate is informed that the tab has been renamed to the given title. Again, it is the
     *  delegate responsability to store the new title.
     *
     *  - parameter tabControl: The instance of the tabs control.
     *  - parameter newTitle:   The new title value.
     *  - parameter item:       The item representing the given tab.
     */
    @objc optional func tabsControl(_ control: TabsControl, setTitle newTitle: String, forItem item: Any)
    
    @objc optional func tabsControl(_ control: TabsControl, canCloseItem item: Any) -> Bool
    
    @objc optional func tabsControl(_ control: TabsControl, didCloseItem item: Any)
}
