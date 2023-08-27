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
    
    static let systemGray = Color(hex: 0x787678)
    static let warmBlack = Color(hex: 0x333333)
    static let userPink = Color(hex: 0xDC7E7E)
    static let userYellow = Color(hex: 0xD4DA97)
    static let userCyan = Color(hex: 0x8BB2B2)
    static let userBlue = Color(hex: 0x8A8DC5)
    static let userThemeGreen1 = Color(hex: 0x58DA8C)
    static let userThemeBlue1 = Color(hex: 0x7BC0FF)
    static let userThemePink1 = Color(hex: 0xE56EC4)
    static let userThemeYellow1 = Color(hex: 0xDAD56C)
    
    static let announcementGray = Color(hex:0x5F5F5F)
    
    static let calendarGray = Color(hex: 0x808080)
   
    struct stampBorder {
        static let clearSunrise = Color(hex: 0xABD5ED)
        static let clearMorning = Color(hex: 0xABD5ED)
        static let clearAfternoon = Color(hex: 0xABD5ED)
        static let clearSunset = Color(hex: 0xC5C5C5)
        static let clearEvening = Color(hex: 0x3A4C8B)
        static let clearNight = Color(hex: 0x3A4C8B)
        
        static let cloudySunrise = Color(hex: 0xB3B4B4)
        static let cloudyMorning = Color(hex: 0xB3B4B4)
        static let cloudyAfternoon = Color(hex: 0xB3B4B4)
        static let cloudySunset = Color(hex: 0xC5C5C5)
        static let cloudyEvening = Color(hex: 0x5A6384)
        static let cloudyNight = Color(hex: 0x5A6384)
        
        static let rainySunrise = Color(hex: 0xB3B4B4)
        static let rainyMorning = Color(hex: 0xB3B4B4)
        static let rainyAfternoon = Color(hex: 0xB3B4B4)
        static let rainySunset = Color(hex: 0xC5C5C5)
        static let rainyEvening = Color(hex: 0x5A6384)
        static let rainyNight = Color(hex: 0x5A6384)
        
        static let snowySunrise = Color(hex: 0xB8CBEE)
        static let snowyMorning = Color(hex: 0xB8CBEE)
        static let snowyAfternoon = Color(hex: 0xB8CBEE)
        static let snowySunset = Color(hex: 0xC5C5C5)
        static let snowyEvening = Color(hex: 0x56509A)
        static let snowyNight = Color(hex: 0x56509A)
    }
}

extension LinearGradient {
    
    static let gradationGray = LinearGradient(colors: [Color(hex: 0xDDDDDD), Color(hex: 0xFFFFFF)], startPoint: .top, endPoint: .bottom)
    
    static let userPink = LinearGradient(colors: [Color(hex: 0xFFBFBF), Color(hex: 0xDC7E7E)], startPoint: .top, endPoint: .bottom)
    static let userYellow = LinearGradient(colors: [Color(hex: 0xF9FECA), Color(hex: 0xD4DA97)], startPoint: .top, endPoint: .bottom)
    static let userCyan = LinearGradient(colors: [Color(hex: 0xC5E3E3), Color(hex: 0x8BB2B2)], startPoint: .top, endPoint: .bottom)
    static let userBlue = LinearGradient(colors: [Color(hex: 0xB9BCE7), Color(hex: 0x8A8DC5)], startPoint: .top, endPoint: .bottom)
    static let unStampedWhite = LinearGradient(colors: [Color(hex: 0xFFFFFF).opacity(0.5), Color(hex: 0xFFFFFF)], startPoint: .top, endPoint: .bottom)
    
    static let eyePink = LinearGradient(colors: [Color(hex: 0xFFBFBF), Color(hex: 0xFFBFBF)], startPoint: .top, endPoint: .bottom)
    static let eyeYellow = LinearGradient(colors: [Color(hex: 0xF8FBD9), Color(hex: 0xF8FBD9)], startPoint: .top, endPoint: .bottom)
    static let eyeCyan = LinearGradient(colors: [Color(hex: 0xC5E3E3), Color(hex: 0xC5E3E3)], startPoint: .top, endPoint: .bottom)
    static let eyeBlue = LinearGradient(colors: [Color(hex: 0xB9BCE7), Color(hex: 0xB9BCE7)], startPoint: .top, endPoint: .bottom)
    
