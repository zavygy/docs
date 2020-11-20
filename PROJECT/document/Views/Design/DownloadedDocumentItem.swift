//
//  DownloadedDocumentItem.swift
//  document
//
//  Created by Глеб Завьялов on 23.10.2020.
//

import SwiftUI

struct DownloadedDocumentItem: View {
    let documentModel: DocumentModel
    let onDelete: () -> ()
    var body: some View {
        VStack {
            
            HStack {
                Text(documentModel.name)
                    .fontWeight(.medium)
                    .bold()
                    .accentColor(.primary)

                Spacer()
            }.padding(.horizontal, 16)
            .padding(.top, 16)
            HStack {
                VStack {
                    Text("\(documentModel.fieldsToFill.count) fields")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
                }
                Spacer()
                
                Button(action: onDelete) {
                    Image(systemName: "trash")
                        .accentColor(.primary)
                }
            }.padding(.horizontal, 16)
            .padding(.top, 4)
            .padding(.bottom, 15)
            
            
        }
    }
}

struct DownloadedDocumentItem_Previews: PreviewProvider {
    static var previews: some View {
        DownloadedDocumentItem(documentModel: DocumentModel(id: "111", name: "Согласие", url: "iiii"), onDelete: {
            print("uuuu")
        })
    }
}
