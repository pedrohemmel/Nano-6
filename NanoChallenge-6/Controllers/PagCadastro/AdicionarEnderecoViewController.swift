//
//  AdicionarEnderecoViewController.swift
//  NanoChallenge-6
//
//  Created by Pedro Henrique Dias Hemmel de Oliveira Souza on 25/07/22.
//

import UIKit
import MapKit
import CoreLocation
//import FloatingPanel

class AdicionarEnderecoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let auxVC = AuxAdicionarEnderecoViewController()
//        auxVC.delegate = self
//        let panel = FloatingPanelController()
//        panel.set(contentViewController: AuxAdicionarEnderecoViewController())
//        panel.addPanel(toParent: self)

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

extension AdicionarEnderecoViewController: AuxAdicionarEnderecoViewControllerDelegate {
    func auxAdicionarEnderecoViewController(_ vc: AuxAdicionarEnderecoViewController, didSelectLocationWith coordinate: CLLocationCoordinate2D?) {
        print("oi")
    }
    
    
}
