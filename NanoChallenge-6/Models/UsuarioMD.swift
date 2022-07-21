//
//  UsuarioMD.swift
//  NanoChallenge-6
//
//  Created by Pedro Henrique Dias Hemmel de Oliveira Souza on 13/07/22.
//

import Foundation

//Criando a variável(objeto) estruturada
struct UsuarioMD: Identifiable, Codable {
    
    let id: UUID?
    var email: String
    var nomeUsu: String
    var senha: String
    
    
}
