//
//  AstronautDetail.swift
//  Astronauts
//
//  Created by Cameron Bernhardt on 6/25/20.
//  Copyright © 2020 Cameron Bernhardt. All rights reserved.
//

import SwiftUI
import SafariServices

struct AstronautDetail: View {
    var astronaut: Astronaut
    
    @ViewBuilder
    var body: some View {
        if astronaut.url != nil {
            SafariView(url: astronaut.url!)
        } else {
            Text("Couldn't find any info on that astronaut!")
                .bold()
                .multilineTextAlignment(.center)
        }
    }
}

struct SafariView: UIViewControllerRepresentable {
    typealias UIViewControllerType = SFSafariViewController
    
    var url: URL
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
        
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        AstronautDetail(astronaut: testData[0])
    }
}
