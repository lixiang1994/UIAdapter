//
//  UIAdapter.Zoom.swift
//  ┌─┐      ┌───────┐ ┌───────┐
//  │ │      │ ┌─────┘ │ ┌─────┘
//  │ │      │ └─────┐ │ └─────┐
//  │ │      │ ┌─────┘ │ ┌─────┘
//  │ └─────┐│ └─────┐ │ └─────┐
//  └───────┘└───────┘ └───────┘
//
//  Created by lee on 2018/11/2.
//  Copyright © 2018年 lee. All rights reserved.
//

#if canImport(Foundation)

import Foundation

#if os(iOS)

import UIKit

public enum UIAdapter {
    
    public enum Zoom {
        
        /// 设置转换闭包
        ///
        /// - Parameter conversion: 转换闭包
        public static func set(conversion: @escaping ((Double) -> Double)) {
            conversionClosure = conversion
        }
        
        /// 转换 用于数值的等比例计算 如需自定义可重新设置
        static var conversionClosure: ((Double) -> Double) = { (origin) in
            guard UIDevice.current.userInterfaceIdiom == .phone else {
                return origin
            }
            
            let base = 375.0
            let screenWidth = Double(UIScreen.main.bounds.width)
            let screenHeight = Double(UIScreen.main.bounds.height)
            let width = min(screenWidth, screenHeight)
            let result = origin * (width / base)
            let scale = Double(UIScreen.main.scale)
            return (result * scale).rounded(.up) / scale
        }
    }
}

extension UIAdapter.Zoom {
    
    static func conversion(_ value: Double) -> Double {
        return conversionClosure(value)
    }
}

protocol UIAdapterZoomCalculationable {
    
    /// 缩放计算
    ///
    /// - Returns: 结果
    func zoom() -> Self
}

extension Double: UIAdapterZoomCalculationable {
    
    func zoom() -> Double {
        return UIAdapter.Zoom.conversion(self)
    }
}

extension BinaryInteger {
    
    public func zoom() -> Double {
        let temp = Double("\(self)") ?? 0
        return temp.zoom()
    }
    public func zoom<T>() -> T where T : BinaryInteger {
        let temp = Double("\(self)") ?? 0
        return temp.zoom()
    }
    public func zoom<T>() -> T where T : BinaryFloatingPoint {
        let temp = Double("\(self)") ?? 0
        return temp.zoom()
    }
}

extension BinaryFloatingPoint {
    
    public func zoom() -> Double {
        let temp = Double("\(self)") ?? 0
        return temp.zoom()
    }
    public func zoom<T>() -> T where T : BinaryInteger {
        let temp = Double("\(self)") ?? 0
        return T(temp.zoom())
    }
    public func zoom<T>() -> T where T : BinaryFloatingPoint {
        let temp = Double("\(self)") ?? 0
        return T(temp.zoom())
    }
}

extension CGPoint: UIAdapterZoomCalculationable {
    
    public func zoom() -> CGPoint {
        return CGPoint(x: x.zoom(), y: y.zoom())
    }
}

extension CGSize: UIAdapterZoomCalculationable {
    
    public func zoom() -> CGSize {
        return CGSize(width: width.zoom(), height: height.zoom())
    }
}

extension CGRect: UIAdapterZoomCalculationable {
    
    public func zoom() -> CGRect {
        return CGRect(origin: origin.zoom(), size: size.zoom())
    }
}

extension CGVector: UIAdapterZoomCalculationable {
    
    public func zoom() -> CGVector {
        return CGVector(dx: dx.zoom(), dy: dy.zoom())
    }
}

extension UIOffset: UIAdapterZoomCalculationable {
    
    public func zoom() -> UIOffset {
        return UIOffset(horizontal: horizontal.zoom(), vertical: vertical.zoom())
    }
}

extension UIEdgeInsets: UIAdapterZoomCalculationable {
    
    public func zoom() -> UIEdgeInsets {
        return UIEdgeInsets(
            top: top.zoom(),
            left: left.zoom(),
            bottom: bottom.zoom(),
            right: right.zoom()
        )
    }
}


extension NSLayoutConstraint {
    
