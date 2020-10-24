//
//  HomeSegmentedControl.swift
//  document
//
//  Created by Глеб Завьялов on 24.10.2020.
//

import SwiftUI

struct HomeSegmentedControl: View {
    @Binding var myCreatedState: Bool
    var body: some View {
        HStack {
            Button(action: {
                withAnimation {
                    myCreatedState = true
                }
            }) {
               
                    Text("Downloaded")
                        .foregroundColor(myCreatedState == true ? .black : Color(r: 183, g: 183, b: 183))
                        .font(.headline)
                        .bold()
                        .padding(.vertical, 6)
            }.clipped()
//            .background(myCreatedState == true ? Color.black : Color(r: 247, g: 247, b: 247))
            .cornerRadius(4)
//            .padding(.trailing, 4)
            
            
            Button(action: {
                withAnimation {
                    myCreatedState = false
                }
            }) {
                HStack {
                    Text("Created")
                        .foregroundColor(myCreatedState == true ? Color(r: 183, g: 183, b: 183) : .black)
                        .font(.headline)
                        .bold()
                        .padding(.vertical, 6)
                }
            }.clipped()
//            .background(myCreatedState == true ? Color(r: 247, g: 247, b: 247) : Color.black)
            .cornerRadius(4)
//            .padding(.leading, 4)
           
            
            
        }
    }
}

//struct HomeSegmentedControl_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeSegmentedControl()
//    }
//}
