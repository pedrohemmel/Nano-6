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
    
    public func acharLocalizacao(with query: String, completion: @escaping ((([Localizacao]) -> Void))) {
        
        //Criando a variavel que vai identificar o endereço inserido pelo usuário
        let geoCodigo = CLGeocoder()
        
        //Estruturando o endereço inserido pelo usuário
        geoCodigo.geocodeAddressString(query) { places, error in
            guard let places = places, error == nil else {
                completion([])
                return
            }
            
            //variavel estruturada que retorna um endereço completo
            let enderecoEstruturado: [Localizacao] = places.compactMap({ place in
                
                //variavel que armazenará o titulo da variável enderecoEstruturado
                var tituloCompleto = ""
                
                //Para cada condicional, identificado o endereço digitado pelo usuário e inserido separadamente em cada uma das estruturas
                
                if let nomeDaLocalizacao = place.name {
                    tituloCompleto += nomeDaLocalizacao
                }
                
                if let bairro = place.administrativeArea {
                    tituloCompleto += ", \(bairro)"
                }
                
                if let cidade = place.locality {
                    tituloCompleto += ", \(cidade)"
                }
                
                if let pais = place.country {
                    tituloCompleto += ", \(pais)"
                }
                
                //Estruturando a struct Localização que vai ser retornada
                let localizacao = Localizacao(titulo: tituloCompleto, coordenadas: place.location!.coordinate)
                
                return localizacao
                
            })
            
            completion(enderecoEstruturado)
        }
    }
}
