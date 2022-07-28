//
//  DepositoMD.swift
//  NanoChallenge-6
//
//  Created by Pedro Henrique Dias Hemmel de Oliveira Souza on 13/07/22.
//

import Foundation

struct DepositoMD: Identifiable, Codable {
    let id: UUID?
    var cnpj: String
    var endereco: String
    var senha: String
    var emailContato: String
    var nomeFantasia: String
}