    static let cheekGray = LinearGradient(colors: [Color(hex: 0x888888), Color(hex: 0xAAAAAA)], startPoint: .top, endPoint: .bottom)
    static let cheekRed = LinearGradient(colors: [Color(hex: 0xFF6666), Color(hex: 0xFF0000)], startPoint: .top, endPoint: .bottom)
    
    
    struct sky {
        
        static let clearSunrise = LinearGradient(colors: [Color(hex: 0xBCD8E9), Color(hex: 0xFFD9D9)], startPoint: .top, endPoint: .bottom)
        static let clearMorning = LinearGradient(colors: [Color(hex: 0xA9D4EC), Color(hex: 0xDAEBF5)], startPoint: .top, endPoint: .bottom )
        static let clearAfternoon = LinearGradient(colors: [Color(hex: 0xA9D4EC), Color(hex: 0xDAEBF5)], startPoint: .top, endPoint: .bottom)
        static let clearSunset = LinearGradient(gradient: Gradient(colors: [Color(hex: 0xC4DCE1), Color(hex: 0xDAC1AF), Color(hex: 0xF2A482)]), startPoint: .top, endPoint: .bottom)
        static let clearEvening = LinearGradient(colors: [Color(hex: 0x26537D), Color(hex: 0xA8CAE9)], startPoint: .top, endPoint: .bottom)
        static let clearNight = LinearGradient(colors: [Color(hex: 0x232F5A), Color(hex: 0xADB8E0)], startPoint: .top, endPoint: .bottom)
        
        static let cloudySunrise = LinearGradient(colors: [Color(hex: 0xB1B1B1), Color(hex: 0xE4EDF5)], startPoint: .top, endPoint: .bottom)
        static let cloudyMorning = LinearGradient(colors: [Color(hex: 0xB1B1B1), Color(hex: 0xE4EDF5)], startPoint: .top, endPoint: .bottom)
        static let cloudyAfternoon = LinearGradient(colors: [Color(hex: 0xB1B1B1), Color(hex: 0xE4EDF5)], startPoint: .top, endPoint: .bottom)
        static let cloudySunset = LinearGradient(colors: [Color(hex: 0xB1B1B1), Color(hex: 0xE4EDF5)], startPoint: .top, endPoint: .bottom)
        static let cloudyEvening = LinearGradient(colors: [Color(hex: 0x565F81), Color(hex: 0xB3B9CD)], startPoint: .top, endPoint: .bottom)
        static let cloudyNight = LinearGradient(colors: [Color(hex: 0x565F81), Color(hex: 0xB3B9CD)], startPoint: .top, endPoint: .bottom)
        
        static let rainySunrise = LinearGradient(colors: [Color(hex: 0xBCD8E9), Color(hex: 0xFFD9D9)], startPoint: .top, endPoint: .bottom)
        static let rainyMorning = LinearGradient(colors: [Color(hex: 0xB1B1B1), Color(hex: 0xE4EDF5)], startPoint: .top, endPoint: .bottom)
        static let rainyAfternoon = LinearGradient(colors: [Color(hex: 0xB1B1B1), Color(hex: 0xE4EDF5)], startPoint: .top, endPoint: .bottom)
        static let rainySunset = LinearGradient(colors: [Color(hex: 0xB1B1B1), Color(hex: 0xE4EDF5)], startPoint: .top, endPoint: .bottom)
        static let rainyEvening = LinearGradient(colors: [Color(hex: 0x565F81), Color(hex: 0xB3B9CD)], startPoint: .top, endPoint: .bottom)
        static let rainyNight = LinearGradient(colors: [Color(hex: 0x565F81), Color(hex: 0xB3B9CD)], startPoint: .top, endPoint: .bottom)
        
