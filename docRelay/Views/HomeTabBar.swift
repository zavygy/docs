//
//  HomeTabBar.swift
//  docRelay
//
//  Created by Глеб Завьялов on 02.05.2020.
//  Copyright © 2020 Глеб Завьялов. All rights reserved.
//

import SwiftUI

struct HomeTabBar: View {
    @Binding var pageIndex: Int
    @Binding var addPopOverShow: Bool
    var body: some View {
        HStack {
            Spacer()
            Button (action: {
                self.pageIndex = 0
                withAnimation {
                    self.addPopOverShow = false
                }
            }) {
                Image("Home").resizable().frame(width: 20, height: 20)
            }.foregroundColor(Color.black.opacity(pageIndex == 0 ? 1 : 0.2))
            
            Spacer(minLength: 0)
            
            Button(action: {
                withAnimation {
                    self.addPopOverShow.toggle()
                }
            }) {
                Image(systemName: "plus").resizable().frame(width: 20, height:
                    20).padding()
                .foregroundColor(.white)
                .background(Color.red)
                .clipShape(Circle())
            }
                .shadow(color: Color.black.opacity(0.2), radius: 5)
//                .buttonStyle(AddButtonMofifier())
                
            
            Spacer(minLength: 0)

                
            Button (action: {
                self.pageIndex = 1
                withAnimation {
                    self.addPopOverShow = false
                }
            }) {
                Image("Profile").resizable().frame(width: 20, height: 20)
            }.foregroundColor(Color.black.opacity(pageIndex == 1 ? 1 : 0.2))
            
            Spacer()
        }.padding(.horizontal, 35)
        .background(Color.white)
    }
}
