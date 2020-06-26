//
//  AstronautView.swift
//  Astronauts
//
//  Created by Cameron Bernhardt on 6/25/20.
//  Copyright © 2020 Cameron Bernhardt. All rights reserved.
//

import SwiftUI

struct AstronautView: View {
    var astronauts: [Astronaut]
    var description: String {
        "\(astronauts.count) astronauts are in space! Find out who they are by downloading Who's in Space? from the app store: https://apple.co/2Z7MpeA"
    }
    
    @State var showingSheet = false
    
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
                HStack {
                    Spacer()
                    ShareButton(showingSheet: $showingSheet, items: [self.description])
                    Spacer()
                }
                .padding()
            }
            .navigationBarTitle("Who's in space?")
            Text("Select an astronaut!")
                .font(.title)
        }
    }
}

struct AstroCell: View {
    var astronaut: Astronaut
    
    // Used to dismiss the nav view from UIKit
    @State var isActive = false
    
    var body: some View {
        NavigationLink(destination: AstroDestination(astronaut: astronaut, isActive: $isActive), isActive: $isActive) {
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

struct AstroDestination: View {
    var astronaut: Astronaut
    
    @Binding var isActive: Bool
    
    var body: some View {
        AstronautDetail(astronaut: astronaut, isActive: $isActive)
            .edgesIgnoringSafeArea(.all)
            .navigationBarTitle(astronaut.name)
            .onTapGesture {
                self.isActive = true
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        AstronautView(astronauts: testData)
    }
}
