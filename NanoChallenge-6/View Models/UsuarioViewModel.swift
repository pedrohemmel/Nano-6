//
//  UsuarioViewModel.swift
//  NanoChallenge-6
//
//  Created by Pedro Henrique Dias Hemmel de Oliveira Souza on 21/07/22.
//

import Foundation

public class UsuarioViewModel: ObservableObject {
    var usuarios = [UsuarioMD]()
    
    func buscaUsuarios() async throws {
        //Variável que vai juntar as duas constantes que representam o link de conexão para o banco de dados
        let urlString = Constantes.baseURL + PontosFinais.usuarios
        
        //Verificando se o link é válido
        guard let url = URL(string: urlString) else {
            throw ErrosHTTP.badURL
        }
        
        //Buscando os dados no banco de dados
        let usuarioResponse: [UsuarioMD] = try await ClienteHttp.shared.buscar(url: url)
        
        //Atualizando os objetos dentro da variável array usuarios
        DispatchQueue.main.async {
            self.usuarios = usuarioResponse
        }
    }
    
    func deletarUsuario(at indice: Int) {
        
        //Guardando a id do usuário em seu indice
        guard let usuariosId = usuarios[indice].id else {
            return
        }
        
        //Guardando a url necessária para se conectar no servidor em uma variável
        guard let url = URL(string: Constantes.baseURL + PontosFinais.usuarios) else {
            return 
        }
        
        //Fazendo o processo de deletar o usuario
        Task {
            do {
                try await ClienteHttp.shared.deletar(at: usuariosId, url: url)
            } catch {
                print("Erro \(error)")
            }
        }

        //removendo o usuário da array
        usuarios.remove(at: indice)
    }
}


