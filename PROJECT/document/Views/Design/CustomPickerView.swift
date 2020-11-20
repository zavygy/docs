//
//  SwiftUIView.swift
//  document
//
//  Created by Глеб Завьялов on 19.11.2020.
//

import SwiftUI

struct CustomPickerView: View {
    @Binding var selected: Int
    @State var fields: [String]
    var body: some View {
        
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                    ForEach(0 ..< fields.count) { i in
                        Button(action: {
                            DispatchQueue.main.async {
                                withAnimation {
                                    selected = i
                                }
                            }
                        }, label: {
                            Text("\(fields[i])")
//                                .fontWeight(.medium)
                                .lineLimit(1)
                                .foregroundColor(Color.primary)
                                .padding(.horizontal)
                                .padding(.vertical, 8)
                        })
                        .background(selected == i ? appColorFirst : Color(UIColor.secondarySystemBackground))
                        .cornerRadius(8)
                        .padding(.leading, i == 0 ? 24 : 2)
                        .padding(.trailing, i == fields.count - 1 ? 24 : 2)

                    }
            }
                
        }
    }
    
}

//struct CustomPickerView_Previews: PreviewProvider {
//    @State var sel: Int = 0
//    static var previews: some View {
//        CustomPickerView(selected: $sel, fields: ["hello", "world"])
//    }
//}
