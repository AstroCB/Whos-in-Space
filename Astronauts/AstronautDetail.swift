//
//  AstronautDetail.swift
//  Astronauts
//
//  Created by Cameron Bernhardt on 6/25/20.
//  Copyright © 2020 Cameron Bernhardt. All rights reserved.
//

import SwiftUI

struct AstronautDetail: View {
    var astronaut: Astronaut
    
    @Binding var isActive: Bool
    
    @ViewBuilder
    var body: some View {
        if astronaut.url != nil {
            SafariView(url: astronaut.url!, isActive: $isActive)
        } else {
            Text("Couldn't find any info on that astronaut!")
                .bold()
                .multilineTextAlignment(.center)
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        AstronautDetail(astronaut: testData[0], isActive: .constant(true))
    }
}
