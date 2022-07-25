//
//  AtualizaOuAdicionaUsuarioViewModel.swift
//  NanoChallenge-6
//
//  Created by Pedro Henrique Dias Hemmel de Oliveira Souza on 21/07/22.
//

import Foundation

final class AtualizaOuAdicionaUsuarioViewModel: ObservableObject {
    @Published var emailUsu = ""
    @Published var nomeDeUsuario = ""
    @Published var nomeUsu = ""
    @Published var enderecoUsu = ""
    @Published var senhaUsu = ""
    
    @Published var usuarioId : UUID?
    
    var estaAtualizando : Bool {
        usuarioId != nil
    }
    
    //Setando qual será o valor do titulo quando o usuário clicar
    var tituloBotao : String {
        usuarioId != nil ? "Atualiza Usuario" : "Adiciona Usuario"
    }
    
    init() {}
    
    //Inicializando as variáveis com o parâmetro de um objeto ja estruturado
    init(usuarioAtual: UsuarioMD) {
        self.emailUsu = usuarioAtual.email
        self.nomeDeUsuario = usuarioAtual.nomeUsu
        self.nomeUsu = usuarioAtual.nome
        self.enderecoUsu = usuarioAtual.endereco
        self.senhaUsu = usuarioAtual.senha
        
        self.usuarioId = usuarioAtual.id
    }
    
    //Criando função que vai enviar os dados no banco de dados para salvar um novo usuario
    func adicionaUsuario() async throws {
        
        //Setando qual será a url usada para enviar ao banco de dados na tabela certa
        let urlString: String = Constantes.baseURL + PontosFinais.usuarios
        
        //Autenticando a url
        guard let url = URL(string: urlString) else {
            throw ErrosHTTP.badURL
        }
        
        //Criando o objeto que queremos enviar para o banco de dados
        let usuario = UsuarioMD(email: self.emailUsu, id: nil, nomeUsu: self.nomeDeUsuario, endereco: self.nomeUsu, nome: self.enderecoUsu, senha: self.senhaUsu)
        
        //Enviando o objeto criado pela url autenticada e determinando o metodo que enviamos por HTTP que é o POST
        try await ClienteHttp.shared.enviarDado(to: url, objeto: usuario, metodoHttp: MetodosHTTP.POST.rawValue)
    }
    
    //Função que vai permitir o usuário de editar dados dos usuarios
    func atualizaUsuario() async throws {
        
        //Setando qual será a url usada para enviar ao banco de dados na tabela certa
        let urlString: String = Constantes.baseURL + PontosFinais.usuarios
        
        //Autenticando a url
        guard let url = URL(string: urlString) else {
            throw ErrosHTTP.badURL
        }
        
        //Criando o objeto que queremos enviar para o banco de dados mas agora setamos o id existente porque o objeto sera modificado e não criado
        let usuario = UsuarioMD(email: self.emailUsu, id: self.usuarioId, nomeUsu: self.nomeDeUsuario, endereco: self.nomeUsu, nome: self.enderecoUsu, senha: self.senhaUsu)
        
        //Enviando o objeto criado pela url autenticada e determinando o metodo que enviamos por HTTP que é o PUT que seria para modificar o objeto
        try await ClienteHttp.shared.enviarDado(to: url, objeto: usuario, metodoHttp: MetodosHTTP.PUT.rawValue)
    }
    
    //função que faz a decisão de qual vai ser a função a ser chamada: adicionaUsuario() || atualizaUsuario()
    func atualizaOuAdicionaUsuario() {
        Task {
            do {
                if estaAtualizando {
                    try await atualizaUsuario()
                } else {
                    try await adicionaUsuario()
                }
            } catch {
                print("Erro \(error)")
            }
        }
    }
}
    
