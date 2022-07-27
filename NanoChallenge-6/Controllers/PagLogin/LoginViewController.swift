//
//  LoginViewController.swift
//  NanoChallenge-6
//
//  Created by Pedro Henrique Dias Hemmel de Oliveira Souza on 23/07/22.
//

import UIKit

class LoginViewController: UIViewController {

    //Conectando os objetos do storyboard em variáveis

    @IBOutlet weak var txtFieldEmailOuUsuario: UITextField!
    @IBOutlet weak var txtFieldSenha: UITextField!
    @IBOutlet weak var iptEmailOuUsuarioView: UIView!
    @IBOutlet weak var iptSenhaView: UIView!
    @IBOutlet weak var btnEntrar: UIButton!
    
    //Criando a variável do tipo UsuariosMD que vai auxiliar no processo de login
    var usuarios = [UsuarioMD]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Modificando as bordas das views de campo para inserir email, senha e o botão de entrar
        iptEmailOuUsuarioView.layer.cornerRadius = 10
        iptSenhaView.layer.cornerRadius = 10
        btnEntrar.layer.cornerRadius = 10
        
        //Declarando que o textfield de senha tem que ter letras escondidas
        txtFieldSenha.isSecureTextEntry = true
        
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
        
        for usuario in usuarios {
            print(usuario)
        }
        
        adicionandoFuncoesKeyBoard()
        
    

        // Do any additional setup after loading the view.
    }
    
    //FUNÇÕES AQUI//
    
    func adicionandoFuncoesKeyBoard() {
        //Chamando funções de quando o usuário ativa o keyboard
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(escondeKeyBoard)))
    }
    @objc func escondeKeyBoard() {
        self.view.endEditing(true)
    }
    
    func verificaLogin(emailOuUsuario: String, senha: String, usuario: UsuarioMD) -> Bool {
        if ((emailOuUsuario == usuario.email && senha == usuario.senha) || (emailOuUsuario == usuario.nomeUsu && senha == usuario.senha)) {
            return true
        } else {
            return false
        }
    }

    
    @IBAction func entrarComEmailESenha(_ sender: Any) {
        
        print("Entrou na função")
        
        //Transformando os textos contidos nas textViews em strings
        guard let iptEU = txtFieldEmailOuUsuario.text else { return }
        let txtIptEU = iptEU.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard let iptS = txtFieldSenha.text else { return }
        let txtIptS = iptS.trimmingCharacters(in: .whitespacesAndNewlines)
        
        //Fazendo a condição de que se os campos estiverem vazios, nada acontecerá ao clicar e caso ao contrário, será feito a verificação de usuário
        if (txtIptEU != "" && txtIptS != "") {
            //Fazendo o laço de repetição que vai percorrer todos usuário para verificar se algum coincide com o que foi digitado
            for usuario in self.usuarios {
                print(usuario.nome)
                if(verificaLogin(emailOuUsuario: txtIptEU, senha: txtIptS, usuario: usuario)) {
                    //Instanciando a MainViewController e redirecionando para la
                    let entry = storyboard?.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
                    entry.modalPresentationStyle = .fullScreen
                    present(entry, animated: true)
                } else {
                    print("Não entrou")
                }
            }
        } else {
            print("Não escreveu nada")
        }
        
        
        
    }
    
    @IBAction func direcionarPagCadastro(_ sender: Any) {
        //Instanciando a CadastroViewController e redirecionando para la
        let entry = storyboard?.instantiateViewController(withIdentifier: "CadastroViewController") as! CadastroViewController
        entry.modalPresentationStyle = .fullScreen
        present(entry, animated: true)
    }
    


}
