//
//  HomePersonalView.swift
//  docRelay
//
//  Created by Глеб Завьялов on 02.05.2020.
//  Copyright © 2020 Глеб Завьялов. All rights reserved.
//

import SwiftUI

struct HomePersonalView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("You").navigationBarTitle("Personal")
                Spacer()
            }
        }
    }
    
}

struct HomePersonalView_Previews: PreviewProvider {
    static var previews: some View {
        HomePersonalView()
    }
}
