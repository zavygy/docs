//
//  DocumentFillingView.swift
//  docRelay
//
//  Created by Глеб Завьялов on 02.05.2020.
//  Copyright © 2020 Глеб Завьялов. All rights reserved.
//

import SwiftUI

struct DocumentFillingView: View {
    @ObservedObject var documentModel: DocumentModel
    @State var fillingViewPageSwitcher: Int = 0
    
//    init(documentModel: DocumentModel) {
//        self.documentModel = documentModel
//    }
    
    var body: some View {
        VStack {
            
            HStack {
                Picker("", selection: $fillingViewPageSwitcher) {
                    withAnimation {
                        Text("Info").tag(0)
                    }
                    withAnimation {
                        Text("Document").tag(1)
                    }
                }.pickerStyle(SegmentedPickerStyle())
            }.padding(.horizontal, 40)
                .padding(.top, 20)
                .navigationBarTitle("", displayMode: .inline)
            
                
            
            if (fillingViewPageSwitcher == 0) {
                List {
                    TextField("Title", text: $documentModel.title)
                        .padding()
                        .foregroundColor(.primary)
                        .lineLimit(2)
                    TextField("Document url", text: $documentModel.docUrl)
                        .padding()
                        .foregroundColor(.secondary)
                        .font(.subheadline)
                }
            } else {
                Webview(url: documentModel.docUrl)
            }
        }
    }
}
//
