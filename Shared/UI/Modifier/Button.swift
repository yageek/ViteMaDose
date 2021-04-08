//
//  Button.swift
//  ViteMaDose (iOS)
//
//  Created by Yannick Heinrich on 07.04.21.
//

import SwiftUI

struct ButtonText: ViewModifier {
    let fontSize: CGFloat

    func body(content: Content) -> some View {
        content.font(.system(size: self.fontSize))
    }
}

struct DefaultButton: ButtonStyle {

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(14.0)
            .background(configuration.isPressed ? Color("button-hover") :  Color("button-default"))
            .foregroundColor(.white)
            .cornerRadius(7.0)
    }
    
}
