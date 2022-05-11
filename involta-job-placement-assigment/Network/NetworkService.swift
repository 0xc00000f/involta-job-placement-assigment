//
//  NetworkService.swift
//  involta-job-placement-assigment
//
//  Created by Maxim Tsyganov on 07.05.2022.
//

import Foundation

enum NetworkServiceError: Error {
    case noData
}

class NetworkService {

    private var urlString = "https://numero-logy-app.org.in/getMessages?offset="

    func getMessages(offset: Int, completion: @escaping ([String], Error?) -> Void) {
        guard let url = URL(string: urlString + "\(offset)") else { return }

        let session = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("There was an error: \(error.localizedDescription)")
                completion([], error)
                return
            }
            do {
                guard let data = data else {
                    completion([], NetworkServiceError.noData)
                    return
                }
                let jsonRes = try JSONDecoder().decode(Result.self, from: data)
                completion(jsonRes.result, nil)
            }
            catch {
                completion([], error)
            }
        }
        session.resume()
    }

}
