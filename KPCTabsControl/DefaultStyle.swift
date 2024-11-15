//
//  DefaultStyle.swift
//  KPCTabsControl
//
//  Created by Christian Tietze on 10/08/16.
//  Licensed under the MIT License (see LICENSE file)
//

import Cocoa

public enum TitleDefaults {
    static let alignment = NSTextAlignment.left
    static let lineBreakMode = NSLineBreakMode.byTruncatingMiddle
}

/// Default implementation of Themed Style

extension ThemedStyle {
    // MARK: - Tab Buttons

    public func tabButtonOffset(position: TabPosition) -> Offset {
        return NSPoint()
    }

    public func tabButtonBorderMask(_ position: TabPosition) -> BorderMask? {
        return BorderMask.all()
    }
    
    // MARK: - Close Button
    public func closeButtonFrame(tabRect rect: NSRect, atPosition position: ClosePosition) -> NSRect {
        let verticalPadding: CGFloat = 4.0
        let paddedHeight = rect.height - 2 * verticalPadding
        switch position {
        case .left:
            return .init(x: titleMargin, y: verticalPadding, width: paddedHeight, height: paddedHeight)
        case .right:
            return .init(x: rect.maxX - titleMargin - paddedHeight, y: verticalPadding, width: paddedHeight, height: paddedHeight)
        }
    }

    // MARK: - Tab Button Titles

    public func iconFrames(tabRect rect: NSRect, closePosition: ClosePosition?) -> IconFrames {
        let verticalPadding: CGFloat = 4.0
        let paddedHeight = rect.height - 2 * verticalPadding
        let x = rect.width / 2.0 - paddedHeight / 2.0
        var closeButtonMaxX = 10.0
        var closePadding: CGFloat = 0.0
        if let closePosition, closePosition == .left {
            closeButtonMaxX = closeButtonFrame(tabRect: rect, atPosition: .left).maxX
            closePadding = titleMargin
        }
        
        return (
            NSRect(x: closeButtonMaxX + closePadding, y: verticalPadding, width: paddedHeight, height: paddedHeight),
            NSRect(x: x + closeButtonMaxX + closePadding, y: verticalPadding, width: paddedHeight, height: paddedHeight)
        )
    }

    public func titleRect(title: NSAttributedString, inBounds rect: NSRect, showingIcon: Bool, closePosition: ClosePosition?) -> NSRect {
        let titleSize = title.size()
        let fullWidthRect = NSRect(
            x: rect.minX,
            y: rect.midY - titleSize.height / 2.0 - 0.5,
            width: rect.width,
            height: titleSize.height
        )

        return paddedRectForIcon(fullWidthRect, inBounds: rect, showingIcon: showingIcon, closePosition: closePosition)
    }

    private func paddedRectForIcon(_ rect: NSRect, inBounds bounds: NSRect, showingIcon: Bool, closePosition: ClosePosition?) -> NSRect {
        if !showingIcon, closePosition == nil {
            return rect
        }
        let leftPadding: CGFloat
        let rightPadding: CGFloat
        if showingIcon {
            let iconRect = iconFrames(tabRect: bounds, closePosition: closePosition).iconFrame
            leftPadding = iconRect.maxX + titleMargin
            if let closePosition, closePosition == .right {
                rightPadding = closeButtonFrame(tabRect: bounds, atPosition: .right).width + titleMargin + 10.0
            } else {
                rightPadding = 0
            }
        } else if let closePosition {
            let closeButtonFrame = closeButtonFrame(tabRect: bounds, atPosition: closePosition)
            switch closePosition {
            case .left:
                leftPadding = closeButtonFrame.maxX + titleMargin
                rightPadding = 0
            case .right:
                leftPadding = 0
                rightPadding = closeButtonFrame.width + titleMargin + 10.0
            }
            
        } else {
            return rect
        }
        return rect.offsetBy(dx: leftPadding, dy: 0.0).shrinkBy(dx: leftPadding + rightPadding, dy: 0.0)
    }

