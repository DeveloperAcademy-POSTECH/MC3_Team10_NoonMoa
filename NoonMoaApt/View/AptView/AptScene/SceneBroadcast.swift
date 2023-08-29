//
//  SceneBroadcast.swift
//  NoonMoaApt
//
//  Created by 최민규 on 2023/07/31.
//

import SwiftUI

struct SceneBroadcast: View {
    @EnvironmentObject var environmentViewModel: EnvironmentViewModel
    
    //글자 타이핑 이펙트
    @State private var displayedText: String = ""
    @State private var fullText: String = ""
    let typingInterval = 0.15
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Spacer().frame(height: 56)
                Text(displayedText)
                    .foregroundColor(
                        environmentViewModel.environmentRecordViewData.time == "sunrise" ||
                        environmentViewModel.environmentRecordViewData.time == "morning" ||
                        environmentViewModel.environmentRecordViewData.time == "afternoon" ?
                        .announcementGray :
                        .white)
                    .opacity(1.0)
                    .font(.body)
                    .bold()
                    .shadow(color: .white.opacity(1), radius: 4, x: 0, y: 0)
                Spacer()
            }
            Spacer()
        }
        .padding(.horizontal, 32)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                displayedText = ""
                fullText = environmentViewModel.environmentRecordViewData.broadcastAnnounce
                startTyping()
            }
        }
        .onChange(of: displayedText) { _ in
            if displayedText.count == fullText.count {
                withAnimation(.easeInOut(duration: 2).delay(2)) {
                    displayedText = ""
                }
            }
        }
    }
    
    private func startTyping() {
        var currentIndex = 0
        let timer = Timer.scheduledTimer(withTimeInterval: typingInterval, repeats: true) { timer in
            if currentIndex < fullText.count {
                let index = fullText.index(fullText.startIndex, offsetBy: currentIndex)
                displayedText += String(fullText[index])
                currentIndex += 1
            } else {
                timer.invalidate()
            }
        }
        timer.fire()
    }
}

struct SceneBroadcast_Previews: PreviewProvider {
    static var previews: some View {
        SceneBroadcast().environmentObject(EnvironmentViewModel())
    }
}
