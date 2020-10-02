//
//  DocumentPicker.swift
//  document
//
//  Created by Глеб Завьялов on 01.10.2020.
//

import SwiftUI
import MobileCoreServices
import Firebase

struct DocumentPicker: UIViewControllerRepresentable {
    let documentName: String
    @Binding var url: String
    func makeCoordinator() -> DocumentPicker.Coordinator {
        return DocumentPicker.Coordinator(parent1: self, documentName: documentName)
    }
    
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<DocumentPicker>) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF)], in: .open)
        picker.allowsMultipleSelection = false
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: UIViewControllerRepresentableContext<DocumentPicker>) {
        
    }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var parent: DocumentPicker
        let documentName: String
        init(parent1: DocumentPicker, documentName: String) {
            self.parent = parent1
            self.documentName = documentName
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            let storage = Storage.storage().reference()
            

            guard urls.first!.startAccessingSecurityScopedResource() else { return }
            
            let data = loadFileFromLocalPath(urls.first!)!
            
            let pathName: String = "\(documentName).pdf"
            
            storage.child(pathName).putData(data, metadata: nil) {
                (_, err) in
                if (err != nil) {
                    print((err?.localizedDescription)!)
                    return
                }
                print("successfully uploaded")
                storage.child(pathName).downloadURL(completion: {
                    (url, err) in
                    self.parent.url = String(describing: url!)
                })
            }
//            print(urls)
        }
        
        func loadFileFromLocalPath(_ localFilePath: URL) ->Data? {
           return try? Data(contentsOf: localFilePath)
        }
    }
}

