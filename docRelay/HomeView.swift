//
//  ContentView.swift
//  docRelay
//
//  Created by Глеб Завьялов on 30.04.2020.
//  Copyright © 2020 Глеб Завьялов. All rights reserved.
//

import SwiftUI


struct HomeView: View {
    @EnvironmentObject var dataEnviroment: DocRelayDataEnviroment
   
    @State private var globalPageNow: Int = 0
    @State var addPopOverShow: Bool = false
    @State var isPresentedCreateView: Bool = false
    
    var body: some View {
        VStack {
            ZStack {
                VStack {
                    if (globalPageNow == 0) {
                        HomeDocumentsView()
                            .environmentObject(dataEnviroment)
                    } else {
                        HomePersonalView()
                    }
                }.sheet(isPresented: $isPresentedCreateView) {
                    CreateDocumentView(isPresented: self.$isPresentedCreateView, createdData: self.$dataEnviroment.createdDocuments)
                }
                 
                if (addPopOverShow == true) {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            AddButtonPopOver(isPresentedCreateView: $isPresentedCreateView, isPresentedPopOver: $addPopOverShow)
                                .shadow(color: Color.black.opacity(0.2), radius: 5)
                            Spacer()
                        }.padding(.bottom, 10)
                    }
                }
                    
            }
                
            HomeTabBar(pageIndex: $globalPageNow, addPopOverShow: $addPopOverShow)
                .edgesIgnoringSafeArea(.bottom)
                
                
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environmentObject(DocRelayDataEnviroment())
    }
}
