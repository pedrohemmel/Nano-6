//
//  CadastroViewController.swift
//  NanoChallenge-6
//
//  Created by Pedro Henrique Dias Hemmel de Oliveira Souza on 25/07/22.
//

import UIKit

class CadastroViewController: UIViewController {

    @IBOutlet weak var txtFieldNome: UITextField!
    @IBOutlet weak var txtFieldNomeUsuario: UITextField!
    @IBOutlet weak var txtFieldEmail: UITextField!
    @IBOutlet weak var txtFieldSenha: UITextField!
    
    var usuarios = [UsuarioMD]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Inicializando uma variável do tipo UsuarioViewModel para poder armazenar o valor que as funções trazem
        let usuarioViewModel = UsuarioViewModel()
        
        //Chamando e guardando todos usuários (objetos) contidos dentro do banco de dados e guarda-los em uma variável array
        Task {
            do {
                try await usuarioViewModel.buscaUsuarios()
                usuarios = usuarioViewModel.usuarios
            } catch {
                print("Erro \(error)")
            }
        }
        
        // Do any additional setup after loading the view.
    }
    
    //FUNÇÕES AQUI//
    
    //Função que verifica se ja existe um usuário com com as mesmas informações privadas
    func verificaUsuario(nomeUsuario: String, email: String) -> Bool {
        for usuario in usuarios {
            if(nomeUsuario == usuario.nomeUsu || email == usuario.email) {
                return false
            }
        }
        
        return true
    }
    
    @IBAction func adicionarNovoUsuario(_ sender: Any) {
        //Transformando os textos contidos nas textViews em strings
        guard let iptN = txtFieldNome.text else { return }
        let txtIptN = iptN.trimmingCharacters(in: .whitespacesAndNewlines)
       
        guard let iptNU = txtFieldNomeUsuario.text else { return }
        let txtIptNU = iptNU.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard let iptE = txtFieldEmail.text else { return }
        let txtIptE = iptE.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard let iptS = txtFieldSenha.text else { return }
        let txtIptS = iptS.trimmingCharacters(in: .whitespacesAndNewlines)
        
        //Fazendo a estrutura condicional que só entra se o usuário tiver escrito em todos campos
        if (txtIptN != "" && txtIptNU != "" && txtIptE != "" && txtIptS != "") {
            if(verificaUsuario(nomeUsuario: txtIptNU, email: txtIptE)) {
                
//                //Criando o objeto usuário que vai ser armazenado no banco de dados
//                let usuario = UsuarioMD(email: txtIptE, id: <#T##UUID?#>, nomeUsu: txtIptNU, endereco: txt, nome: <#T##String#>, senha: <#T##String#>)
//                
//                var adicionaUsu = AtualizaOuAdicionaUsuarioViewModel(usuarioAtual: <#T##UsuarioMD#>)
                
            }
        }
    }
    @IBAction func direcionarPagLogin(_ sender: Any) {
        //Instanciando a LoginViewController e redirecionando para la
        let entry = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        entry.modalPresentationStyle = .fullScreen
        present(entry, animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
