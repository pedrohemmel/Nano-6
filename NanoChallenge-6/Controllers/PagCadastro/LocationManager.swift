//
//  LocationManager.swift
//  NanoChallenge-6
//
//  Created by Pedro Henrique Dias Hemmel de Oliveira Souza on 26/07/22.
//

import Foundation
import CoreLocation

struct Localizacao {
    let titulo: String
    let coordenadas: CLLocationCoordinate2D
}

class LocationManager: NSObject {
    static let shared = LocationManager()
    
    let manager = CLLocationManager()
    
    public func acharLocalizacao(with query: String, completion: @escaping ((([Localizacao]) -> Void))) {}
}
