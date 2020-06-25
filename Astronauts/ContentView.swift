//
//  ContentView.swift
//  Astronauts
//
//  Created by Cameron Bernhardt on 6/25/20.
//  Copyright © 2020 Cameron Bernhardt. All rights reserved.
//

import SwiftUI

struct AstronautView: View {
    var astronauts: [Astronaut] = []
    
    var body: some View {
        NavigationView {
            List(astronauts) { astronaut in
                NavigationLink(destination: Text(astronaut.name)) {
                    VStack(alignment: .leading) {
                        Text(astronaut.name)
                        Text(astronaut.craft)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        AstronautView(astronauts: testData)
    }
}
