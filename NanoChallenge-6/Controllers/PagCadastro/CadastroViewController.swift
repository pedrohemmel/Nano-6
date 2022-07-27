//
//  CadastroViewController.swift
//  NanoChallenge-6
//
//  Created by Pedro Henrique Dias Hemmel de Oliveira Souza on 25/07/22.
//

import UIKit

class CadastroViewController: UIViewController {


    @IBOutlet weak var imgBannerFundo: UIImageView!
    @IBOutlet weak var txtFieldNome: UITextField!
    @IBOutlet weak var txtFieldNomeUsuario: UITextField!
    @IBOutlet weak var txtFieldEmail: UITextField!
    @IBOutlet weak var txtFieldSenha: UITextField!
    
    @IBOutlet weak var iptNomeView: UIView!
    @IBOutlet weak var iptNomeUsuView: UIView!
    @IBOutlet weak var iptEmailView: UIView!
    @IBOutlet weak var iptSenhaView: UIView!
    
    //Criando variável que vai auxiliar quando o keyboard for aparacer e esconder alguns textFields
    var escondeuTxtField : Bool = true
    var equilibraPosicaoView : Int = 0
    
    var usuarios = [UsuarioMD]()
    
    //Inicializando uma variável do tipo UsuarioViewModel para poder armazenar o valor que as funções trazem
    let usuarioViewModel = UsuarioViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //SETANDO INFORMAÇÕES DA VIEW CONSTROLLER
        adicionandoBordasCustomizadas()
        //Declarando que o textfield de senha tem que ter letras escondidas
        txtFieldSenha.isSecureTextEntry = true
        buscarUsuarios()
        adicionandoFuncoesKeyBoard()
        
    }
    
    //FUNÇÕES AQUI//
    
    //Buscando dados dos usuários
    func buscarUsuarios() {
        //Chamando e guardando todos usuários (objetos) contidos dentro do banco de dados e guarda-los em uma variável array
        Task {
            do {
                try await self.usuarioViewModel.buscaUsuarios()
                self.usuarios = usuarioViewModel.usuarios
            } catch {
                print("Erro \(error)")
            }
        }
    }
    
    //Setando borda nos inputs
    func adicionandoBordasCustomizadas() {
        //setando borda customizada à alguns objetos
        iptNomeView.layer.cornerRadius = 10
        iptNomeUsuView.layer.cornerRadius = 10
        iptEmailView.layer.cornerRadius = 10
        iptSenhaView.layer.cornerRadius = 10
    }
    
    //FUNÇÕES DO KEYBOARD
    
    func adicionandoFuncoesKeyBoard() {
        //Chamando funções de quando o usuário ativa o keyboard
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(escondeKeyBoard)))
        NotificationCenter.default.addObserver(self, selector: #selector(apareceKeyBoard(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(desapareceKeyBoard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc func escondeKeyBoard() {
        self.view.endEditing(true)
    }
    @objc func apareceKeyBoard(notification: NSNotification) {
        if self.escondeuTxtField == true {
            if(self.equilibraPosicaoView == 0) {
                self.view.frame = self.view.frame.offsetBy(dx: CGFloat(0), dy: CGFloat(-125))
                self.escondeuTxtField = false
                self.equilibraPosicaoView = -125
            }
        }
    }
    @objc func desapareceKeyBoard() {
        if self.escondeuTxtField == false {
            if(self.equilibraPosicaoView != 0) {
                self.view.frame = self.view.frame.offsetBy(dx: CGFloat(0), dy: CGFloat(125))
                self.escondeuTxtField = true
                self.equilibraPosicaoView = 0
            }
            
        }
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