        static let snowySunrise = LinearGradient(colors: [Color(hex: 0xBCD8E9), Color(hex: 0xFFD9D9)], startPoint: .top, endPoint: .bottom)
        static let snowyMorning = LinearGradient(colors: [Color(hex: 0xB8CBEF), Color(hex: 0xB4B7BD)], startPoint: .top, endPoint: .bottom)
        static let snowyAfternoon = LinearGradient(colors: [Color(hex: 0xB8CBEF), Color(hex: 0xB4B7BD)], startPoint: .top, endPoint: .bottom)
        static let snowySunset = LinearGradient(gradient: Gradient(colors: [Color(hex: 0xC4DCE1), Color(hex: 0xDAC1AF), Color(hex: 0xF2A482)]), startPoint: .top, endPoint: .bottom)
        static let snowyEvening = LinearGradient(colors: [Color(hex: 0x514B98), Color(hex: 0xBCBBC9)], startPoint: .top, endPoint: .bottom)
        static let snowyNight = LinearGradient(colors: [Color(hex: 0x514B98), Color(hex: 0xBCBBC9)], startPoint: .top, endPoint: .bottom)
        
        static let unStampedWhite = LinearGradient(colors: [Color(hex: 0xFFFFFF).opacity(0.5), Color(hex: 0xFFFFFF).opacity(0.5)], startPoint: .top, endPoint: .bottom)
    }
    
    struct ground {
        static let grassGreen = LinearGradient(colors: [Color(hex: 0x768D72), Color(hex: 0x9FC19A)], startPoint: .top, endPoint: .bottom)
        static let dirtBrown = LinearGradient(colors: [Color(hex: 0x7D7E6C), Color(hex: 0xB0B19A)], startPoint: .top, endPoint: .bottom)
        static let snowWhite = LinearGradient(colors: [Color(hex: 0xCECECE), Color(hex: 0xFFFFFF)], startPoint: .top, endPoint: .bottom)
        static let pathBeige = LinearGradient(colors: [Color(hex: 0xE1DCD3), Color(hex: 0xF0EAE0)], startPoint: .top, endPoint: .bottom)
        
        
        static let clearSunrise = LinearGradient.ground.grassGreen
        static let clearMorning = LinearGradient.ground.grassGreen
        static let clearAfternoon = LinearGradient.ground.grassGreen
        static let clearSunset = LinearGradient.ground.grassGreen
        static let clearEvening = LinearGradient.ground.grassGreen
        static let clearNight = LinearGradient.ground.grassGreen
        
        static let cloudySunrise = LinearGradient.ground.dirtBrown
        static let cloudyMorning = LinearGradient.ground.dirtBrown
        static let cloudyAfternoon = LinearGradient.ground.dirtBrown
        static let cloudySunset = LinearGradient.ground.dirtBrown
        static let cloudyEvening = LinearGradient.ground.dirtBrown
        static let cloudyNight = LinearGradient.ground.dirtBrown
        
        static let rainySunrise = LinearGradient.ground.dirtBrown
        static let rainyMorning = LinearGradient.ground.dirtBrown
        static let rainyAfternoon = LinearGradient.ground.dirtBrown
        static let rainySunset = LinearGradient.ground.dirtBrown
        static let rainyEvening = LinearGradient.ground.dirtBrown
        static let rainyNight = LinearGradient.ground.dirtBrown
        
        static let snowySunrise = LinearGradient.ground.snowWhite
        static let snowyMorning = LinearGradient.ground.snowWhite
        static let snowyAfternoon = LinearGradient.ground.snowWhite
        static let snowySunset = LinearGradient.ground.snowWhite
        static let snowyEvening = LinearGradient.ground.snowWhite
        static let snowyNight = LinearGradient.ground.snowWhite
    }
}

extension Image {
    
    struct symbol {
        static let moon = Image(systemName: "moon.fill")
    }
    
    struct assets {
        static let apartment = Image("Apartment")
        
