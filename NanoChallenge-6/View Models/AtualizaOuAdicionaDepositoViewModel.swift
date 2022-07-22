//
//  AtualizaOuAdicionaDepositoViewModel.swift
//  NanoChallenge-6
//
//  Created by Pedro Henrique Dias Hemmel de Oliveira Souza on 21/07/22.
//

import Foundation

final class AtualizaOuAdicionaDepositoViewModel: ObservableObject {
    @Published var cnpjDep = ""
    @Published var nomeFantasiaDep = ""
    @Published var emailContatoDep = ""
    @Published var enderecoDep = ""
    @Published var senhaDep = ""
    
    @Published var depositoId: UUID?
    
    var estaAtualizando: Bool {
        depositoId != nil
    }
    
    //Setando qual será o valor do titulo quando o usuário clicar
    var tituloBotao: String {
        depositoId != nil ? "Atualiza Deposito" : "Adicionar Deposito"
    }
    
    init() {}
    
    //Inicializando as variáveis com o parâmetro de um objeto ja estruturado
    init(depositoAtual: DepositoMD) {
        self.cnpjDep = depositoAtual.CNPJ
        self.nomeFantasiaDep = depositoAtual.nomeFantasia
        self.emailContatoDep = depositoAtual.emailContato
        self.enderecoDep = depositoAtual.endereco
        self.senhaDep = depositoAtual.senha
        
        self.depositoId = depositoAtual.id
    }
    
    
    //Criando função que vai enviar os dados no banco de dados para salvar um novo deposito
    func adicionaDeposito() async throws {
        
        //Setando qual será a url usada para enviar ao banco de dados na tabela certa
        let urlString : String = Constantes.baseURL + PontosFinais.depositos
        
        //Autenticando a url
        guard let url = URL(string: urlString) else {
            throw ErrosHTTP.badURL
        }
        
        //Criando o objeto que queremos enviar para o banco de dados
        let deposito = DepositoMD(id: nil, nomeFantasia: self.nomeFantasiaDep, CNPJ: self.cnpjDep, emailContato: self.emailContatoDep, endereco: self.enderecoDep, senha: self.senhaDep)
        
        //Enviando o objeto criado pela url autenticada e determinando o metodo que enviamos por HTTP que é o POST
        try await ClienteHttp.shared.enviarDado(to: url, objeto: deposito, metodoHttp: MetodosHTTP.POST.rawValue)
    }
    
    //Função que vai permitir o usuário de editar dados dos depositos
    
    func atualizaDeposito() async throws {
        
        //Setando qual será a url usada para enviar ao banco de dados na tabela certa
        let urlString : String = Constantes.baseURL + PontosFinais.depositos
        
        //Autenticando a url
        guard let url = URL(string: urlString) else {
            throw ErrosHTTP.badURL
        }
        //Criando o objeto que queremos enviar para o banco de dados mas agora setamos o id existente porque o objeto sera modificado e não criado
        let depositoAtualizado = DepositoMD(id: self.depositoId, nomeFantasia: self.nomeFantasiaDep, CNPJ: self.cnpjDep, emailContato: self.emailContatoDep, endereco: self.enderecoDep, senha: self.senhaDep)
        
        //Enviando o objeto criado pela url autenticada e determinando o metodo que enviamos por HTTP que é o PUT que seria para modificar o objeto
        try await ClienteHttp.shared.enviarDado(to: url, objeto: depositoAtualizado, metodoHttp: MetodosHTTP.PUT.rawValue)
    }
    
    //função que faz a decisão de qual vai ser a função a ser chamada: adicionaDeposito() || atualizaDeposito()
    func atualizarOuAdicionarDeposito() {
        Task {
            do {
                if estaAtualizando {
                    try await atualizaDeposito()
                } else {
                    try await adicionaDeposito()
                }
            } catch {
                print("Erro \(error)")
            }
        }
    }
}
