//
//  HistoryViewController.swift
//  Syllabite UI & Package Testing
//
//  Created by Anthony Foli on 12/26/21.
//

import UIKit

class HistoryViewController: UIViewController {
    
    @IBOutlet var myLabel: UILabel!
    let otherVC = ViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.myLabel.text = readyWords  
        // Do any additional setup afterr loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.myLabel.text = readyWords
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
