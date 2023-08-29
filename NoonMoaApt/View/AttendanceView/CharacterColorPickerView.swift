//
//  CharacterColorPickerView.swift
//  NoonMoaApt
//
//  Created by 최민규 on 2023/08/01.
//

import SwiftUI

struct CharacterColorPickerView: View {
    @EnvironmentObject var characterViewModel: CharacterViewModel
    @State private var colorPickerSize: CGFloat = 16 //누르면 커지는 효과 16고정
    @State private var colorPickerOpacity: Bool = false //누르면 커지는 밝아지는 효과
    
    var body: some View {
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    LinearGradient(gradient: Gradient(colors: [characterViewModel.color1, characterViewModel.color2, characterViewModel.color3, characterViewModel.color4]), startPoint: .leading, endPoint: .trailing)
                        .frame(width: geometry.size.width, height: 48 - colorPickerSize)
                        .cornerRadius(16)
                        .opacity(colorPickerOpacity ? 1 : 0.7)
                        .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 3)
                        .overlay {
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.black.opacity(1), lineWidth: 2)
                        }
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.black.opacity(0.8), lineWidth: 3)
                            .frame(width: 24, height: 40 - colorPickerSize)
                            .shadow(color: .black.opacity(0.4), radius: 4, x: 0, y: 3)
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.black.opacity(0.4), lineWidth: 2)
                            .frame(width: 16, height: 32 - colorPickerSize)
                        
                    }
                    .opacity(colorPickerOpacity ? 1 : 0.7)
                    .offset(x: geometry.size.width * 0.05 + (CGFloat(characterViewModel.pickerValue) * geometry.size.width) * 0.9 - 12)
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { gesture in
                                updateValue(with: gesture, in: geometry)
                                characterViewModel.pickerValueToCharacterColor(value: characterViewModel.pickerValue)
                                print(characterViewModel.pickerValue)
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    colorPickerSize = 0
                                    colorPickerOpacity = true
                                }
                            }
                            .onEnded { gesture in
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    colorPickerSize = 16
                                    colorPickerOpacity = false
                                }
                            }
                    )
                }//ZStack
                .offset(y: -8 + (colorPickerSize / 2))

            }//GeometryReader
    }
    func updateValue(with gesture: DragGesture.Value, in geometry: GeometryProxy) {
        let newValue = gesture.location.x / geometry.size.width
        characterViewModel.pickerValue = min(max(Double(newValue), 0), 1)
    }
}

struct CharacterColorPickerView_Previews: PreviewProvider {
    static var previews: some View {
        CharacterColorPickerView()
    }
}
