//
//  SafariView.swift
//  Astronauts
//
//  Created by Cameron Bernhardt on 6/25/20.
//  Copyright © 2020 Cameron Bernhardt. All rights reserved.
//

import SwiftUI
import SafariServices

struct SafariView: UIViewControllerRepresentable {
    typealias UIViewControllerType = SFSafariViewController
    
    var url: URL
    
    @Binding var isActive: Bool
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        let controller = SFSafariViewController(url: url)
        controller.delegate = context.coordinator
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
        
    }
    
    func makeCoordinator() -> SafariCoordinator {
        return SafariCoordinator(parent: self)
    }
}

class SafariCoordinator: NSObject, SFSafariViewControllerDelegate {
    var parent: SafariView
    
    init(parent: SafariView) {
        self.parent = parent
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        // Dismiss Safari view from nav controller when "Done" pressed
        parent.isActive = false
    }
}

struct SafariView_Previews: PreviewProvider {
    static var previews: some View {
        SafariView(url: testData[0].url!, isActive: .constant(true))
    }
}
