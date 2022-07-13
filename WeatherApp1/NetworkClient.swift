//
//  NetworkClient.swift
//  WeatherApp1
//
//  Created by Colin Smith on 7/6/22.
//

import Foundation

class NetworkClient {
   
    
    /// Generic Network Request
    ///
    /// Parameters:
    ///
    ///  - URL is required.
    ///
    ///  - Query Items can be passed in to be appended if desired.
    ///
    /// Completes With:
    /// 
    /// Any Decodable Type
    /// 
    static func request<T: Decodable>(url: URL?, parameters: [URLQueryItem]? = nil, completion: @escaping (T) -> Void ) {
        //Build URL
        guard let url = url else { return }
        var urlcomponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        let apiQueryItem = URLQueryItem(name: "apikey", value: "0s7CyOVXseVfEWLTWgu8SQPbck6sAj9e")
        urlcomponents?.queryItems = [ apiQueryItem ]
        
        //Pass in any additional items to append to the query list
        if let parameters = parameters {
            urlcomponents?.queryItems?.append(contentsOf: parameters)
        }
        
        guard let finalURL = urlcomponents?.url else { return }
        
        //Make Request
        URLSession.shared.dataTask(with: finalURL) { requestData, requestResponse, requestError in

        //Response
            guard let response = requestResponse as? HTTPURLResponse, response.statusCode == 200  else {
                //Error
                if let requestError = requestError {
                    print(requestError.localizedDescription)
                }
                return
            }

        //Data
            if let requestData = requestData {
                 // parse JSON Response
                do {
                    completion( try JSONDecoder().decode(T.self, from: requestData) )
                } catch {
                    print("There was an error in the decoding process \(error)")
                }
                
            }
        }.resume()
        
    }
    
}


struct URLConstants {
    static let locationSearch = URL(string: "https://dataservice.accuweather.com/locations/v1/cities/geoposition/search")
}


