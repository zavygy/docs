//
//  SharedResultView.swift
//  document
//
//  Created by Глеб Завьялов on 01.10.2020.
//

import SwiftUI
import CoreImage.CIFilterBuiltins


struct SharedResultView: View {
    let docId: String
    let documentTitle: String
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    let pasteboard = UIPasteboard.general
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Text(documentTitle)
                    .foregroundColor(.primary).font(.headline)
                    
                Spacer()
            }
            HStack {
                Spacer()
                Text(docId)
                    .foregroundColor(.secondary)
                    .font(.subheadline)
                Spacer()
            }.padding()
            Image(uiImage: generateQRCode(from: docId) ?? UIImage())
                .interpolation(.none)
                .resizable()
                .scaledToFit()
                .clipped()
                .padding()
            Button(action: {
                pasteboard.string = docId
            }) {
                Text("Скопировать")
                    .font(.title2)
                    .foregroundColor(.accentColor)
            }
            Spacer()
        }
    }
    
    func generateQRCode(from string: String) -> UIImage {
        let data = Data(string.utf8)
        filter.setValue(data, forKey: "inputMessage")

        if let outputImage = filter.outputImage {
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgimg)
            }
        }

        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }

}

struct SharedResultView_Previews: PreviewProvider {
    static var previews: some View {
        SharedResultView(docId: "ididid", documentTitle: "Title")
    }
}
