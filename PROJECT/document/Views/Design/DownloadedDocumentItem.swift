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
                Text(documentModel.id)
                    .lineLimit(1)
                    .font(.footnote)
                    .accentColor(.primary)
//                    .bold()
//                    .italic()
                Spacer()
            }.padding(.horizontal, 16)
            .padding(.top, 16)
            HStack {
                Text(documentModel.name)
                    .font(.headline)
                    .bold()
                    .accentColor(.primary)

                Spacer()
            }.padding(.horizontal, 16)
            .padding(.top, 10)
            HStack {
                Text("\(documentModel.fieldsToFill.count) fields")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                Spacer()
                
                Button(action: onDelete) {
                    Image(systemName: "trash")
                        .foregroundColor(.primary)
                }
            }.padding(.horizontal, 16)
            .padding(.top, 10)
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
