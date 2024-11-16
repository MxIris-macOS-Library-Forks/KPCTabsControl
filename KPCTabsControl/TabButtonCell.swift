//
//  TabButtonCell.swift
//  KPCTabsControl
//
//  Created by Cédric Foellmi on 14/06/16.
//  Licensed under the MIT License (see LICENSE file)
//

import AppKit
import Foundation

let titleMargin: CGFloat = 5.0

class TabButtonCell: NSButtonCell {
    var hasTitleAlternativeIcon: Bool = false

    var isSelected: Bool { state == .on }

    var selectionState: TabSelectionState {
        isEnabled == false ? TabSelectionState.unselectable : (isSelected ? TabSelectionState.selected : TabSelectionState.normal)
    }

    var showsIcon: Bool { (controlView as? TabButton)?.icon != nil }

    var showsMenu: Bool { menu?.items.count > 0 }

    var buttonPosition: TabPosition = .middle {
        didSet { controlView?.needsDisplay = true }
    }

    var closePosition: ClosePosition?
    
    var style: Style

    // MARK: - Initializers & Copy

    init(textCell string: String, style: Style) {
        self.style = style
        super.init(textCell: string)

        self.isBordered = true
        self.backgroundStyle = .light
        self.highlightsBy = .changeBackgroundCellMask
        self.lineBreakMode = .byTruncatingTail
        self.focusRingType = .none
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func copy() -> Any {
        let copy = TabButtonCell(textCell: title, style: style)

        copy.hasTitleAlternativeIcon = hasTitleAlternativeIcon
        copy.buttonPosition = buttonPosition
        copy.closePosition = closePosition
        copy.state = state
        copy.isHighlighted = isHighlighted

        return copy
    }

    // MARK: - Properties & Rects

    static func popupImage() -> NSImage {
        let path: String
        #if SwiftPackage
        path = Bundle.module.path(forResource: "KPCPullDownTemplate", ofType: "pdf", inDirectory: "Resources")!
        #else
        path = Bundle(for: self).pathForImageResource(NSImage.Name("KPCPullDownTemplate"))!
        #endif
        return NSImage(contentsOfFile: path)!.imageWithTint(NSColor.darkGray)
    }

    func hasRoomToDrawFullTitle(inRect rect: NSRect) -> Bool {
        let title = style.attributedTitle(content: self.title, selectionState: selectionState)
        let requiredMinimumWidth = title.size().width + 2.0 * titleMargin
        let titleDrawRect = titleRect(forBounds: rect)
        return titleDrawRect.width >= requiredMinimumWidth
    }

    override func cellSize(forBounds aRect: NSRect) -> NSSize {
        let title = style.attributedTitle(content: self.title, selectionState: selectionState)
        let titleSize = title.size()
        let popupSize = (menu == nil) ? NSSize.zero : TabButtonCell.popupImage().size
        let cellSize = NSSize(width: titleSize.width + (popupSize.width * 2) + 36, height: max(titleSize.height, popupSize.height))
        controlView?.invalidateIntrinsicContentSize()
        return cellSize
    }


    override func trackMouse(with theEvent: NSEvent,
                             in cellFrame: NSRect,
                             of controlView: NSView,
                             untilMouseUp flag: Bool) -> Bool {
        if hitTest(
            for: theEvent,
            in: controlView.superview!.frame,
            of: controlView.superview!
        ) != [] {
            let popupRect = style.popupRectWithFrame(cellFrame, closePosition: closePosition)
            let location = controlView.convert(theEvent.locationInWindow, from: nil)

            if menu?.items.count > 0 && popupRect.contains(location) {
                menu?.popUp(
                    positioning: menu!.items.first,
                    at: NSPoint(x: popupRect.midX, y: popupRect.maxY),
                    in: controlView
                )

                return true
            }
        }

        return super.trackMouse(with: theEvent, in: cellFrame, of: controlView, untilMouseUp: flag)
    }

    override func titleRect(forBounds theRect: NSRect) -> NSRect {
        let title = style.attributedTitle(content: self.title, selectionState: selectionState)
        return style.titleRect(title: title, inBounds: theRect, showingIcon: showsIcon, showingMenu: showsMenu, closePosition: closePosition)
    }

    // MARK: - Editing

    func edit(fieldEditor: NSText, inView view: NSView, delegate: NSTextDelegate) {
        isHighlighted = true

        let frame = editingRectForBounds(view.bounds)
        select(
            withFrame: frame,
            in: view,
            editor: fieldEditor,
            delegate: delegate,
            start: 0,
            length: 0
        )

        fieldEditor.drawsBackground = false
        fieldEditor.isHorizontallyResizable = true
        fieldEditor.isEditable = true

        let editorSettings = style.titleEditorSettings()
        fieldEditor.font = editorSettings.font
        fieldEditor.alignment = editorSettings.alignment
        fieldEditor.textColor = editorSettings.textColor

        // Replace content so that resizing is triggered
        fieldEditor.string = ""
        fieldEditor.insertText(title ?? "")
        fieldEditor.selectAll(self)

        title = ""
    }

    func finishEditing(fieldEditor: NSText, newValue: String) {
        endEditing(fieldEditor)
        title = newValue
    }

    func editingRectForBounds(_ rect: NSRect) -> NSRect {
        return titleRect(forBounds: rect) // .offsetBy(dx: 0, dy: 1))
    }

    // MARK: - Drawing

    override func draw(withFrame frame: NSRect, in controlView: NSView) {
        style.drawTabButtonBezel(frame: frame, position: buttonPosition, isSelected: isSelected)

        if hasRoomToDrawFullTitle(inRect: frame) || hasTitleAlternativeIcon == false {
            let title = style.attributedTitle(content: self.title, selectionState: selectionState)
            _ = drawTitle(title, withFrame: frame, in: controlView)
        }

        if showsMenu {
            drawPopupButtonWithFrame(frame)
        }
    }

    override func drawTitle(_ title: NSAttributedString, withFrame frame: NSRect, in controlView: NSView) -> NSRect {
        let titleRect = self.titleRect(forBounds: frame)
        title.draw(in: titleRect)
//        NSColor.red.setFill()
//        titleRect.fill()
        return titleRect
    }

    fileprivate func drawPopupButtonWithFrame(_ frame: NSRect) {
        let image = TabButtonCell.popupImage()
        image.draw(
            in: style.popupRectWithFrame(frame, closePosition: closePosition),
            from: .zero,
            operation: .sourceOver,
            fraction: 1.0,
            respectFlipped: true,
            hints: nil
        )
    }
}
