//
//  AddButtonPopOver.swift
//  docRelay
//
//  Created by Глеб Завьялов on 03.05.2020.
//  Copyright © 2020 Глеб Завьялов. All rights reserved.
//

import SwiftUI

struct AddButtonPopOver: View {
    @Binding var isPresentedCreateView: Bool
    @Binding var isPresentedPopOver: Bool
    
    var body: some View {
        VStack (alignment: .leading, spacing: 18) {
            Button (action: {
                //create
                self.isPresentedCreateView = true
                self.isPresentedPopOver = false
            }) {
                HStack(spacing: 15) {
                    Image(systemName: "scribble").frame(width: 20, height: 22).foregroundColor(Color.black)
                        
                    Text("Create")
                        .foregroundColor(.black)
                        
                }
            }
            
            Divider()
            
            Button (action: {
                //load
                self.isPresentedPopOver = false
            }) {
                HStack(spacing: 15) {
                    Image(systemName: "square.and.arrow.down").frame(width: 20, height: 22).foregroundColor(Color.black)
                        
                    Text("Load").foregroundColor(.black)
                }
            }
        }
        .frame(width: 120)
        .padding()
            .background(Color.white)
        .cornerRadius(7)
        .clipped()
    }
}

//struct AddButtonPopOver_Previews: PreviewProvider {
//    static var previews: some View {
//        AddButtonPopOver(loadedData: [])
//    }
//}
