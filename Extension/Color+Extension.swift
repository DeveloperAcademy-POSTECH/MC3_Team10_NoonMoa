//
//  Color+Extension.swift
//  MC3
//
//  Created by 최민규 on 2023/07/16.
//

import Foundation
import SwiftUI

extension Color {
    init(hex: UInt, alpha: Double = 1.0) {
            let red = Double((hex >> 16) & 0xff) / 255.0
            let green = Double((hex >> 8) & 0xff) / 255.0
            let blue = Double(hex & 0xff) / 255.0
            self.init(red: red, green: green, blue: blue, opacity: alpha)
    }
    static let userPink = Color(hex: 0xFD8A8A)
    static let userYellow = Color(hex: 0xF1F7B5)
    static let userCyan = Color(hex: 0xA8D1D1)
    static let userBlue = Color(hex: 0x9Ea1D4)
    
    static let eyePink = Color(hex: 0xFFABAB)
    static let eyeYellow = Color(hex: 0xF8FBD9)
    static let eyeCyan = Color(hex: 0xC2DFDF)
    static let eyeBlue = Color(hex: 0xBABCDF)
    
    struct sky {
        static let clearDay = LinearGradient(colors: [Color(hex: 0xA9D4EC), Color(hex: 0xDAEBF5)], startPoint: .top, endPoint: .bottom)
        static let clearNight = LinearGradient(colors: [Color(hex: 0x354787), Color(hex: 0xC2CFFB)], startPoint: .top, endPoint: .bottom)
        static let cloudyDay = LinearGradient(colors: [Color(hex: 0xB1B1B1), Color(hex: 0xE4EDF5)], startPoint: .top, endPoint: .bottom)
        static let cloudyNight = LinearGradient(colors: [Color(hex: 0x565F81), Color(hex: 0xB3B9CD)], startPoint: .top, endPoint: .bottom)
        static let rainyDay = LinearGradient(colors: [Color(hex: 0xB1B1B1), Color(hex: 0xE4EDF5)], startPoint: .top, endPoint: .bottom)
        static let rainyNight = LinearGradient(colors: [Color(hex: 0x565F81), Color(hex: 0xB3B9CD)], startPoint: .top, endPoint: .bottom)
        static let snowyDay = LinearGradient(colors: [Color(hex: 0xB8CBEF), Color(hex: 0xB4B7BD)], startPoint: .top, endPoint: .bottom)
        static let snowyNight = LinearGradient(colors: [Color(hex: 0x514B98), Color(hex: 0xBCBBC9)], startPoint: .top, endPoint: .bottom)
    }
    
    struct ground {
        static let grassGreen = LinearGradient(colors: [Color(hex: 0x768D72), Color(hex: 0x9FC19A)], startPoint: .top, endPoint: .bottom)
        static let dirtBrown = LinearGradient(colors: [Color(hex: 0x7D7E6C), Color(hex: 0xB0B19A)], startPoint: .top, endPoint: .bottom)
        static let snowWhite = LinearGradient(colors: [Color(hex: 0xCECECE), Color(hex: 0xFFFFFF)], startPoint: .top, endPoint: .bottom)
        static let pathBeige = LinearGradient(colors: [Color(hex: 0xE1DCD3), Color(hex: 0xF0EAE0)], startPoint: .top, endPoint: .bottom)
    }

}

extension Image {
    
    struct symbol {
        static let moon = Image(systemName: "moon.fill")
    }
    
    struct assets {
        static let apartment = Image("Apartment")
        
        struct ground {
            static let grassGreen = Image("Ground_grassGreen")
            static let dirtBrown = Image("Ground_dirtBrown")
            static let snowWhite = Image("Ground_snowWhite")
        }
        
        struct room {
            static let vacant = Image("Room_vacant")
            static let dark = Image("Room_dark")
            static let light = Image("Room_light")
            static let blind = Image("Room_blind")
            static let blindUp = Image("Room_blindUp")
        }
        
        struct eye {
            static let active = Image("Eye_active")
            static let inactive = Image("Eye_inactive")
        }
        
        struct weather {
            static let clearDay = Image("Weather_clearDay")
            static let clearNight = Image("Weather_clearNight")
            static let cloudyDay = Image("Weather_cloudyDay")
            static let cloudyNight = Image("Weather_cloudyNight")
            static let rainyDay = Image("Weather_rainyDay")
            static let rainyNight = Image("Weather_rainyNight")
            static let snowyDay = Image("Weather_snowyDay")
            static let snowyNight = Image("Weather_snowyNight")
            static let thunder = Image("Weather_thunder")

        }
        
    }
}
    
