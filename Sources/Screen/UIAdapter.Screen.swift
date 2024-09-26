//
//  UIAdapter.Screen.swift
//  ┌─┐      ┌───────┐ ┌───────┐
//  │ │      │ ┌─────┘ │ ┌─────┘
//  │ │      │ └─────┐ │ └─────┐
//  │ │      │ ┌─────┘ │ ┌─────┘
//  │ └─────┐│ └─────┐ │ └─────┐
//  └───────┘└───────┘ └───────┘
//
//  Created by lee on 2018/1/22.
//  Copyright © 2018年 lee. All rights reserved.
//

// https://www.screensizes.app
// https://useyourloaf.com/blog/iphone-14-screen-sizes/?continueFlag=d151fc49ec5161587c30f15faea0bee9

import Foundation

#if os(iOS)

import UIKit

public class UIAdapterScreenWrapper<Base> {
    
    let base: Screen
    
    public private(set) var value: Base
    
    init(_ value: Base) {
        self.base = .main
        self.value = value
    }
    
    init(_ value: Base, _ screen: UIScreen) {
        self.base = .init(screen)
        self.value = value
    }
}

public protocol UIAdapterScreenCompatible {
    associatedtype ScreenCompatibleType
    var screen: ScreenCompatibleType { get }
    
    func screen(_: UIScreen) -> ScreenCompatibleType
}

extension UIAdapterScreenCompatible {
    
    public var screen: UIAdapterScreenWrapper<Self> {
        get { return UIAdapterScreenWrapper(self) }
    }
    
    public func screen(_ screen: UIScreen) -> UIAdapterScreenWrapper<Self> {
        return UIAdapterScreenWrapper(self, screen)
    }
}

extension UIAdapterScreenWrapper {
    
    public typealias Screen = UIAdapter.Screen
    
    public func width(_ range: Range<CGFloat>, is value: Base, zoomed: Base? = nil) -> Self {
        return width({ range.contains($0) }, is: value, zoomed: zoomed ?? value)
    }
    public func width(_ range: ClosedRange<CGFloat>, is value: Base, zoomed: Base? = nil) -> Self {
        return width({ range.contains($0) }, is: value, zoomed: zoomed ?? value)
    }
    public func width(_ range: PartialRangeFrom<CGFloat>, is value: Base, zoomed: Base? = nil) -> Self {
        return width({ range.contains($0) }, is: value, zoomed: zoomed ?? value)
    }
    public func width(_ range: PartialRangeUpTo<CGFloat>, is value: Base, zoomed: Base? = nil) -> Self {
        return width({ range.contains($0) }, is: value, zoomed: zoomed ?? value)
    }
    public func width(_ range: PartialRangeThrough<CGFloat>, is value: Base, zoomed: Base? = nil) -> Self {
        return width({ range.contains($0) }, is: value, zoomed: zoomed ?? value)
    }
    
    public func width(greaterThan base: CGFloat, is value: Base, zoomed: Base? = nil) -> Self {
        return width({ $0 > base }, is: value, zoomed: zoomed ?? value)
    }
    public func width(lessThan base: CGFloat, is value: Base, zoomed: Base? = nil) -> Self {
        return width({ $0 < base }, is: value, zoomed: zoomed ?? value)
    }
    public func width(equalTo base: CGFloat, is value: Base, zoomed: Base? = nil) -> Self {
        return width({ $0 == base }, is: value, zoomed: zoomed ?? value)
    }
    private func width(_ matching: (CGFloat) -> Bool, is value: Base, zoomed: Base) -> Self {
        if matching(base.size.width) {
            self.value = base.isZoomedMode ? zoomed : value
        }
        return self
    }
    
