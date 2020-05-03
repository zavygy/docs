//
//  DocumentModelCell.swift
//  docRelay
//
//  Created by Глеб Завьялов on 01.05.2020.
//  Copyright © 2020 Глеб Завьялов. All rights reserved.
//

import SwiftUI

struct DocumentModelCell: View {
    @ObservedObject var documentModel: DocumentModel
    var body: some View {
        VStack {
            HStack {
                Text(documentModel.title)
                    .font(.callout)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                    .padding()
                Spacer()
                Text(documentModel.docUrl)
                    .font(.caption)
                    .lineLimit(1)
                    .foregroundColor(.secondary)
                    .padding()
                
            }
        }
    }
}

struct DocumentModelCell_Previews: PreviewProvider {
    static var previews: some View {
        DocumentModelCell(documentModel: DocumentModel("Title", [], url: "apple.com"))
    }
}
