//
//  DocumentListItem.swift
//  documents
//
//  Created by Глеб Завьялов on 29.08.2020.
//

import SwiftUI

struct DocumentListItem: View {
    @ObservedObject var documentModel: DocumentModel
    var body: some View {
        HStack {
            VStack {
                Text(documentModel.name)
                    .foregroundColor(.primary)
            }
            Spacer()
//            Text(documentModel.id)
//                .foregroundColor(.secondary)
        }
    }
}

struct DocumentListItem_Previews: PreviewProvider {
    static var previews: some View {
        DocumentListItem(documentModel: DocumentModel(id: "001", name: "License", pdfData: Data()))
    }
}