        struct buttons {
            static let calendarSelected = Image("Button_CalendarSelected")
            static let calendarUnSelected = Image("Button_CalendarUnselected")
            static let settingSelected = Image("Button_SettingSelected")
            static let settingUnSelected = Image("Button_SettingUnselected")
        }
        
        struct room {
            static let vacant = Image("Room_vacant")
            static let dark = Image("Room_dark")
            static let light = Image("Room_light")
            static let white = Image("Room_white")
            static let pink = Image("Room_pink")
            static let blind = Image("Room_blind")
            static let blindUp = Image("Room_blindUp")
            static let windowBorder = Image("Room_windowBorder")
        }
        
        struct stampLarge {
            static let clearSunrise = Image("StampLarge_clearDay")
            static let clearMorning = Image("StampLarge_clearDay")
            static let clearAfternoon = Image("StampLarge_clearDay")
            static let clearSunset = Image("StampLarge_clearNight")
            static let clearEvening = Image("StampLarge_clearNight")
            static let clearNight = Image("StampLarge_clearNight")
            
            static let cloudySunrise = Image("StampLarge_cloudyDay")
            static let cloudyMorning = Image("StampLarge_cloudyDay")
            static let cloudyAfternoon = Image("StampLarge_cloudyDay")
            static let cloudySunset = Image("StampLarge_cloudyNight")
            static let cloudyEvening = Image("StampLarge_cloudyNight")
            static let cloudyNight = Image("StampLarge_cloudyNight")
            
            static let rainySunrise = Image("StampLarge_rainyDay")
            static let rainyMorning = Image("StampLarge_rainyDay")
            static let rainyAfternoon = Image("StampLarge_rainyDay")
            static let rainySunset = Image("StampLarge_rainyNight")
            static let rainyEvening = Image("StampLarge_rainyNight")
            static let rainyNight = Image("StampLarge_rainyNight")
            
            static let snowySunrise = Image("StampLarge_snowyDay")
            static let snowyMorning = Image("StampLarge_snowyDay")
            static let snowyAfternoon = Image("StampLarge_snowyDay")
            static let snowySunset = Image("StampLarge_snowyNight")
            static let snowyEvening = Image("StampLarge_snowyNight")
            static let snowyNight = Image("StampLarge_snowyNight")
            
            static let wind = Image("StampLarge_wind")
            static let thunder = Image("StampLarge_thunder")
        }
        
        struct stampSmall {
            static let clearSunrise = Image("StampSmall_clearDay")
            static let clearMorning = Image("StampSmall_clearDay")
            static let clearAfternoon = Image("StampSmall_clearDay")
            static let clearSunset = Image("StampSmall_clearNight")
            static let clearEvening = Image("StampSmall_clearNight")
            static let clearNight = Image("StampSmall_clearNight")
            
            static let cloudySunrise = Image("StampSmall_cloudyDay")
            static let cloudyMorning = Image("StampSmall_cloudyDay")
            static let cloudyAfternoon = Image("StampSmall_cloudyDay")
            static let cloudySunset = Image("StampSmall_cloudyNight")
            static let cloudyEvening = Image("StampSmall_cloudyNight")
            static let cloudyNight = Image("StampSmall_cloudyNight")
            
            static let rainySunrise = Image("StampSmall_rainyDay")
            static let rainyMorning = Image("StampSmall_rainyDay")
            static let rainyAfternoon = Image("StampSmall_rainyDay")
            static let rainySunset = Image("StampSmall_rainyNight")
            static let rainyEvening = Image("StampSmall_rainyNight")
            static let rainyNight = Image("StampSmall_rainyNight")
            
            static let snowySunrise = Image("StampSmall_snowyDay")
            static let snowyMorning = Image("StampSmall_snowyDay")
            static let snowyAfternoon = Image("StampSmall_snowyDay")
            static let snowySunset = Image("StampSmall_snowyNight")
            static let snowyEvening = Image("StampSmall_snowyNight")
            static let snowyNight = Image("StampSmall_snowyNight")
            