    public func height(_ range: Range<CGFloat>, is value: Base, zoomed: Base? = nil) -> Self {
        return height({ range.contains($0) }, is: value, zoomed: zoomed ?? value)
    }
    public func height(_ range: ClosedRange<CGFloat>, is value: Base, zoomed: Base? = nil) -> Self {
        return height({ range.contains($0) }, is: value, zoomed: zoomed ?? value)
    }
    public func height(_ range: PartialRangeFrom<CGFloat>, is value: Base, zoomed: Base? = nil) -> Self {
        return height({ range.contains($0) }, is: value, zoomed: zoomed ?? value)
    }
    public func height(_ range: PartialRangeUpTo<CGFloat>, is value: Base, zoomed: Base? = nil) -> Self {
        return height({ range.contains($0) }, is: value, zoomed: zoomed ?? value)
    }
    public func height(_ range: PartialRangeThrough<CGFloat>, is value: Base, zoomed: Base? = nil) -> Self {
        return height({ range.contains($0) }, is: value, zoomed: zoomed ?? value)
    }
    
    public func height(greaterThan base: CGFloat, is value: Base, zoomed: Base? = nil) -> Self {
        return height({ $0 > base }, is: value, zoomed: zoomed ?? value)
    }
    public func height(lessThan base: CGFloat, is value: Base, zoomed: Base? = nil) -> Self {
        return height({ $0 < base }, is: value, zoomed: zoomed ?? value)
    }
    public func height(equalTo base: CGFloat, is value: Base, zoomed: Base? = nil) -> Self {
        return height({ $0 == base }, is: value, zoomed: zoomed ?? value)
    }
    private func height(_ matching: (CGFloat) -> Bool, is value: Base, zoomed: Base) -> Self {
        if matching(base.size.height) {
            self.value = base.isZoomedMode ? zoomed : value
        }
        return self
    }
    
    public func inch(_ range: Range<Double>, is value: Base, zoomed: Base? = nil) -> Self {
        return inch({ range.contains($0.rawValue) }, is: value, zoomed: zoomed ?? value)
    }
    public func inch(_ range: ClosedRange<Double>, is value: Base, zoomed: Base? = nil) -> Self {
        return inch({ range.contains($0.rawValue) }, is: value, zoomed: zoomed ?? value)
    }
    public func inch(_ range: PartialRangeFrom<Double>, is value: Base, zoomed: Base? = nil) -> Self {
        return inch({ range.contains($0.rawValue) }, is: value, zoomed: zoomed ?? value)
    }
    public func inch(_ range: PartialRangeUpTo<Double>, is value: Base, zoomed: Base? = nil) -> Self {
        return inch({ range.contains($0.rawValue) }, is: value, zoomed: zoomed ?? value)
    }
    public func inch(_ range: PartialRangeThrough<Double>, is value: Base, zoomed: Base? = nil) -> Self {
        return inch({ range.contains($0.rawValue) }, is: value, zoomed: zoomed ?? value)
    }
    private func inch(_ matching: (Screen.Inch) -> Bool, is value: Base, zoomed: Base) -> Self {
        if matching(base.inch) {
            self.value = base.isZoomedMode ? zoomed : value
        }
        return self
    }
    
    public func inch(_ types: Screen.Inch..., is value: Base, zoomed: Base? = nil) -> Self {
        return inch(types, is: value, zoomed: zoomed ?? value)
    }
    public func inch(_ types: [Screen.Inch], is value: Base, zoomed: Base? = nil) -> Self {
        for type in types where base.inch == type {
            self.value = base.isZoomedMode ? zoomed ?? value : value
        }
        return self
    }
    
    public func level(_ types: Screen.Level..., is value: Base, zoomed: Base? = nil) -> Self {
        return level(types, is: value, zoomed: zoomed ?? value)
    }
    public func level(_ types: [Screen.Level], is value: Base, zoomed: Base? = nil) -> Self {
        for type in types where base.level == type {
            self.value = base.isZoomedMode ? zoomed ?? value : value
        }
        return self
    }
}

extension UIAdapter {
    
    public class Screen {
        
        let base: UIScreen
        
        init(_ base: UIScreen) {
            self.base = base
        }
        