    @IBInspectable private var zoomConstant: Bool {
        get { return false }
        set {
            guard newValue else { return }
            
            constant = constant.zoom()
        }
    }
}

extension UIView {
    
    @IBInspectable private var zoomCornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set {
            let value: CGFloat = newValue.zoom()
            layer.masksToBounds = true
            layer.cornerRadius = abs(CGFloat(Int(value * 100)) / 100)
        }
    }
}

extension UILabel {
    
    @IBInspectable private var zoomFont: Bool {
        get { return false }
        set {
            guard newValue else { return }
            guard let text = attributedText?.mutableCopy() as? NSMutableAttributedString else {
                return
            }
            
            font = font.withSize(font.pointSize.zoom())
            attributedText = text.reset(font: { $0.zoom() })
        }
    }
    
    @IBInspectable private var zoomLine: Bool {
        get { return false }
        set {
            guard newValue else { return }
            guard let text = attributedText else { return }
            
            attributedText = text.reset(line: { $0.zoom() })
        }
    }
    
    @IBInspectable private var zoomShadowOffset: Bool {
        get { return false }
        set {
            guard newValue else { return }
            
            shadowOffset = shadowOffset.zoom()
        }
    }
}

extension UITextView {
    
    @IBInspectable private var zoomFont: Bool {
        get { return false }
        set {
            guard newValue else { return }
            guard let font = font else { return }
            
            self.font = font.withSize(font.pointSize.zoom())
        }
    }
}

extension UITextField {
    
    @IBInspectable private var zoomFont: Bool {
        get { return false }
        set {
            guard newValue else { return }
            guard let font = font else { return }
            
            self.font = font.withSize(font.pointSize.zoom())
        }
    }
}

extension UIImageView {
    
    @IBInspectable private var zoomImage: Bool {
        get { return false }
        set {
            guard newValue else { return }
            
            if let width = image?.size.width {
                image = image?.scaled(to: width.zoom())
            }
            if let width = highlightedImage?.size.width {
                highlightedImage = highlightedImage?.scaled(to: width.zoom())
            }
        }
    }
}

extension UIButton {
    
    @IBInspectable private var zoomTitle: Bool {
        get { return false }
        set {
            guard newValue else { return }
            
            let states: [UIControl.State] = [
                .normal,
                .highlighted,
                .selected,
                .disabled
            ]
            
            if
                let _ = title(for: state),
                let label = titleLabel,
                let font = label.font {
                label.font = font.withSize(font.pointSize.zoom())
            }
            
            let titles = states.enumerated().compactMap {
                (i, state) -> (Int, NSAttributedString)? in
                guard let t = attributedTitle(for: state) else { return nil }
                return (i, t)
            }
            titles.filtered(duplication: { $0.1 }).forEach {
                setAttributedTitle(
                    $0.1.reset(font: { $0.zoom() }),
                    for: states[$0.0]
                )
            }
        }
    }
    
    @IBInspectable private var zoomImage: Bool {
        get { return false }
        set {
            guard newValue else { return }
            
            let states: [UIControl.State] = [
                .normal,
                .highlighted,
                .selected,
                .disabled
            ]
            
            let images = states.enumerated().compactMap {
                (i, state) -> (Int, UIImage)? in
                guard let v = image(for: state) else { return nil }
                return (i, v)
            }
            images.filtered(duplication: { $0.1 }).forEach {
                setImage(
                    $0.1.scaled(to: $0.1.size.width.zoom()),
                    for: states[$0.0]
                )
            }
            
            let backgrounds = states.enumerated().compactMap {
                (i, state) -> (Int, UIImage)? in
                guard let v = backgroundImage(for: state) else { return nil }
                return (i, v)
            }
            backgrounds.filtered(duplication: { $0.1 }).forEach {
                setBackgroundImage(
                    $0.1.scaled(to: $0.1.size.width.zoom()),
                    for: states[$0.0]
                )
            }
        }
    }
    
    @IBInspectable private var zoomTitleInsets: Bool {
        get { return false }
        set {
            guard newValue else { return }
            
            titleEdgeInsets = titleEdgeInsets.zoom()
        }
    }
    