            static let wind = Image("StampSmall_wind")
            static let thunder = Image("StampSmall_thunder")
        }
    }
}

struct Lottie {
    static let clearSunrise = String("clearD")
    static let clearMorning = String("clearD")
    static let clearAfternoon = String("clearD")
    static let clearSunset = String("clearN")
    static let clearEvening = String("clearN")
    static let clearNight = String("clearN")
    
    static let cloudySunrise = String("cloudyD")
    static let cloudyMorning = String("cloudyD")
    static let cloudyAfternoon = String("cloudyD")
    static let cloudySunset = String("cloudyN")
    static let cloudyEvening = String("cloudyN")
    static let cloudyNight = String("cloudyN")
    
    static let rainySunrise = String("rainyD")
    static let rainyMorning = String("rainyD")
    static let rainyAfternoon = String("rainyD")
    static let rainySunset = String("rainyN")
    static let rainyEvening = String("rainyN")
    static let rainyNight = String("rainyN")
    
    static let snowySunrise = String("snowyDN")
    static let snowyMorning = String("snowyDN")
    static let snowyAfternoon = String("snowyDN")
    static let snowySunset = String("snowyDN")
    static let snowyEvening = String("snowyDN")
    static let snowyNight = String("snowyDN")
    
    static let wind = String("WindDN")
    static let thunder = String("thunderDN")
}

extension Text {
    
    struct sounds {
        static let clear = "clear"
        static let cloudy = "cloudy"
        static let rainy = "rainy"
        static let snowy = "snowy"
        static let sunrise = "sunrise"
        static let sunset = "sunset"
        static let thunder = "thunder"
        static let windy = "windy"
        static let shutter = "focus_shutter"

    }
    struct broadcast{
        struct attendanceIncompleteTitle {
            static let clearSunrise = "일찍 일어나는 새가 피곤하다죠"
            static let clearMorning = "좋은 아침이에요 !"
            static let clearAfternoon = "기분 좋은 오후군요"
            static let clearSunset = "오늘의 일몰은 어땠나요?"
            static let clearEvening = "멋진 저녁이에요"
            static let clearNight = "고요고요한 밤이고요"
            
            static let cloudySunrise = "일찍 일어나는 새가 피곤하다죠"
            static let cloudyMorning = "좋은 아침이에요 !"
            static let cloudyAfternoon = "기분 좋은 오후군요"
            static let cloudySunset = "오늘의 일몰은 어땠나요?"
            static let cloudyEvening = "멋진 저녁이에요"
            static let cloudyNight = "고요고요한 밤이고요"
            
            static let rainySunrise = "일찍 일어나는 새가 피곤하다죠"
            static let rainyMorning = "좋은 아침이에요 !"
            static let rainyAfternoon = "기분 좋은 오후군요"
            static let rainySunset = "오늘의 일몰은 어땠나요?"
            static let rainyEvening = "멋진 저녁이에요"
            static let rainyNight = "고요고요한 밤이고요"
            
            static let snowySunrise = "일찍 일어나는 새가 피곤하다죠"
            static let snowyMorning = "좋은 아침이에요 !"
            static let snowyAfternoon = "기분 좋은 오후군요"
            static let snowySunset = "오늘의 일몰은 어땠나요?"
            static let snowyEvening = "멋진 저녁이에요"
            static let snowyNight = "고요고요한 밤이고요"
            
            static let wind = "바람이 세차게 부네요"
            static let thunder = "충격적인 날씨에요 !"
        }
        
        struct attendanceIncompleteBody {
            static let clearSunrise = "하루를 일찍 여는 당신을 응원해요!"
            static let clearMorning = "Bonjour, 早上好, おはよう,\ngood morning, buenos dias !"
            static let clearAfternoon = "이 기분 그대로 눈도장을 남겨볼까요?"
            static let clearSunset = "이 멋진 노을을 놓을 수 없어요 !"
            static let clearEvening = "우리의 저녁은 당신의 낮보다 아름답다는 말 아세요?"
            static let clearNight = "오지고요 지리고요 눈도장 남겨주고요"
            
