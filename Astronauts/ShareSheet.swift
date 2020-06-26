//
//  ShareSheet.swift
//  Astronauts
//
//  Created by Cameron Bernhardt on 6/25/20.
//  Copyright © 2020 Cameron Bernhardt. All rights reserved.
//

import SwiftUI

struct ShareSheet: UIViewControllerRepresentable {
    
    let items: [Any]
    let activities: [UIActivity]?
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ShareSheet>) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: activities)
        controller.modalPresentationStyle = .pageSheet
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ShareSheet>) {
        
    }
}

struct ShareButton: View {
    @Binding var showingSheet: Bool
    
    var items: [Any]
    var activities: [UIActivity]?
    
    var body: some View {
        Button(action: {
            self.showingSheet = true
        }) {
            Image(systemName: "square.and.arrow.up")
                .font(.title)
        }
        .sheet(isPresented: $showingSheet,
               content: {
                ShareSheet(items: self.items, activities: self.activities) })
    }
}


struct ShareSheet_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ShareButton(showingSheet: .constant(true), items: [testData[0].url!], activities: nil)
                .padding()
            ShareSheet(items: [testData[0].url!], activities: nil)
                .edgesIgnoringSafeArea(.bottom)
        }
    }
}
