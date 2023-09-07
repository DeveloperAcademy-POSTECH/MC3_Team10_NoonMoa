//
//  SceneApt.swift
//  MC3
//
//  Created by 최민규 on 2023/07/15.
//

import SwiftUI

struct SceneApt: View {
    @Binding var isGateOpen: Bool
    var body: some View {
        
        Image.assets.apartment
            .resizable()
            .scaledToFit()
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.black, lineWidth: 2)
            )
            .clipShape(
                RoundedRectangle(cornerRadius: 8)
            )
            .overlay (
                GeometryReader { geo in
                    Image.assets.apt.aptGate
                        .resizable()
                        .scaledToFit()
                        .overlay(
                            Rectangle()
                                .roundedCornerStroke(8, corners: [.topLeft, .topRight])
                        )
                        .overlay(
                            Rectangle()
                                .roundedCorner(8, corners: [.topLeft])
                                .frame(width: geo.size.width * 0.21)
                                .offset(x: -geo.size.width * 0.095)
                                .foregroundColor(.white.opacity(0.2))
                                .overlay(
                                    Rectangle()
                                        .roundedCornerStroke(8, corners: [.topLeft])
                                        .frame(width: geo.size.width * 0.21)
                                        .offset(x: -geo.size.width * 0.095)
                                )
                        )
                        .overlay(
                            Rectangle()
                                .roundedCorner(8, corners: [.topRight])
                                .frame(width: geo.size.width * 0.21)
                                .offset(x: geo.size.width * 0.095)
                                .offset(x: -geo.size.width * 0.17 * (isGateOpen ? 1 : 0))
                                .foregroundColor(.white.opacity(0.2))
                                .overlay(
                            Rectangle()
                                .roundedCornerStroke(8, corners: [.topRight])
                                .frame(width: geo.size.width * 0.21)
                                .offset(x: geo.size.width * 0.095)
                                .offset(x: -geo.size.width * 0.17 * (isGateOpen ? 1 : 0))
                            )
                        )
                        .frame(width: geo.size.width * 0.4)
                        .offset(x: geo.size.width / 2 - geo.size.width * 0.2)
                        .offset(y: geo.size.height - geo.size.width * 0.4 * 0.6)
                }
            )
    }
}

struct SceneApt_Previews: PreviewProvider {
    static var previews: some View {
        SceneApt(isGateOpen: .constant(false))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func roundedCorner(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
    func roundedCornerStroke(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners).stroke(lineWidth: 2))
    }
}
