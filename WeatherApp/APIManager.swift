//
//  APIManager.swift
//  WeatherApp
//
//  Created by Seren Sencer on 11.06.2019.
//  Copyright © 2019 Seren Sencer. All rights reserved.
//

import UIKit

class APIManager: UIViewController {
    
    static func request(url: URL?, completion: @escaping (_ response: Data?, _ error: Error?) -> Void) {
        if let url = url {
            let urlRequest = URLRequest(url: url)
            let session =  URLSession(configuration: URLSessionConfiguration.default)
            let task = session.dataTask(with: urlRequest) { (data, response, error) in
                DispatchQueue.main.async {
                    print("###### DEBUG: APIManager post with url \(url) ######")
                    completion(data, error)
                }
            }
            task.resume()
        }
    }
}
