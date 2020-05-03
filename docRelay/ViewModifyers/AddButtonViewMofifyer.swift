//
//  AddButtonViewMofifyer.swift
//  docRelay
//
//  Created by Глеб Завьялов on 03.05.2020.
//  Copyright © 2020 Глеб Завьялов. All rights reserved.
//

import SwiftUI

struct AddButtonMofifier : ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .shadow(color: Color.black.opacity(configuration.isPressed ? 0.15 : 0.3), radius: 5)
            
    }
}
