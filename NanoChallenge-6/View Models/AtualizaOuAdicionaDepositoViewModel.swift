//
//  AtualizaOuAdicionaDepositoViewModel.swift
//  NanoChallenge-6
//
//  Created by Pedro Henrique Dias Hemmel de Oliveira Souza on 21/07/22.
//

import Foundation

final class AtualizaOuAdicionaDepositoViewModel: ObservableObject {
    @Published var  = ""
    
    @Published var songId: UUID?
    
    var isUpdating: Bool {
        songId != nil
    }
    
    var buttonTitle: String {
        songId != nil ? "U"
    }
}


//final class UpdateOrAddSongViewModel: ObservableObject {
//    @Published var songTitle = ""
//
//    @Published var songID: UUID?
//
//    var isUpdating: Bool {
//        songID != nil
//    }
//
//    var buttonTitle: String {
//        songID != nil ? "Update Song" : "Add Song"
//    }
//
//    init() {}
//
//    init(currentSong: Song) {
//        self.songTitle = currentSong.title
//        self.songID = currentSong.id
//    }
//
//    //Criando função que vai enviar os dados no banco de dados para salvar uma nova música
//    func addSong() async throws {
//        let urlString : String = Constants.baseURL + Endpoints.songs
//
//        guard let url = URL(string: urlString) else {
//            throw HttpError.badURL
//        }
//
//        let song = Song(id: nil, title: songTitle)
//
//        try await HttpClient.shared.sendData(to: url, object: song, httpMethod: HttpMethods.POST.rawValue)
//    }
//
//    //Função que vai permitir o usuário de editar dados das músicas
//    func updateSong() async throws {
//        //Setando a url base para o acesso à API
//        let urlString : String = Constants.baseURL + Endpoints.songs
//
//        guard let url = URL(string: urlString) else {
//            throw HttpError.badURL
//        }
//
//        //Estruturando um novo objeto do tipo Song para enviar para o banco dados pelo método PUT
//        let songToUpdate = Song(id: songID, title: songTitle)
//
//        //Enviando dados para a API em JSON, após isso os dados serão enviados para o banco de dados
//        try await HttpClient.shared.sendData(to: url, object: songToUpdate, httpMethod: HttpMethods.PUT.rawValue)
//
//        print("atualizou agora")
//    }
//
//    //função que faz a decisão de qual vai ser a função a ser chamada: addSong() || updateSong()
//    func addOrUpdateAction()  {
//        Task {
//            do {
//                if isUpdating {
//                    try await updateSong()
//                } else {
//                    try await addSong()
//                }
//            } catch {
//                print("Error: \(error)")
//            }
//        }
//    }
//
//
//}