        public var size: CGSize {
            base.bounds.size
        }
        public var nativeSize: CGSize {
            base.nativeBounds.size
        }
        public var scale: CGFloat {
            base.scale
        }
        public var nativeScale: CGFloat {
            base.nativeScale
        }
        
        /// 是否为显示缩放模式
        public var isZoomedMode: Bool {
            guard !UIDevice.iPhonePlus else { return size.width == 375 }
            guard !UIDevice.iPhoneMini else { return size.width == 320 }
            return scale != nativeScale
        }
        
        /// 真实宽高比 例如: iPhone 16 Pro (201:437)
        public var aspectRatio: String {
            if
                let cache = _aspectRatio,
                cache.0 == nativeSize {
                return cache.1
                
            } else {
                let result = base.aspectRatio
                _aspectRatio = (nativeSize, result)
                return result
            }
        }
        private var _aspectRatio: (CGSize, String)?
        
        /// 标准宽高比 例如: iPhone 16 Pro (9:19.5)
        public var standardAspectRatio: String {
            if
                let cache = _standardAspectRatio,
                cache.0 == nativeSize {
                return cache.1
                
            } else {
                let result = base.standardAspectRatio
                _standardAspectRatio = (nativeSize, result)
                return result
            }
        }
        private var _standardAspectRatio: (CGSize, String)?
    }
}

extension UIAdapter.Screen {
    
    /// 当前主屏幕
    public static let main = UIAdapter.Screen(.main)
}

extension UIAdapter.Screen {
    
    public enum Inch: Double {
        case unknown = -1
        case _3_5 = 3.5
        case _4_0 = 4.0
        case _4_7 = 4.7
        case _5_4 = 5.4
        case _5_5 = 5.5
        case _5_8 = 5.8
        case _6_1 = 6.1
        case _6_3 = 6.3
        case _6_5 = 6.5
        case _6_7 = 6.7
        case _6_9 = 6.9
    }
    
    public var inch: Inch {
        switch (nativeSize.width / scale, nativeSize.height / scale, scale) {
        case (320, 480, 2):
            return ._3_5
            
        case (320, 568, 2):
            return ._4_0
            
        case (375, 667, 2):
            return ._4_7
            
        case (360, 780, 3) where UIDevice.iPhoneMini, (375, 812, 3) where UIDevice.iPhoneMini:
            return ._5_4
            
        case (360, 640, 3) where UIDevice.iPhonePlus, (414, 736, 3) where UIDevice.iPhonePlus:
            return ._5_5
        
        case (375, 812, 3):
            return ._5_8
            
        case (414, 896, 2), (390, 844, 3), (393, 852, 3):
            return ._6_1
            
        case (402, 874, 3):
            return ._6_3

        case (414, 896, 3):
            return ._6_5
            
        case (428, 926, 3), (430, 932, 3):
            return ._6_7
            
        case (440, 956, 3):
            return ._6_9
            
        default:
            return .unknown
        }
    }
    
    public enum Level: Int {
        case unknown = -1
        /// 3: 2
        case compact
        /// 16: 9
        case regular
        /// 19.5: 9
        case full
        
        public var isCompact: Bool {
            self == .compact
        }
        
        public var isRegular: Bool {
            self == .regular
        }
        
        public var isFull: Bool {
            self == .full
        }
    }
    
    public var level: Level {
        switch standardAspectRatio {
        case "3:4", "4:3":
            return .compact
            
        case "9:16", "16:9":
            return .regular
        
        case "9:19.5", "19.5:9":
            return .full
            
        default:
            return .unknown
        }
    }
}

extension Int: UIAdapterScreenCompatible {}
extension Bool: UIAdapterScreenCompatible {}
extension Float: UIAdapterScreenCompatible {}
extension Double: UIAdapterScreenCompatible {}
extension String: UIAdapterScreenCompatible {}
extension CGRect: UIAdapterScreenCompatible {}
extension CGSize: UIAdapterScreenCompatible {}
extension CGFloat: UIAdapterScreenCompatible {}
extension CGPoint: UIAdapterScreenCompatible {}
extension UIImage: UIAdapterScreenCompatible {}
extension UIColor: UIAdapterScreenCompatible {}
extension UIFont: UIAdapterScreenCompatible {}
extension UIEdgeInsets: UIAdapterScreenCompatible {}


