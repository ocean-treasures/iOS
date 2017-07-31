//
//  NextWordResponse.swift
//  test
//
//  Created by Zahari on 7/26/17.
//  Copyright © 2017 Zahari. All rights reserved.
//

import Foundation

class NextWordResponse {
    var progress: MyProgress?
    var word: WordDetails?
    var pictures: [Picture]?
    
    class func getData(completion: @escaping (NextWordResponse) -> ()) {
        guard let myUrl = URL(string: URLs.getRequest.rawValue) else { return }
        var request = URLRequest(url: myUrl)
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest) {data, response, error in
            
            if error != nil {
                print(error ?? "Unknown error")
                return
            }
            else {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                    
                    var data: [String: AnyObject]
                    
                    data = json as! [String: AnyObject]
                    
                    let picturesJson = data["pictures"] as? [[String: AnyObject]]
                    
                    let progressJson = data["progress"] as? [String: Int]
                    
                    let wordJson = data["word"] as? [String: AnyObject]
                    
                    var pictures: [Picture] = []
                    
                    let progress = MyProgress(cur: progressJson?["current"], max: progressJson?["max"])
                    
                    let word = WordDetails(word: wordJson?["word"] as? String, id: wordJson?["id"] as? Int)
                    
                    picturesJson?.forEach({ (pic) in
                        let curPic = Picture(id: pic["id"] as? Int, url: pic["url"] as? String)
                        pictures.append(curPic)
                    })
        
                    completion(NextWordResponse(progress: progress, word: word, pictures: pictures))
                }
                catch let jsonError {
                    print(jsonError)
                }
            }
        }
        dataTask.resume()
    }

    init(progress: MyProgress?, word: WordDetails?, pictures: [Picture]?) {
        self.progress = progress
        self.word = word
        self.pictures = pictures
    }
}
