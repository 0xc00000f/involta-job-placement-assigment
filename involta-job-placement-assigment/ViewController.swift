//
//  ViewController.swift
//  involta-job-placement-assigment
//
//  Created by Maxim Tsyganov on 07.05.2022.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray2

        let networkService = NetworkService()
        networkService.getMessages()
    }

}
