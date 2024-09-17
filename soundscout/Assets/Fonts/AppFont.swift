//
//  AppFont.swift
//  soundscout
//
//  Created by Sam Davies on 06/08/2024.
//

import UIKit
import SwiftUI

extension Font {
    
    // Inter Bold
    static public let interBold30 = Font.custom("Inter-Bold", size: 30)
    static public let interBold18 = Font.custom("Inter-Bold", size: 18)
    
    // Inter SemiBold
    static public let interSemiBold30 = Font.custom("Inter-SemiBold", size: 30)
    static public let interSemiBold24 = Font.custom("Inter-SemiBold", size: 24)
    static public let interSemiBold16 = Font.custom("Inter-SemiBold", size: 16)
    static public let interSemiBold14 = Font.custom("Inter-SemiBold", size: 14)
    static public let interSemiBold12 = Font.custom("Inter-SemiBold", size: 12)
    
    // Inter Medium
    static public let interMedium18 = Font.custom("Inter-Medium", size: 18)
    static public let interMedium14 = Font.custom("Inter-Medium", size: 14)
    static public let interMedium12 = Font.custom("Inter-Medium", size: 12)
    
    // Inter Regular
    static public let interRegular14 = Font.custom("Inter-Regular", size: 14)
    
    // Inter Light
    static public let interLight14 = Font.custom("Inter-Light", size: 14)
    static public let interLight12 = Font.custom("Inter-Light", size: 12)
    
    /// <#Description#>
    /// - Parameters:
    ///   - name: <#name description#>
    ///   - size: <#size description#>
    /// - Returns: <#description#>
    static public func getUIFont(for name: String, ofSize size: CGFloat) -> UIFont {
        guard let customFont = UIFont(name: name, size: size) else {
            fatalError("Failed to Load Custom Font.")
        }
        return customFont
    }
    
}

