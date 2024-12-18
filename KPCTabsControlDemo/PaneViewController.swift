//
//  ViewController.swift
//  KPCTabsControlDemo
//
//  Created by Cédric Foellmi on 15/07/16.
//  Licensed under the MIT License (see LICENSE file)
//

import Cocoa
import KPCTabsControl

// We need a class (rather than a struct or a tuple – which would be nice) because TabsControlDelegate has
// @optional methods. To have such optionaling, we need to mark the protocol as @objc. With such marking,
// we can't have pure-Swift 'Any' return object or argument. Buh...

class Item {
    var title: String = ""
    var icon: NSImage?
    var menu: NSMenu?
    var altIcon: NSImage?
    var selectable: Bool

    init(title: String, icon: NSImage?, menu: NSMenu?, altIcon: NSImage?, selectable: Bool = true) {
        self.title = title
        self.icon = icon
        self.menu = menu
        self.altIcon = altIcon
        self.selectable = selectable
    }
}

extension Item: Equatable { }

func ==(lhs: Item, rhs: Item) -> Bool {
    return lhs.title == rhs.title
}

class PaneViewController: NSViewController, TabsControlDataSource, TabsControlDelegate {

    @IBOutlet weak var tabsBar: TabsControl?
    @IBOutlet weak var useFullWidthTabsCheckButton: NSButton?
    @IBOutlet weak var tabWidthsLabel: NSTextField?

    var items: [Item] = []
    override var title: String? {
        didSet { self.tabWidthsLabel?.stringValue = self.title! }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabsBar?.dataSource = self
        self.tabsBar?.delegate = self
        self.tabsBar?.reloadTabs()
    }

    // MARK: TabsControlDataSource

    func tabsControlNumberOfTabs(_ control: TabsControl) -> Int {
        return self.items.count
    }

    func tabsControl(_ control: TabsControl, itemAtIndex index: Int) -> Any {
        return self.items[index]
    }

    func tabsControl(_ control: TabsControl, titleForItem item: Any) -> String {
        return (item as! Item).title
    }

    // MARK: TabsControlDataSource : Optionals

    func tabsControl(_ control: TabsControl, menuForItem item: Any) -> NSMenu? {
        return (item as! Item).menu
    }

    func tabsControl(_ control: TabsControl, iconForItem item: Any) -> NSImage? {
        return (item as! Item).icon
    }

    func tabsControl(_ control: TabsControl, titleAlternativeIconForItem item: Any) -> NSImage? {
        return (item as! Item).altIcon
    }

    // MARK: TabsControlDelegate

    func tabsControl(_ control: TabsControl, canReorderItem item: Any) -> Bool {
        return true
    }

    func tabsControl(_ control: TabsControl, didReorderItems items: [Any]) {
        self.items = items.map { $0 as! Item }
    }

    func tabsControl(_ control: TabsControl, canEditTitleOfItem: Any) -> Bool {
        return false
    }

    func tabsControl(_ control: TabsControl, canCloseItem item: Any) -> Bool {
        true
    }
    
    func tabsControl(_ control: TabsControl, didCloseItem item: Any) {
        let item = item as! Item
        self.items.removeAll { $0 == item }
    }
    
    func tabsControl(_ control: TabsControl, closeIconForItem item: Any) -> NSImage? {
        .init(systemSymbolName: "xmark", accessibilityDescription: nil)
    }
    
    func tabsControl(_ control: TabsControl, closePositionForItem item: Any) -> ClosePosition {
        .right
    }
    
    func tabsControl(_ control: TabsControl, setTitle newTitle: String, forItem item: Any) {
        let typedItem = item as! Item
        let titles = self.items.map { $0.title }
        let index = titles.firstIndex(of: typedItem.title)!

        let newItem = Item(title: newTitle, icon: typedItem.icon, menu: typedItem.menu, altIcon: typedItem.altIcon)
        let range = index..<index+1
        self.items.replaceSubrange(range, with: [newItem])
    }

    func tabsControl(_ control: TabsControl, canSelectItem item: Any) -> Bool {
        return (item as! Item).selectable
    }
}
