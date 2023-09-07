//
//  ViewRouter.swift
//  MangMongApt
//
//  Created by kimpepe on 2023/07/15.
//

import Foundation
import SwiftUI

enum ViewState {
    case launchScreen
    case onBoarding
    case login
    case nickname
    case attendance
    case attendanceCompleted
    case apt
    case CalendarFull
    case CalendarSingle
}

class ViewRouter: ObservableObject {
    @Published var currentView: ViewState = .launchScreen
    var nextView: ViewState = .launchScreen {
        didSet {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                self.currentView = self.nextView
            }
        }
    }
}
