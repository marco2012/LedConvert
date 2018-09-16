//
//  ViewController.swift
//  LedConvert
//
//  Created by Marco on 15/09/2018.
//  Copyright © 2018 Vikings. All rights reserved.
//

import Eureka

class ViewController: FormViewController {

    var potenza:Double?    //Potenza (Watt) lampadina originale
    var colore:Double?     //Luce calda o luce fredda
    var lux:Double?        //Quantità di luce sviluppata dalla lampadina precedente
    
    var numero_lampadine:Double?
    var ore_giornaliere:Double?
    var costo_elettrico_medio:Double? // €/KWh
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        form +++ Section("Potenza della lampadina da sostituire")
            
            <<< IntRow() {
                $0.title = "Potenza (Watt)"
                $0.placeholder = "W"
                $0.tag = "potenza"
            }
            
            +++ Section("Tipo di luce")
            <<< SegmentedRow<String>() {
                $0.options = ["Bianco caldo", "Bianco freddo"]
                $0.tag = "tipo_di_luce"
        }
        
        form +++ SelectableSection<ImageCheckRow<String>>("Tecnologia utilizzata", selectionType: .singleSelection(enableDeselection: false))
        let tecnologie = [
            "Incandescenza filamento",
            "Alogeni TH",
            "Sodio Bassa Pressione SOX-SON",
            "Sodio Alta Pressione (SAP)",
            "Alogenuri metallici (MH)",
            "Pulse start Metal Halide",
            "Tubi T12 standard",
            "Tubi T8 fluorescenti",
            "Fluorescenti Compatte"
        ]
        for option in tecnologie {
            form.last! <<< ImageCheckRow<String>(option){ lrow in
                lrow.title = option
                lrow.selectableValue = option
                lrow.value = nil
            }
        }
        
        form +++ Section("Calcolo Risparmio")
            <<< IntRow() {
                $0.title = "Lampadine LED disponibili"
                $0.value = 10
                $0.tag = "numero_lampadine"
            }
            <<< IntRow() {
                $0.title = "Ore di utilizzo giornaliere"
                $0.value = 8
                $0.tag = "ore_giornaliere"
            }
            <<< DecimalRow() {
                $0.title = "Costo elettricità (€/KWh)"
                $0.value = 0.22
                $0.tag = "costo_elettrico_medio"
            }
        
        form +++ Section()
            <<< ButtonRow() { (row: ButtonRow) -> Void in
                row.title = "Calcola"
                }
                .onCellSelection { [weak self] (cell, row) in
                    
                    let p: IntRow? = self?.form.rowBy(tag: "potenza")
                    
                    let t:SegmentedRow<String> = (self?.form.rowBy(tag: "tipo_di_luce"))!
                    
                    let n: IntRow? = self?.form.rowBy(tag: "numero_lampadine")
                    
                    let h: IntRow? = self?.form.rowBy(tag: "ore_giornaliere")
                    
                    let c: DecimalRow? = self?.form.rowBy(tag: "costo_elettrico_medio")
                    
                    if p?.value==nil || n?.value==nil || h?.value==nil || c?.value==nil || self?.lux==nil {
                        self?.showAlert(title: "Errore", message: "Compila tutti i campi")
                    } else {
                        self?.potenza               = Double((p?.value)!)
                        self?.colore                = (t.value=="Bianco caldo") ? 70.0 : 80.0
                        self?.numero_lampadine      = Double((n?.value)!)
                        self?.ore_giornaliere       = Double((h?.value)!)
                        self?.costo_elettrico_medio = Double((c?.value)!)

                        self?.performSegue(withIdentifier: "calculateSegue", sender: self)
                    }
                    
        }
                
    }
    
    // Imposta la variabile quando viene selezionato un valore
    override func valueHasBeenChanged(for row: BaseRow, oldValue: Any?, newValue: Any?) {
        if row.section === form[2] {
            let t = (row.section as! SelectableSection<ImageCheckRow<String>>).selectedRow()?.baseValue as? String
            switch t {
            case "Incandescenza filamento":
                lux = 20.0
            case "Alogeni TH":
                lux = 25.0
            case "Sodio Bassa Pressione SOX-SON":
                lux = 37.0
            case "Sodio Alta Pressione (SAP)":
                lux = 56.0
            case "Alogenuri metallici (MH)":
                lux = 89.0
            case "Pulse start Metal Halide":
                lux = 87.0
            case "Tubi T12 standard":
                lux = 66.0
            case "Tubi T8 fluorescenti":
                lux = 94.0
            case "Fluorescenti Compatte":
                lux = 68.0
            default:
                lux = 0
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "calculateSegue"{
            if let destinationVC = segue.destination as? CalcViewController {
                destinationVC.potenza               = potenza
                destinationVC.colore                = colore
                destinationVC.lux                   = lux
                destinationVC.numero_lampadine      = numero_lampadine
                destinationVC.ore_giornaliere       = ore_giornaliere
                destinationVC.costo_elettrico_medio = costo_elettrico_medio
            }
        }
    }
    
    func showAlert(title:String, message:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true)
        
    }
    
}
