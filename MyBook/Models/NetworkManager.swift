//
//  NetworkManager.swift
//  MyBook
//
//  Created by imhs on 5/5/24.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private init() { }
    
    func searchBook(query: String, completion: @escaping (Result<Book, Error>) -> Void) {
        let url = "https://dapi.kakao.com/v3/search/book"
        let apiKey = "KakaoAK 81678f07fd14a9cb4ca23a7f40b6aa7d"
        
        // MARK: - 1. URL 객체 생성
        guard let url = URL(string: "\(url)?query=\(query)") else { return }
        
        // MARK: - 2. HTTP 요청 객체 생성
        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "Authorization")
        //request.allHTTPHeaderFields = ["Authorization": apiKey]
                
        // MARK: - 3. HTTP 요청 보내기
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            // MARK: - 4. 응답 처리
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                // 응답 코드가 성공 범위가 아닐 경우 처리
                return
            }

            guard let data = data else {
                // 데이터가 없을 경우 처리
                return
            }

            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(Book.self, from: data)
                // 파싱된 데이터(result)를 사용하여 작업
                completion(.success(result))
            } catch {
                // 데이터 파싱 실패 시 처리
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
