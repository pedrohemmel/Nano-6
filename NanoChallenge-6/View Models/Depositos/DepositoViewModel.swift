//
//  DepositoViewModel.swift
//  NanoChallenge-6
//
//  Created by Pedro Henrique Dias Hemmel de Oliveira Souza on 21/07/22.
//

import Foundation

class DepositoViewModel: ObservableObject {
    var depositos = [DepositoMD]()
    
    func buscarDepositos() async throws {
        
        //Variável que vai juntar as duas constantes que representam o link de conexão para o banco de dados
        let urlString = Constantes.baseURL + PontosFinais.depositos
        
        //Verificando se o link é válido
        guard let url = URL(string: urlString) else {
            throw ErrosHTTP.badURL
        }
        
        //Buscando os dados no banco de dados
        let depositosResponse : [DepositoMD] = try await ClienteHttp.shared.buscar(url: url)
   
        
        //Atualizando os objetos dentro da variável array depositos
        DispatchQueue.main.async {
            self.depositos = depositosResponse
        }
    }
    
    func deletarDeposito(at indice: Int) async throws {
        
        //Guardando a id do usuário em seu indice
        guard let depositoId = depositos[indice].id else {
            return
        }
        
        //Guardando a url necessária para se conectar no servidor em uma variável
        guard let url = URL(string: Constantes.baseURL + PontosFinais.depositos) else {
            return
        }
        
        //Fazendo o processo de deletar o usuario
        Task {
            do {
                try await ClienteHttp.shared.deletar(at: depositoId, url: url)
            } catch {
                print("Erro \(error)")
            }
        }
        
        //removendo o usuário da array
        depositos.remove(at: indice)
    }
}