            static let cloudySunrise = "하루를 일찍 여는 당신을 응원해요!"
            static let cloudyMorning = "Bonjour, 早上好, おはよう,\ngood morning, buenos dias !"
            static let cloudyAfternoon = "이 기분 그대로 눈도장을 남겨볼까요?"
            static let cloudySunset = "이 멋진 노을을 놓을 수 없어요 !"
            static let cloudyEvening = "우리의 저녁은 당신의 낮보다 아름답다는 말 아세요?"
            static let cloudyNight = "오지고요 지리고요 눈도장 남겨주고요"
            
            static let rainySunrise = "하루를 일찍 여는 당신을 응원해요!"
            static let rainyMorning = "Bonjour, 早上好, おはよう,\ngood morning, buenos dias !"
            static let rainyAfternoon = "이 기분 그대로 눈도장을 남겨볼까요?"
            static let rainySunset = "이 멋진 노을을 놓을 수 없어요 !"
            static let rainyEvening = "우리의 저녁은 당신의 낮보다 아름답다는 말 아세요?"
            static let rainyNight = "오지고요 지리고요 눈도장 남겨주고요"
            
            static let snowySunrise = "하루를 일찍 여는 당신을 응원해요!"
            static let snowyMorning = "Bonjour, 早上好, おはよう,\ngood morning, buenos dias !"
            static let snowyAfternoon = "이 기분 그대로 눈도장을 남겨볼까요?"
            static let snowySunset = "이 멋진 노을을 놓을 수 없어요 !"
            static let snowyEvening = "우리의 저녁은 당신의 낮보다 아름답다는 말 아세요?"
            static let snowyNight = "오지고요 지리고요 눈도장 남겨주고요"
            
            static let wind = "휩쓸려 날라가지 않게 조심하세요 !"
            static let thunder = "가끔은 이런 날도 있는 거죠, 괜찮아요"
        }
        
        struct attendanceCompletedTitle {
            static let clearSunrise = "커튼을 걷을 준비가 됐나요 ?"
            static let clearMorning = "커튼을 걷을 준비가 됐나요 ?"
            static let clearAfternoon = "커튼을 걷을 준비가 됐나요 ?"
            static let clearSunset = "커튼을 걷을 준비가 됐나요 ?"
            static let clearEvening = "커튼을 걷을 준비가 됐나요 ?"
            static let clearNight = "커튼을 걷을 준비가 됐나요 ?"
            
            static let cloudySunrise = "커튼을 걷을 준비가 됐나요 ?"
            static let cloudyMorning = "커튼을 걷을 준비가 됐나요 ?"
            static let cloudyAfternoon = "커튼을 걷을 준비가 됐나요 ?"
            static let cloudySunset = "커튼을 걷을 준비가 됐나요 ?"
            static let cloudyEvening = "커튼을 걷을 준비가 됐나요 ?"
            static let cloudyNight = "커튼을 걷을 준비가 됐나요 ?"
            
            static let rainySunrise = "커튼을 걷을 준비가 됐나요 ?"
            static let rainyMorning = "커튼을 걷을 준비가 됐나요 ?"
            static let rainyAfternoon = "커튼을 걷을 준비가 됐나요 ?"
            static let rainySunset = "커튼을 걷을 준비가 됐나요 ?"
            static let rainyEvening = "커튼을 걷을 준비가 됐나요 ?"
            static let rainyNight = "커튼을 걷을 준비가 됐나요 ?"
            
            static let snowySunrise = "커튼을 걷을 준비가 됐나요 ?"
            static let snowyMorning = "커튼을 걷을 준비가 됐나요 ?"
            static let snowyAfternoon = "커튼을 걷을 준비가 됐나요 ?"
            static let snowySunset = "커튼을 걷을 준비가 됐나요 ?"
            static let snowyEvening = "커튼을 걷을 준비가 됐나요 ?"
            static let snowyNight = "커튼을 걷을 준비가 됐나요 ?"
            
