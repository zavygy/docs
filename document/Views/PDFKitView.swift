//
//  PDFKitView.swift
//  documents
//
//  Created by Глеб Завьялов on 17.08.2020.
//

import SwiftUI
import PDFKit

struct PDFKitView: UIViewRepresentable {
    var url: URL = URL(string: "")!
    var pdfView: PDFView = PDFView()
    @Binding var pdfSelection: PDFSelection?
    
    func makeUIView(context: Context) -> UIView {
        DispatchQueue.main.async {
            loadUrl()
        }
        addObservers()
        pdfView.delegate = nil
        return pdfView
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
    
    func addObservers() {
        if (pdfView.observationInfo != nil) {
            NotificationCenter.default.removeObserver(pdfView)
        }
        
        NotificationCenter.default.addObserver(forName: .PDFViewSelectionChanged, object: pdfView, queue: nil, using: self.selectionChanged)
    }
    
    func selectionChanged(_ notification: Notification) {
        pdfSelection = pdfView.currentSelection
    }
    
    func loadUrl() {
        pdfView.document = PDFDocument(url: self.url)
    }
    
    func getSelected() -> PDFSelection? {
        return pdfView.currentSelection
    }
}
