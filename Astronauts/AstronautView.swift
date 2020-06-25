//
//  AstronautView.swift
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
            VStack {
                Text("\(astronauts.count)")
                    .font(.system(size: 150))
                    .bold()
                Text("astronauts are in space!")
                    .padding()
                List(astronauts) { astronaut in
                    AstroCell(astronaut: astronaut)
                }
            }
            Text("Select an astronaut!")
            .navigationBarTitle("Who's in space?")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        AstronautView(astronauts: testData)
    }
}

struct AstroDestination: View {
    var astronaut: Astronaut
    
    var body: some View {
        AstronautDetail(astronaut: astronaut)
            .edgesIgnoringSafeArea(.bottom)
            .navigationBarTitle(astronaut.name)
    }
}

struct AstroCell: View {
    var astronaut: Astronaut
    
    var body: some View {
        NavigationLink(destination: AstroDestination(astronaut: astronaut)) {
            VStack(alignment: .leading) {
                Text(astronaut.name)
                    .font(.headline)
                Text(astronaut.craft)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}
