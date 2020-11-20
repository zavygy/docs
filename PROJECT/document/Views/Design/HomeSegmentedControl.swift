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
                        .foregroundColor(myCreatedState == true ? .primary : Color(r: 183, g: 183, b: 183))
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
                        .foregroundColor(myCreatedState == true ? Color(r: 183, g: 183, b: 183) : .primary)
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

struct CompleteDocumentSegmentedControl: View {
    @Binding var myCreatedState: Int
    var body: some View {
        HStack {
            Button(action: {

                withAnimation {
                    DispatchQueue.main.async {
                        myCreatedState = 0
                    }
                }
            
            }) {
               
                    Text("Fields")
                        .foregroundColor(myCreatedState == 0 ? .primary : Color(r: 183, g: 183, b: 183))
                        .font(.headline)
                        .bold()
                        .padding(.vertical, 6)
            }.clipped()
//            .background(myCreatedState == true ? Color.black : Color(r: 247, g: 247, b: 247))
            .cornerRadius(4)
//            .padding(.trailing, 4)
            
            
            Button(action: {
                
                withAnimation {
                    DispatchQueue.main.async {
                        myCreatedState = 1
                    }
                }
            
            }) {
                HStack {
                    Text("Document")
                        .foregroundColor(myCreatedState == 0 ? Color(r: 183, g: 183, b: 183) : .primary)
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



struct PersDataSegmentedControl: View {
    @Binding var myCreatedState: Bool
    var body: some View {
        HStack {
            Button(action: {
                withAnimation {
                    myCreatedState = true
                }
            }) {
               
                    Text("Data")
                        .foregroundColor(myCreatedState == true ? .primary : Color(r: 183, g: 183, b: 183))
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
                    Text("Add")
                        .foregroundColor(myCreatedState == true ? Color(r: 183, g: 183, b: 183) : .primary)
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
