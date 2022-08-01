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
    
    //Criando variável userDefault para guardar o status de logado no sistema do usuário
    var userDefaults = UserDefaults()
    
    //Criando a variável do tipo UsuariosMD que vai auxiliar no processo de login
    var usuarios = [UsuarioMD]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        UserDefaults.standard.setValue(nil, forKey: "usuario")
//        UserDefaults.standard.setValue(nil, forKey: "logado")
//
//        let entry = storyboard?.instantiateViewController(withIdentifier: "MapaGeograficoViewController") as! MapaGeograficoViewController
//        entry.modalPresentationStyle = .fullScreen
//        present(entry, animated: true)

        
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
    
    //É chamado a função verificaStatus no ViewDidAppear porque apenas nesse momento é possivel fazer um redirecionamento de tela caso o usuário ja tenha feito o login
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        verificaStatus()
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
    
    func verificaStatus() {
        //Criando as variáveis que vão armazenar os valores contidos no UserDefaults
        var log = false
        var usuario : UsuarioMD?
        
        
        
        //Guardando os dados do UserDefaults nas variáveis
        if let logado = UserDefaults.standard.value(forKey: "logado") as? Bool {
            log = logado
        }
        if let usu = UserDefaults.standard.value(forKey: "usuario") as? Data {
            let decoder = JSONDecoder()
            do {
                usuario = try decoder.decode(UsuarioMD.self, from: usu)
            } catch {
                print("Erro: \(error)")
            }
        }

        //Fazendo a estrura condicional para checar se o usuario ja está no sistema
        if log {
            if usuario != nil {
         
                //Instanciando a MainViewController e redirecionando para la
                let entry = storyboard?.instantiateViewController(withIdentifier: "ControlerDePagsViewController") as! ControlerDePagsViewController
                entry.modalPresentationStyle = .fullScreen
                entry.usuario = usuario
                present(entry, animated: true)
            }
        }
    }

    
    @IBAction func entrarComEmailESenha(_ sender: Any) {
        
        //Transformando os textos contidos nas textViews em strings
        guard let iptEU = txtFieldEmailOuUsuario.text else { return }
        let txtIptEU = iptEU.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard let iptS = txtFieldSenha.text else { return }
        let txtIptS = iptS.trimmingCharacters(in: .whitespacesAndNewlines)
        
        //Criando a variável que vai receber o status do userDefaults para ver se o usuário pode continuar logado
        if let estaLogado = UserDefaults.standard.value(forKey: "logado") as? Bool {
            if !estaLogado {
                //Fazendo a condição de que se os campos estiverem vazios, nada acontecerá ao clicar e caso ao contrário, será feito a verificação de usuário
                if (txtIptEU != "" && txtIptS != "") {
                    //Fazendo o laço de repetição que vai percorrer todos usuário para verificar se algum coincide com o que foi digitado
                    for usuario in self.usuarios {
                        if(verificaLogin(emailOuUsuario: txtIptEU, senha: txtIptS, usuario: usuario)) {
                            
                            //Setando status do usuário para que de agora em diante ele esteja logado sem precisar logar novamente
                            userDefaults.setValue(true, forKey: "logado")
                            
                            //Setando variável do usuário no userDefaults
                            userDefaults.setValue(usuario, forKey: "usuario")
                            
                            //Instanciando a MainViewController e redirecionando para la
                            let entry = storyboard?.instantiateViewController(withIdentifier: "ControlerDePagsViewController") as! ControlerDePagsViewController
                            entry.modalPresentationStyle = .fullScreen
                            entry.usuario = usuario
                            present(entry, animated: true)
                        } else {
                            //Se tiver campos errados
                        }
                    }
                } else {
                    //Se tiver campos incompletos
                }
                
            }
        } else {
            
            //Fazendo a condição de que se os campos estiverem vazios, nada acontecerá ao clicar e caso ao contrário, será feito a verificação de usuário
            if (txtIptEU != "" && txtIptS != "") {
                //Fazendo o laço de repetição que vai percorrer todos usuário para verificar se algum coincide com o que foi digitado
                for usuario in self.usuarios {
                    if(verificaLogin(emailOuUsuario: txtIptEU, senha: txtIptS, usuario: usuario)) {
                        
                        //Setando status do usuário para que de agora em diante ele esteja logado sem precisar logar novamente
                        UserDefaults.standard.setValue(true, forKey: "logado")
                        
                        //Setando variável do usuário no userDefaults
                        do {
                            let encoder = JSONEncoder()
                            let newUsuario = try encoder.encode(usuario)
                            UserDefaults.standard.set(newUsuario, forKey: "usuario")
                        } catch {
                            print("Erro: \(error)")
                        }
                        
                        
                        //Instanciando a MainViewController e redirecionando para la
                        let entry = storyboard?.instantiateViewController(withIdentifier: "ControlerDePagsViewController") as! ControlerDePagsViewController
                        entry.modalPresentationStyle = .fullScreen
                        entry.usuario = usuario
                        present(entry, animated: true)
                    } else {
                        //Se tiver campos errados
                    }
                }
            } else {
                //Se tiver campos incompletos
            }
            
        }
        
        
        
        
    }
    
    @IBAction func direcionarPagCadastro(_ sender: Any) {
        //Instanciando a CadastroViewController e redirecionando para la
        let entry = storyboard?.instantiateViewController(withIdentifier: "CadastroViewController") as! CadastroViewController
        entry.modalPresentationStyle = .fullScreen
        present(entry, animated: true)
    }
    


}