            static let wind = "커튼을 걷을 준비가 됐나요 ?"
            static let thunder = "커튼을 걷을 준비가 됐나요 ?"
        }
        
        struct attendanceCompletedBody {
            static let clearSunrise = "맑은 하늘을 기대해도 좋아요"
            static let clearMorning = "맑은 하늘을 기대해도 좋아요"
            static let clearAfternoon = "맑은 하늘을 기대해도 좋아요"
            static let clearSunset = "눈.모.아 이웃들도 오늘 하늘을 봤겠죠?"
            static let clearEvening = "눈.모.아 이웃들도 오늘 하늘을 봤겠죠?"
            static let clearNight = "눈.모.아 이웃들도 오늘 하늘을 봤겠죠?"
            
            static let cloudySunrise = "구름 뒤엔 해가 떠오르고 있을 거예요"
            static let cloudyMorning = "구름 뒤엔 해가 떠오르고 있을 거예요"
            static let cloudyAfternoon = "구름 뒤엔 해가 떠오르고 있을 거예요"
            static let cloudySunset = "흐린 날엔 사진이 더 잘 나오는 법이죠"
            static let cloudyEvening = "흐린 날엔 사진이 더 잘 나오는 법이죠"
            static let cloudyNight = "흐린 날엔 사진이 더 잘 나오는 법이죠"
            
            static let rainySunrise = "빗소리로 하루를 시작하는 건 참 멋져요"
            static let rainyMorning = "빗소리로 하루를 시작하는 건 참 멋져요"
            static let rainyAfternoon = "빗소리로 하루를 시작하는 건 참 멋져요"
            static let rainySunset = "비가 내리고 음악이 흐르면\n이웃들은 당신을 생각해요"
            static let rainyEvening = "비가 내리고 음악이 흐르면\n이웃들은 당신을 생각해요"
            static let rainyNight = "비가 내리고 음악이 흐르면\n이웃들은 당신을 생각해요"
            
            static let snowySunrise = "창밖엔 새하얀 눈이 내리고 있어요.\n눈.모.아에도 눈이 내려요"
            static let snowyMorning = "창밖엔 새하얀 눈이 내리고 있어요.\n눈.모.아에도 눈이 내려요"
            static let snowyAfternoon = "창밖엔 새하얀 눈이 내리고 있어요.\n눈.모.아에도 눈이 내려요"
            static let snowySunset = "눈 내리는 눈.모.아를 보러 가볼까요?"
            static let snowyEvening = "눈 내리는 눈.모.아를 보러 가볼까요?"
            static let snowyNight = "눈 내리는 눈.모.아를 보러 가볼까요?"
            
            static let wind = "바람에 날라가지 않게 조심해요!"
            static let thunder = "무시무시한 날씨지만 스릴 있어요"
        }
        
        static let announce = ["아,아 관리사무소에서 안내말씀 드리겠습니다.\n우리 아파트에서는 층간소음을 장려합니다.\n이웃분들을 열심히 깨워주시기 바랍니다",
                               "아,아 관리사무소에서 안내말씀 드리겠습니다.\n반가운 이웃들 간에 눈 인사로 안부를 묻는\n눈모아 아파트의 문화를 함께 만듭시다",
                               "아,아 관리사무소에서 안내말씀 드리겠습니다.\n저희 눈모아 아파트는 분리수거 지정일이\n없습니다. 언제든 내다 버리시기 바랍니다",
                               "아,아 관리사무소에서 안내말씀 드리겠습니다.\n건강한 눈모아 입주민이 되기 위해\n창문을 활짝 열어 방을 환기 시켜주시기 바랍니다",
                               "아,아 관리사무소에서 안내말씀 드리겠습니다.\n아파트 내 활발한 교류를 위해 이웃집을\n마구마구 두드려주시길 바랍니다",
                               "아,아 관리사무소에서 안내말씀 드리겠습니다.\n청결한 눈모아 아파트를 위해 각 세대에서는\n방청소에 신경 써주시길 바랍니다"]
    }
}

    
