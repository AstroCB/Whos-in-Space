//
//  Astronaut.swift
//  Astronauts
//
//  Created by Cameron Bernhardt on 6/25/20.
//  Copyright © 2020 Cameron Bernhardt. All rights reserved.
//

import Foundation

let API_URL = "http://api.open-notify.org/astros.json"

struct Astronaut: Codable, Identifiable {
    var name: String
    var craft: String
    
    var id: UUID {
        return UUID()
    }
    
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

func retrieveData() -> APIResponse {
    if let url = URL(string: API_URL), let data = try? Data(contentsOf: url) {
        let decoder = JSONDecoder()
        
        if let response = try? decoder.decode(APIResponse.self, from: data) {
            return response
        }
    }
    
    return APIResponse(message: "failure", number: 0, people: [])
}


var testData: [Astronaut] = [
    Astronaut(name: "Doug Hurley", craft: "ISS"),
    Astronaut(name: "Loug Hurley", craft: "ISS"),
    Astronaut(name: "Boug Hurley", craft: "Dragon"),
    Astronaut(name: "Roug Hurley", craft: "Dragon"),
    Astronaut(name: "Koug Hurley", craft: "ISS")
]
