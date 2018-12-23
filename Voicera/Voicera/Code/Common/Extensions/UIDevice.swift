//
//  UIDevice.swift
//  Voicera
//
//  Created by Mikael on 12/23/18.
//  Copyright © 2018 Mikael-Melkonyan. All rights reserved.
//

import UIKit

extension UIDevice {
    
    enum ScreenType {
        case iPhone4
        case iPhones_5_5s_5c_SE
        case iPhones_6_6s_7_8
        case iPhones_6Plus_6sPlus_7Plus_8Plus
        case iPhoneX_XS
        case iPhoneXR
        case iPhoneXSMax
        case unknown
    }
    
    var screenType: ScreenType {
        switch UIScreen.main.nativeBounds.height {
        case 960:
            return .iPhone4
        case 1136:
            return .iPhones_5_5s_5c_SE
        case 1334:
            return .iPhones_6_6s_7_8
        case 1920, 2208:
            return .iPhones_6Plus_6sPlus_7Plus_8Plus
        case 2436:
            return .iPhoneX_XS
        case 1792:
            return .iPhoneXR
        case 2688:
            return .iPhoneXSMax
        default:
            return .unknown
        }
    }
    
    var screenHeight: CGFloat {
        switch screenType {
        case .iPhone4:
            return 480
        case .iPhones_5_5s_5c_SE:
            return 568
        case .iPhones_6_6s_7_8:
            return 667
        case .iPhones_6Plus_6sPlus_7Plus_8Plus:
            return 736
        case .iPhoneX_XS:
            return 812
        case .iPhoneXR, .iPhoneXSMax, .unknown:
            return 896
        }
    }
    
    var isXFamily: Bool {
        switch screenType {
        case .iPhoneX_XS, .iPhoneXR, .iPhoneXSMax:
            return true
        default:
            return false
        }
    }
}
