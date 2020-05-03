//
//  HomeDocumentsView.swift
//  docRelay
//
//  Created by Глеб Завьялов on 02.05.2020.
//  Copyright © 2020 Глеб Завьялов. All rights reserved.
//

import SwiftUI

struct HomeDocumentsView: View {
    @State private var pageUsing: Int = 0
    @EnvironmentObject var dataEnviroment: DocRelayDataEnviroment

    var body: some View {
        NavigationView {
            VStack{
                 HStack {
                     Picker("", selection: $pageUsing) {
//                        withAnimation {
                         Text("Loaded").tag(0)
//                        }
//                        withAnimation {
                         Text("Created").tag(1)
//                        }
                     }.pickerStyle(SegmentedPickerStyle())
                         .padding(.horizontal, 40)
                 }
                 List (pageUsing == 0 ? dataEnviroment.loadedDocuments :            dataEnviroment.createdDocuments) { document in
                    NavigationLink (destination: DocumentFillingView(documentModel: document)) {
                         DocumentModelCell(documentModel: document)
                            
                     }
                 }.navigationBarTitle("Documents")
                   
            }
        }.onAppear {
//            UINavigationBar.appearance().isTranslucent = false
            UINavigationBar.appearance().barTintColor = .white
        }
        
    }
}

struct HomeDocumentsView_Previews: PreviewProvider {
    static var previews: some View {
        HomeDocumentsView()
    }
}
