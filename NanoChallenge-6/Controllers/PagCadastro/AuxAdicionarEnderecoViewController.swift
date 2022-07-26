//
//  AuxAdicionarEnderecoViewController.swift
//  NanoChallenge-6
//
//  Created by Pedro Henrique Dias Hemmel de Oliveira Souza on 25/07/22.
//

import UIKit
import CoreLocation

protocol AuxAdicionarEnderecoViewControllerDelegate: AnyObject {
    func auxAdicionarEnderecoViewController(_ vc: AuxAdicionarEnderecoViewController, didSelectLocationWith coordinate: CLLocationCoordinate2D?)
}

class AuxAdicionarEnderecoViewController: UIViewController {

    weak var delegate : AuxAdicionarEnderecoViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
