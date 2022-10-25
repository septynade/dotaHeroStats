//
//  NetworkManager.swift
//  AdeSeptian
//
//  Created by Ade Septian on 22/10/22.
//

import Combine
import Foundation

    
protocol NetworkService {
    func request<T:Decodable>(expecting: T.Type) -> AnyPublisher<T, NetworkError>
}

final class NetworkManager: NetworkService {
    private func url() -> URL? {
        let url = URL(string: "https://api.opendota.com/api/herostats")
        return url
    }
    
    
    public func request<T>(expecting: T.Type) -> AnyPublisher<T, NetworkError> where T: Decodable {
        guard let url = url() else {
            return AnyPublisher(Fail(error: NetworkError.invalidURL))
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { output in
                if let httpResponse = output.response as? HTTPURLResponse {
                    let statusCode = httpResponse.statusCode
                    switch statusCode {
                    case 200...299:
                        return output.data
                    case 400...499:
                        throw NetworkError.clientError
                    case 500...599:
                        throw NetworkError.serverError
                    default:
                        throw NetworkError.dataTaskError
                    }
                } else {
                    throw NetworkError.invalidResponse
                }
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError({ error in
                if let error = error as? NetworkError {
                    return error
                } else {
                    if error.localizedDescription.contains("offline") {
                        return NetworkError.connectionError
                    } else {
                        return NetworkError.unknownError
                    }
                }
            })
            .eraseToAnyPublisher()
    }
}
