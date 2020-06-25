//
//  Astronaut.swift
//  Astronauts
//
//  Created by Cameron Bernhardt on 6/25/20.
//  Copyright © 2020 Cameron Bernhardt. All rights reserved.
//

import Foundation

struct Astronaut: Codable, Identifiable {
    var id = UUID()
    var name: String
    var craft: String
    var url: URL? {
        // Google encodes spaces as +
        let encodedName = name.replacingOccurrences(of: " ", with: "+")
        return URL(string: "https://google.com/search?q=\(encodedName)")
    }
}

struct APIResponse: Codable {
    var message: String
    var number: Int
    var people: [Astronaut]
}


var testData: [Astronaut] = [
    Astronaut(name: "Doug Hurley", craft: "ISS"),
    Astronaut(name: "Loug Hurley", craft: "ISS"),
    Astronaut(name: "Boug Hurley", craft: "Dragon"),
    Astronaut(name: "Roug Hurley", craft: "Dragon"),
    Astronaut(name: "Koug Hurley", craft: "ISS")
]
