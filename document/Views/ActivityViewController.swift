//
//  ActivityViewController.swift
//  document
//
//  Created by Глеб Завьялов on 23.10.2020.
//

import UIKit
import SwiftUI

class ActivityViewController : UIViewController {

    var data:Data!
    var completionWithItemsHandler: UIActivityViewController.CompletionWithItemsHandler? = nil

    
    override func viewDidAppear(_ animated: Bool) {
        shareData()
    }
    
    @objc func shareData() {
        let appActivities = [
            UIActivity.ActivityType.airDrop,
            UIActivity.ActivityType.markupAsPDF,
            UIActivity.ActivityType.mail,
            UIActivity.ActivityType.print
//            UIActivity.ActivityType.
        ]
        let vc = UIActivityViewController(activityItems: [data!], applicationActivities: [])
        vc.completionWithItemsHandler = completionWithItemsHandler
        vc.excludedActivityTypes =  [
            UIActivity.ActivityType.postToWeibo,
            UIActivity.ActivityType.assignToContact,
            UIActivity.ActivityType.addToReadingList,
            UIActivity.ActivityType.postToVimeo,
            UIActivity.ActivityType.postToTencentWeibo
        ]
        present(vc,
                animated: true,
                completion: nil)
        vc.popoverPresentationController?.sourceView = self.view
    }
}


struct SwiftUIActivityViewController : UIViewControllerRepresentable {
    
    var data: Data
    @Binding var showing: Bool

    func makeUIViewController(context: Context) -> ActivityViewController {
            // Create the host and setup the conditions for destroying it
        let result = ActivityViewController()

        result.completionWithItemsHandler = { (activityType, completed, returnedItems, error) in
                // To indicate to the hosting view this should be "dismissed"
            self.showing = false
        }

        return result
    }

    func updateUIViewController(_ uiViewController: ActivityViewController, context: Context) {
        // Update the text in the hosting controller
        uiViewController.data = data
    }
}
