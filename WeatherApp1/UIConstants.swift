//
//  UIConstants.swift
//  WeatherApp1
//
//  Created by Colin Smith on 7/11/22.
//

import Foundation
import SwiftUI

struct UIConstants {
    struct Colorz {
        static let day = Color.init(red: 62/255, green: 166/255, blue: 244/255)
        static let night = Color.init(red: 8/255, green: 23/255, blue: 35/255)
        static let dayNightGradient = LinearGradient(colors: [day, night], startPoint: .topLeading, endPoint: .bottomTrailing)
        
    }
}
