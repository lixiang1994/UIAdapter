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
    let base: Base
    
    public private(set) var value: Base
    
    init(_ base: Base) {
        self.base = base
        self.value = base
    }
}

public protocol UIAdapterScreenCompatible {
    associatedtype ScreenCompatibleType
    var screen: ScreenCompatibleType { get }
}

extension UIAdapterScreenCompatible {
    
    public var screen: UIAdapterScreenWrapper<Self> {
        get { return UIAdapterScreenWrapper(self) }
    }
}

extension UIAdapterScreenWrapper {
    
    public typealias Screen = UIAdapter.Screen
    
    public func width(_ types: Screen.Width..., is value: Base) -> Self {
        return width(types, is: value, zoomed: value)
    }
    public func width(_ types: Screen.Width..., is value: Base, zoomed: Base) -> Self {
        return width(types, is: value, zoomed: zoomed)
    }
    private func width(_ types: [Screen.Width], is value: Base, zoomed: Base) -> Self {
        for type in types where Screen.Width.current == type {
            self.value = Screen.isZoomedMode ? zoomed : value
        }
        return self
    }
    
    public func height(_ types: Screen.Height..., is value: Base) -> Self {
        return height(types, is: value, zoomed: value)
    }
    public func height(_ types: Screen.Height..., is value: Base, zoomed: Base) -> Self {
        return height(types, is: value, zoomed: zoomed)
    }
    private func height(_ types: [Screen.Height], is value: Base, zoomed: Base) -> Self {
        for type in types where Screen.Height.current == type {
            self.value = Screen.isZoomedMode ? zoomed : value
        }
        return self
    }
    
    public func inch(_ types: Screen.Inch..., is value: Base) -> Self {
        return inch(types, is: value, zoomed: value)
    }
    public func inch(_ types: Screen.Inch..., is value: Base, zoomed: Base) -> Self {
        return inch(types, is: value, zoomed: zoomed)
    }
    private func inch(_ types: [Screen.Inch], is value: Base, zoomed: Base) -> Self {
        for type in types where Screen.Inch.current == type {
            self.value = Screen.isZoomedMode ? zoomed : value
        }
        return self
    }
    
    public func level(_ types: Screen.Level..., is value: Base) -> Self {
        return level(types, is: value, zoomed: value)
    }
    public func level(_ types: Screen.Level..., is value: Base, zoomed: Base) -> Self {
        return level(types, is: value, zoomed: zoomed)
    }
    private func level(_ types: [Screen.Level], is value: Base, zoomed: Base) -> Self {
        for type in types where Screen.Level.current == type {
            self.value = Screen.isZoomedMode ? zoomed : value
        }
        return self
    }
}

extension UIAdapter {
    
    public enum Screen {
        
        static var size: CGSize {
            UIScreen.main.bounds.size
        }
        static var nativeSize: CGSize {
            UIScreen.main.nativeBounds.size
        }
        static var scale: CGFloat {
            UIScreen.main.scale
        }
        static var nativeScale: CGFloat {
            UIScreen.main.nativeScale
        }
    }
}

extension UIAdapter.Screen {
    
    public static var isZoomedMode: Bool {
        guard !isPlus else { return UIScreen.main.bounds.width == 375 }
        return UIScreen.main.scale != UIScreen.main.nativeScale
    }
    
    public enum Width: CGFloat {
        case unknown = -1
        case _320 = 320
        case _375 = 375
        case _390 = 390
        case _393 = 393
        case _414 = 414
        case _428 = 428
        case _430 = 430
        
        public static var current: Width {
            guard !isPlus else { return ._414 }
            return Width(rawValue: nativeSize.width / scale) ?? .unknown
        }
    }
    
    public enum Height: CGFloat {
        case unknown = -1
        case _480 = 480
        case _568 = 568
        case _667 = 667
        case _736 = 736
        case _812 = 812
        case _844 = 844
        case _852 = 852
        case _896 = 896
        case _926 = 926
        case _932 = 932
        
        public static var current: Height {
            guard !isPlus else { return ._736 }
            return Height(rawValue: nativeSize.height / scale) ?? .unknown
        }
    }
    
    public enum Inch: Double {
        case unknown = -1
        case _3_5 = 3.5
        case _4_0 = 4.0
        case _4_7 = 4.7
        case _5_4 = 5.4
        case _5_5 = 5.5
        case _5_8 = 5.8
        case _6_1 = 6.1
        case _6_5 = 6.5
        case _6_7 = 6.7
        
        public static var current: Inch {
            guard !isPlus else {
                // Plus 机型比较特殊 下面公式无法正确计算出尺寸
                return ._5_5
            }
            
            switch (nativeSize.width / scale, nativeSize.height / scale, scale) {
            case (320, 480, 2):
                return ._3_5
                
            case (320, 568, 2):
                return ._4_0
                
            case (375, 667, 2):
                return ._4_7
                
            case (375, 812, 3) where UIDevice.iPhoneMini:
                return ._5_4
                
            case (414, 736, 3):
                return ._5_5
            
            case (375, 812, 3):
                return ._5_8
                
            case (414, 896, 2), (390, 844, 3), (393, 852, 3):
                return ._6_1

            case (414, 896, 3):
                return ._6_5
                
            case (428, 926, 3), (430, 932, 3):
                return ._6_7
                
            default:
                return .unknown
            }
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
        
        public static var current: Level {
            guard !isPlus else {
                // Plus 机型比较特殊 下面公式无法正确计算出尺寸
                return .regular
            }
            
            switch (nativeSize.width / scale, nativeSize.height / scale) {
            case (320, 480):
                return .compact
                
            case (320, 568), (375, 667), (414, 736):
                return .regular
            
            case (375, 812), (414, 896), (390, 844), (393, 852), (428, 926), (430, 932):
                return .full
                
            default:
                return .unknown
            }
        }
    }
    
    private static var isPlus: Bool {
        return nativeSize.equalTo(.init(width: 1080, height: 1920))
    }
}

extension UIAdapter.Screen {
    
    public static var isCompact: Bool {
        return Level.current == .compact
    }
    
    public static var isRegular: Bool {
        return Level.current == .regular
    }
    
    public static var isFull: Bool {
        return Level.current == .full
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
    
    static var iPhoneMini: Bool {
        switch identifier {
        case "iPhone13,1", "iPhone14,4":
            return true
            
        case "i386", "x86_64", "arm64":
            return ["iPhone13,1", "iPhone14,4"].contains(
                ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? ""
            )
            
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

#endif
