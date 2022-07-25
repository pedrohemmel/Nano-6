//
//  ClienteHTTP.swift
//  NanoChallenge-6
//
//  Created by Pedro Henrique Dias Hemmel de Oliveira Souza on 21/07/22.
//

import Foundation

//Declarando os métodos que poderão ser utilizados no processo CRUD do sistema
enum MetodosHTTP: String {
    case GET, PUT, POST, DELETE
}

//MIMEType e HttpHeaders são propriedades que utilizamos ao utilizar os métodos POST e PUT
enum MIMEType: String {
    case JSON = "application/json"
}
enum HttpHeaders: String {
    case contentType = "content-type"
}

//Declarando possíveis erros do sistema para melhorar o desenvolvimento do código
enum ErrosHTTP: Error {
    case badURL, badResponse, errorDecodingData, invalidURL, errorNotError
}

//Criando classe que será a ligaçao com a API do sistema sendo possível acessar essa classe através do método Singleton
class ClienteHttp {
    
    private init() {}
    
    //Variável que instancia a própria função assim possíbilitando o acesso pelo método Singleton
    static let shared = ClienteHttp()
    
    //Função responsável por fazer a query do banco de dados se comunicando pela API
    func buscar<T: Codable>(url: URL) async throws -> [T] {
        let (data, response) = try await URLSession.shared.data(from: url)
        print("ja fez o get")
        //Verificando se a URL está autêntica no servidor
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw ErrosHTTP.badResponse
        }
        
        print("erro ")
        //Puxando todos dados dentro da tabela usuarios e jogando dentro da variável (Array de generics) objeto
        guard let objeto = try? JSONDecoder().decode([T].self, from: data) else {
            throw ErrosHTTP.errorDecodingData
        }
        
        print("termina aqui")
        
        return objeto
    }
    
    //Função que enviará um novo objeto para ser registrado na tabela especificada na url do parâmetro
    func enviarDado<T: Codable>(to url: URL, objeto: T, metodoHttp: String) async throws {
        var request = URLRequest(url: url)
        
        //Aplicando as propriedades necessárias para enviar dados para o banco de dados pela API
        request.httpMethod = metodoHttp
        request.addValue(MIMEType.JSON.rawValue, forHTTPHeaderField: HttpHeaders.contentType.rawValue)
        
        //Inserindo o objeto dentro do corpo que identifica o objeto que será enviado para o bando de dados
        request.httpBody = try? JSONEncoder().encode(objeto)
        
        //Fazendo a tentativa de envio da variável request para o banco de dados
        let (_, response) = try await URLSession.shared.data(for: request)
        
        //Verificando se o envio deu certo, caso não tenha dado, será alertado um erro
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw ErrosHTTP.badResponse
        }
    }
    
    //Apagando um dados específico do banco de dados dependendo do ID especificado no parâmetro
    func deletar(at id: UUID, url: URL) async throws {
        var request = URLRequest(url: url)
        
        //Definindo o método em que vai ser feita a requisição
        request.httpMethod = MetodosHTTP.DELETE.rawValue
        
        //Fazendo a tentativa de envio da variável request para o banco de dados
        let (_, response) = try await URLSession.shared.data(for: request)
        
        //Verificando se o envio deu certo, caso não tenha dado, será alertado um erro
        guard(response as? HTTPURLResponse)?.statusCode == 200  else {
            throw ErrosHTTP.badResponse
        }
    }
    
}
