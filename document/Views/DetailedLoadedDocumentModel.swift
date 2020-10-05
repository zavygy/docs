//
//  DetailedLoadedDocumentModel.swift
//  document
//
//  Created by Глеб Завьялов on 03.10.2020.
//

import SwiftUI

struct DetailedLoadedDocumentModel: View {
    @ObservedObject var globalEnviroment: GlobalEnviroment
    @ObservedObject var document: DocumentModel
    @State var fillWith: String = ""
    var body: some View {
        VStack {
            HStack {
                Text("Fields").font(.title).padding(.horizontal)
                Spacer()
            }
            List {
                ForEach(document.fieldsToFill) { field in
                    HStack {
                        VStack {
                            HStack {
                                Text(field.description).font(.subheadline).foregroundColor(.secondary)
                                Spacer()
                            }
                            TextField("Input", text: $fillWith).foregroundColor(.primary)
                        }
                    }.padding()
                }
            }
        }.navigationBarTitle(document.name)
    }
}

//struct DetailedLoadedDocumentModel_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailedLoadedDocumentModel()
//    }
//}
