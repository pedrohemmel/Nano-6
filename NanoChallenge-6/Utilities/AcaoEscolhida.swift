//
//  ModalType.swift
//  NanoChallenge-6
//
//  Created by Pedro Henrique Dias Hemmel de Oliveira Souza on 21/07/22.
//

import Foundation
import Metal


//Criando enum que vai identificar qual será o processo feito com o(s) objeto(s) com base na id
enum AcaoEscolhida: Identifiable {
    
    //Identificador que tem o valor setado conforme o processo que será feito
    var id: String {
        switch self {
        case .addUsu: return "addUsu"
        case .addDep: return "addDep"
        case .updateUsu: return "updateUsu"
        case .updateDep: return "updateDep"
        }
    }
    
    case addDep
    case addUsu
    case updateUsu(UsuarioMD)
    case updateDep(DepositoMD)
}
