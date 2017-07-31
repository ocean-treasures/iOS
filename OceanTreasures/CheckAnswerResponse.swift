//
//  CheckAnswerResponse.swift
//  OceanTreasures
//
//  Created by Zahari on 7/27/17.
//  Copyright © 2017 OceanTreasures. All rights reserved.
//

import Foundation

class CheckAnswerResponse {
    var word: String?
    var correct: Bool?    
    var progress: MyProgress?
    
    class func checkAnswer(word: NextWordResponse, pic: Picture, completion: @escaping (CheckAnswerResponse) -> ()) {
        guard let url = URL(string: URLs.postRequest.rawValue) else { return }
        
        let parameters = ["word_id": word.word?.id, "pic_id": pic.id]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                    var data = json as! [String: AnyObject]
                    
                    guard let correct = data["correct"] as? Bool else { return }
                    
                    let progressJson = data["progress"] as? [String: Int]
                    let progress = MyProgress(cur: progressJson?["current"], max: progressJson?["max"])
                    let word = data["word"]
                    
                    completion(CheckAnswerResponse(word: word as? String, correct: correct, progress: progress))
                } catch {
                    print(error)
                }
            }
            }.resume()
    }
    
    init(word: String?, correct: Bool?, progress: MyProgress?) {
        self.word = word
        self.correct = correct
        self.progress = progress
    }
}
