//
//  UsuarioMD.swift
//  NanoChallenge-6
//
//  Created by Pedro Henrique Dias Hemmel de Oliveira Souza on 13/07/22.
//

import Foundation

//Criando a variável(objeto) estruturada
struct UsuarioMD: Identifiable, Codable {
    
    var email: String
    let id: UUID?
    var nomeUsu: String
    var nome: String
    var endereco: String
    var senha: String

}
