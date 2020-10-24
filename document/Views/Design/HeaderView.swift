//
//  HeaderView.swift
//  document
//
//  Created by Глеб Завьялов on 23.10.2020.
//

import SwiftUI

struct HeaderView: View {
    @State var documentId: String = ""
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text("Download document")
                        .font(.headline)
                        .padding(.leading, 24)
                        .padding(.top, 40)
                    Spacer()
                }
                
                VStack {
                    HStack {
                        Text("Enter document id or scan QR")
                            .font(.footnote)
                        Spacer()
                    }
                    HStack {
                        TextField("document id", text: $documentId)
                            .font(.body)
                            .frame(height: 49)
                            .background(Color.white)
                            .padding(.trailing, 8)
                            .cornerRadius(4)
                        
                        Button(action: {}) {
                            Image(systemName: "qrcode")
//                                .frame(width: 24, height: 24)
                                .resizable()
                                .padding(13)
                                .accentColor(.black)
                        }.frame(width: 49, height: 49)
                        .background(Color.white)
                        .clipped()
                        .cornerRadius(4)
                    }.frame(height: 49)
                    .padding(.top, 8)
                }.padding(.top, 87)
                .padding(.horizontal, 24)
                
                Button(action: {}) {
                    HStack {
                        Spacer()
                        Text("Download")
                            .font(.subheadline)
                            .accentColor(.white)
                            .padding(.vertical, 13)
                        Spacer()
                        
                    }
                    
                }.clipped()
                .background(Color(r: 17, g: 17, b: 17))
                .cornerRadius(4)
                .padding(.horizontal, 24)
                .padding(.top, 32)
               
               
                Spacer()
            }.background(Color(r: 255, g: 206, b: 0))
//            Rectangle()
        }
    }
}

extension Color {
    init? (r: Double, g: Double, b: Double) {
        self.init(red: r / 256, green: g / 256, blue: b / 256)
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView()
    }
}