    public func titleEditorSettings() -> TitleEditorSettings {
        return (
            textColor: NSColor(calibratedWhite: 1.0 / 6, alpha: 1.0),
            font: theme.tabButtonTheme.titleFont,
            alignment: TitleDefaults.alignment
        )
    }

    public func attributedTitle(content: String, selectionState: TabSelectionState) -> NSAttributedString {
        let activeTheme = theme.tabButtonTheme(fromSelectionState: selectionState)

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = TitleDefaults.alignment
        paragraphStyle.lineBreakMode = TitleDefaults.lineBreakMode

        let attributes = [NSAttributedString.Key.foregroundColor: activeTheme.titleColor,
                          NSAttributedString.Key.font: activeTheme.titleFont,
                          NSAttributedString.Key.paragraphStyle: paragraphStyle]

        return NSAttributedString(string: content, attributes: attributes)
    }

    // MARK: - Tabs Control

    public func tabsControlBorderMask() -> BorderMask? {
        return BorderMask.top.union(BorderMask.bottom)
    }

    // MARK: - Drawing

    public func drawTabsControlBezel(frame: NSRect) {
        theme.tabsControlTheme.backgroundColor.setFill()
        frame.fill()

        let borderDrawing = BorderDrawing.fromMask(frame, borderMask: tabsControlBorderMask())
        drawBorder(borderDrawing, color: theme.tabsControlTheme.borderColor)
    }

    public func drawTabButtonBezel(frame: NSRect, position: TabPosition, isSelected: Bool) {
        let activeTheme = isSelected ? theme.selectedTabButtonTheme : theme.tabButtonTheme
        activeTheme.backgroundColor.setFill()
        frame.fill()

        let borderDrawing = BorderDrawing.fromMask(frame, borderMask: tabButtonBorderMask(position))
        drawBorder(borderDrawing, color: activeTheme.borderColor)
    }

    fileprivate func drawBorder(_ border: BorderDrawing, color: NSColor) {
        guard case let .draw(borderRects: borderRects, rectCount: _) = border
        else { return }

        color.setFill()
        color.setStroke()
        borderRects.fill()
    }
}

// MARK: -

private enum BorderDrawing {
    case empty
    case draw(borderRects: [NSRect], rectCount: Int)

    fileprivate static func fromMask(_ sourceRect: NSRect, borderMask: BorderMask?) -> BorderDrawing {
        guard let mask = borderMask else { return .empty }

        var outputCount = 0
        var remainderRect = NSRect.zero
        var borderRects: [NSRect] = [NSRect.zero, NSRect.zero, NSRect.zero, NSRect.zero]

        if mask.contains(.top) {
            NSDivideRect(sourceRect, &borderRects[outputCount], &remainderRect, 0.5, .minY)
            outputCount += 1
        }
        if mask.contains(.left) {
            NSDivideRect(sourceRect, &borderRects[outputCount], &remainderRect, 0.5, .minX)
            outputCount += 1
        }
        if mask.contains(.right) {
            NSDivideRect(sourceRect, &borderRects[outputCount], &remainderRect, 0.5, .maxX)
            outputCount += 1
        }
        if mask.contains(.bottom) {
            NSDivideRect(sourceRect, &borderRects[outputCount], &remainderRect, 0.5, .maxY)
            outputCount += 1
        }

        guard outputCount > 0 else { return .empty }

        return .draw(borderRects: borderRects, rectCount: outputCount)
    }
}

// MARK: -

///  The default TabsControl style. Used with the DefaultTheme, it provides an experience similar to Apple's Numbers.app.
public struct DefaultStyle: ThemedStyle {
    public let theme: Theme
    public let tabButtonWidth: TabWidth
    public let tabsControlRecommendedHeight: CGFloat = 24.0

    public init(theme: Theme = DefaultTheme(), tabButtonWidth: TabWidth = .flexible(min: 50, max: 150)) {
        self.theme = theme
        self.tabButtonWidth = tabButtonWidth
    }
}
