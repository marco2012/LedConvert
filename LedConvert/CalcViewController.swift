//
//  CalcViewController.swift
//  LedConvert
//
//  Created by Marco on 15/09/2018.
//  Copyright © 2018 Vikings. All rights reserved.
//

import Eureka

class CalcViewController: FormViewController {
    
    var potenza:Double!    //Potenza (Watt) lampadina originale
    var colore:Double!     //Luce calda o luce fredda
    var lux:Double!        //Quantità di luce sviluppata dalla lampadina precedente
    var numero_lampadine:Double!
    var ore_giornaliere:Double!
    var costo_elettrico_medio:Double! // €/KWh
    let anno = 0.365

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let potenza_led_min     = (( potenza * lux / colore ) / 2.5).rounded()
        let potenza_led_max     = (( potenza * lux / colore ) / 1.7).rounded()
        
        let const               = numero_lampadine * ore_giornaliere * anno * costo_elettrico_medio

        let risparmio_eur_min   = ((potenza - potenza_led_max) * const)
        let risparmio_eur_max   = ((potenza - potenza_led_min) * const)
        let riparmio_eur_medio  = (risparmio_eur_min + risparmio_eur_max) / 2
        
        form +++ Section(
            header: "Potenza",
            footer: "Puoi utilizzare un dispositivo LED con potenza compresa tra questi due valori"
            )
            
            <<< LabelRow () {
                $0.title = "Potenza minima"
                $0.value = String(format: "%.0f", potenza_led_min) + " W"
        }
        
            <<< LabelRow () {
                $0.title = "Potenza massima"
                $0.value = String(format: "%.0f", potenza_led_max) + " W"
        }
        
        form +++ Section(
            header: "Risparmio",
            footer: "Risparmio annuo approssimato per \(String(format: "%.0f", numero_lampadine)) lampade LED accese per \(String(format: "%.0f", ore_giornaliere)) ore al giorno con un costo dell'energia elettrica medio di \(costo_elettrico_medio ?? 0.22)€/KWh"
            )
    
            <<< LabelRow () {
                $0.title = "Risparmio medio"
                $0.value = String(format: "%.2f", riparmio_eur_medio ) + " €"
            }
        
        form +++ Section(
            footer: "Le formule utilizzate sono tratte dagli studi degli scienziati della Lawrence Berkeley Laboratory sullo spettro luminoso"
            )
            <<< ButtonRow() { (row: ButtonRow) -> Void in
                row.title = "Maggiori Informazioni"
                }
                .onCellSelection { [weak self] (cell, row) in
                    UIApplication.shared.open(URL(string: "http://www.esllighting.com.au/pdfs/TheComingRevolutioninLightingPractice.pdf")!,
                                              options: [:],
                                              completionHandler: nil)
            }
        
    }

}
