//
//  NetworkService.swift
//  involta-job-placement-assigment
//
//  Created by Maxim Tsyganov on 07.05.2022.
//

import Foundation

class NetworkService {

    private var urlString = "https://numero-logy-app.org.in/getMessages?offset=0"

    func getMessages() {
        guard let url = URL(string: urlString) else { return }

        let session = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("There was an error: \(error.localizedDescription)")
                return
            }
            do {
                let jsonRes = try? JSONDecoder().decode(Result.self, from: data!)
            }
            catch {
                print("Error")
            }
        }
        session.resume()
    }

}
