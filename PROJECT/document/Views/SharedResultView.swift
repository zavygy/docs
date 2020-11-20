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
            HStack {
                Text(documentTitle)
                    .foregroundColor(.primary)
                    .font(.title)
                    .bold()
                
                    
                Spacer()
            }.padding(.top, 40)
            .padding(.horizontal, 24)
            HStack {
                Text(docId)
                    .foregroundColor(.secondary)
                    .font(.subheadline)
                Spacer()
            }.padding(.horizontal, 24)
            Image(uiImage: generateQRCode(from: docId) ?? UIImage())
                .interpolation(.none)
                .resizable()
                .scaledToFit()
                .clipped()
                .padding()
            
            Spacer()
            
            Button(action: {
                pasteboard.string = docId

            }) {
                HStack {
                    Spacer()
                    Text("Copy")
                        .font(.headline)
                        .foregroundColor(.black)
                        .padding()
                    Spacer()
                }
            }
            .clipped()
            .background(Color(r: 240, g: 240, b: 240))
            .cornerRadius(8)
            .padding(.horizontal, 24)
            .padding(.bottom, 20)
            
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