fileprivate extension UIDevice {
    
    /// 是否使用了降采样
    static var isUsingDownsampling: Bool {
        return iPhoneMini || iPhonePlus
    }
    
    static var iPhoneMini: Bool {
        let temp = ["iPhone13,1", "iPhone14,4"]
        
        switch identifier {
        case "iPhone13,1", "iPhone14,4":
            return true
            
        case "i386", "x86_64", "arm64":
            return temp.contains(ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "")
            
        default:
            return false
        }
    }
    
    static var iPhonePlus: Bool {
        let temp = [
            "iPhone7,1",
            "iPhone8,2",
            "iPhone9,2",
            "iPhone9,4",
            "iPhone10,2",
            "iPhone10,5"
        ]
        
        switch identifier {
        case
            "iPhone7,1",
            "iPhone8,2",
            "iPhone9,2",
            "iPhone9,4",
            "iPhone10,2",
            "iPhone10,5":
            return true
            
        case "i386", "x86_64", "arm64":
            return temp.contains(ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "")
            
        default:
            return false
        }
    }
    
    private static let identifier: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let mirror = Mirror(reflecting: systemInfo.machine)
        
        let identifier = mirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    } ()
}

extension UIScreen {
    
    /// 真实宽高比 例如: iPhone 16 Pro (201:437)
    var aspectRatio: String {
        // 计算宽高比
        let (ratioWidth, ratioHeight) = calculateAspectRatio(
            width: nativeBounds.width,
            height: nativeBounds.height
        )
        return "\(ratioWidth):\(ratioHeight)"
    }
    
    /// 标准宽高比 例如: iPhone 16 Pro (9:19.5)
    var standardAspectRatio: String {
        // 获取近似的标准比例
        return getStandardAspectRatio(
            width: nativeBounds.width,
            height: nativeBounds.height
        )
    }
    
    private func calculateAspectRatio(width: CGFloat, height: CGFloat) -> (Int, Int) {
        // 计算最大公约数（欧几里得算法）
        func gcd(_ a: Int, _ b: Int) -> Int {
            var a = a
            var b = b
            while b != 0 {
                let temp = b
                b = a % b
                a = temp
            }
            return a
        }
        
        let precision: CGFloat = 1000  // 精度倍数
        let widthInt = Int(width * precision)
        let heightInt = Int(height * precision)
        
        let gcdValue = gcd(widthInt, heightInt)
        
        let ratioWidth = widthInt / gcdValue
        let ratioHeight = heightInt / gcdValue
        
        return (ratioWidth, ratioHeight)
    }
    
    private func getStandardAspectRatio(width: CGFloat, height: CGFloat) -> String {
        let aspectRatio = width / height
        
        // 常见的屏幕比例
        let commonRatios: [(ratio: CGFloat, description: String)] = [
            (16.0/9.0, "16:9"),
            (9.0/16.0, "9:16"),
            (4.0/3.0, "4:3"),
            (3.0/4.0, "3:4"),
            (19.5/9.0, "19.5:9"),
            (9.0/19.5, "9:19.5"),
            (2.0/1.0, "2:1"),
            (1.0/2.0, "1:2"),
            (1.0/1.0, "1:1")
        ]
        
        var closestRatio = commonRatios[0]
        var smallestDifference = abs(aspectRatio - closestRatio.ratio)
        
        for ratio in commonRatios {
            let difference = abs(aspectRatio - ratio.ratio)
            if difference < smallestDifference {
                smallestDifference = difference
                closestRatio = ratio
            }
        }
        
        return closestRatio.description
    }
}

#endif