    @IBInspectable private var zoomImageInsets: Bool {
        get { return false }
        set {
            guard newValue else { return }
            
            imageEdgeInsets = imageEdgeInsets.zoom()
        }
    }
    
    @IBInspectable private var zoomContentInsets: Bool {
        get { return false }
        set {
            guard newValue else { return }
            
            contentEdgeInsets = contentEdgeInsets.zoom()
        }
    }
}

@available(iOS 9.0, *)
extension UIStackView {
    
    @IBInspectable private var zoomSpacing: Bool {
        get { return false }
        set {
            guard newValue else { return }
            
            spacing = spacing.zoom()
        }
    }
}

fileprivate extension NSAttributedString {
    
    func reset(font size: (CGFloat) -> CGFloat) -> NSAttributedString {
        let string = NSMutableAttributedString(attributedString: self)
        enumerateAttributes(
            in: NSRange(location: 0, length: length),
            options: .longestEffectiveRangeNotRequired
        ) { (attributes, range, stop) in
            var temp = attributes
            if let font = attributes[.font] as? UIFont {
                temp[.font] = font.withSize(size(font.pointSize))
            }
            string.setAttributes(temp, range: range)
        }
        return string
    }
    
    func reset(line spacing: (CGFloat) -> CGFloat) -> NSAttributedString {
        let string = NSMutableAttributedString(attributedString: self)
        enumerateAttributes(
            in: NSRange(location: 0, length: length),
            options: .longestEffectiveRangeNotRequired
        ) { (attributes, range, stop) in
            var temp = attributes
            if let paragraph = attributes[.paragraphStyle] as? NSMutableParagraphStyle {
                paragraph.lineSpacing = spacing(paragraph.lineSpacing)
                temp[.paragraphStyle] = paragraph
            }
            string.setAttributes(temp, range: range)
        }
        return string
    }
}

fileprivate extension UIImage {
    
    func scaled(to width: CGFloat, opaque: Bool = false) -> UIImage? {
        guard self.size.width > 0 else {
            return nil
        }
        
        let scale = width / self.size.width
        let size = CGSize(width: width, height: self.size.height * scale)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        draw(in: CGRect(origin: .zero, size: size))
        let new = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return new
    }
}

fileprivate extension Array {
    
    func filtered<E: Equatable>(duplication closure: (Element) throws -> E) rethrows -> [Element] {
        return try reduce(into: [Element]()) { (result, e) in
            let contains = try result.contains { try closure($0) == closure(e) }
            result += contains ? [] : [e]
        }
    }
}

public extension Double {
    
    func rounded(_ decimalPlaces: Int) -> Double {
        let divisor = pow(10.0, Double(max(0, decimalPlaces)))
        return (self * divisor).rounded() / divisor
    }
}

public extension BinaryFloatingPoint {
    
    func rounded(_ decimalPlaces: Int) -> Double {
        let temp = Double("\(self)") ?? 0
        return temp.rounded(decimalPlaces)
    }
    
    func rounded<T>(_ decimalPlaces: Int) -> T where T: BinaryFloatingPoint {
        let temp = Double("\(self)") ?? 0
        return T(temp.rounded(decimalPlaces))
    }
}

public extension CGPoint {
    
    func rounded(_ decimalPlaces: Int) -> CGPoint {
        return CGPoint(x: x.rounded(decimalPlaces), y: y.rounded(decimalPlaces))
    }
}

public extension CGSize {
    
    func rounded(_ decimalPlaces: Int) -> CGSize {
        return CGSize(width: width.rounded(decimalPlaces), height: height.rounded(decimalPlaces))
    }
}

public extension CGRect {
    
    func rounded(_ decimalPlaces: Int) -> CGRect {
        return CGRect(origin: origin.rounded(decimalPlaces), size: size.rounded(decimalPlaces))
    }
}

public extension UIEdgeInsets {
    
    func rounded(_ decimalPlaces: Int) -> UIEdgeInsets {
        return UIEdgeInsets(
            top: top.rounded(decimalPlaces),
            left: left.rounded(decimalPlaces),
            bottom: bottom.rounded(decimalPlaces),
            right: right.rounded(decimalPlaces)
        )
    }
}

#endif

#endif

