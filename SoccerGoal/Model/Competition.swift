//
//  Competition.swift
//  SoccerGoal
//
//  Created by Jose M Arguinzzones on 2021-05-19.
//

import Foundation

struct Competition: Identifiable, Decodable {
    
    let id: Int
    let name: String
    let crestURL: String
    
}

extension Competition {
    
    static var defaultCompetitions: [Competition] {
        return [
            Competition(id: 2021, name: "English Premier League",crestURL: "https://upload.wikimedia.org/wikipedia/en/f/f2/Premier_League_Logo.svg"),
            Competition(id: 2014, name: "Spain La Liga", crestURL: "https://upload.wikimedia.org/wikipedia/commons/1/13/LaLiga.svg"),
            Competition(id: 2019, name: "Italian Serie A", crestURL: "https://upload.wikimedia.org/wikipedia/en/e/e1/Serie_A_logo_%282019%29.svg"),
            Competition(id: 2002, name: "Germany Bundesliga", crestURL: "https://upload.wikimedia.org/wikipedia/en/d/df/Bundesliga_logo_%282017%29.svg"),
//            Competition(id: 2003, name: "Netherlands Eredivise"),
            Competition(id: 2015, name: "France Ligue 1", crestURL: "https://upload.wikimedia.org/wikipedia/en/b/ba/Ligue_1_Uber_Eats.svg")
//            Competition(id: 2013, name: "Brazilian Série A"),
//            Competition(id: 2017, name: "Portuguese Primera Liga")
        ]
    }
}

