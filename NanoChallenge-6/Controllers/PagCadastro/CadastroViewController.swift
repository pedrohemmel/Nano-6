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
    
    @IBOutlet weak var iptNomeView: UIView!
    @IBOutlet weak var iptNomeUsuView: UIView!
    @IBOutlet weak var iptEmailView: UIView!
    @IBOutlet weak var iptSenhaView: UIView!
    
    var usuarios = [UsuarioMD]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Inicializando uma variável do tipo UsuarioViewModel para poder armazenar o valor que as funções trazem
        let usuarioViewModel = UsuarioViewModel()
        
        //setando borda customizada à alguns objetos
        iptNomeView.layer.cornerRadius = 10
        iptNomeUsuView.layer.cornerRadius = 10
        iptEmailView.layer.cornerRadius = 10
        iptSenhaView.layer.cornerRadius = 10
        
        //Declarando que o textfield de senha tem que ter letras escondidas
        txtFieldSenha.isSecureTextEntry = true
        
        //Chamando e guardando todos usuários (objetos) contidos dentro do banco de dados e guarda-los em uma variável array
        Task {
            do {
                try await usuarioViewModel.buscaUsuarios()
                usuarios = usuarioViewModel.usuarios
            } catch {
                print("Erro \(error)")
            }
        }
        
        //Chamando funções de quando o usuário ativa o keyboard
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(escondeKeyBoard)))
        NotificationCenter.default.addObserver(self, selector: #selector(apareceKeyBoard(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(desapareceKeyBoard), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    //FUNÇÕES AQUI//
    
    //Funções do keyBoard
    
    @objc func escondeKeyBoard() {
        self.view.endEditing(true)
    }
    
    @objc func apareceKeyBoard(notification: NSNotification) {
        print("apareceu")
    }
    
    @objc func desapareceKeyBoard() {
        
    }
    
    //Função que verifica se ja existe um usuário com com as mesmas informações privadas
    func verificaUsuario(nomeUsuario: String, email: String) -> Bool {
        for usuario in usuarios {
            print(usuario.nome)
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
                
                //Instanciando a tela que adicionará um endereco ao usuário
                let entry = storyboard?.instantiateViewController(withIdentifier: "AdicionarEnderecoViewController") as! AdicionarEnderecoViewController
                
      
                //Enviando dados do usuário para a próxima tela
                entry.nome = txtIptN
                entry.nomeUsuario = txtIptNU
                entry.email = txtIptE
                entry.senha = txtIptS
                
                
                entry.modalPresentationStyle = .fullScreen
                present(entry, animated: true)
                
            }
        }
    }
    @IBAction func direcionarPagLogin(_ sender: Any) {
        dismiss(animated: true)
    }
    


}
