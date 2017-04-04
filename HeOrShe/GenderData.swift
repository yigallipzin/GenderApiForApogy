//
//  GenderData.swift
//  HeOrShe
//
//  Created by Yigal on 2/26/17.
//  Copyright © 2017 Yigal. All rights reserved.
//

import UIKit

enum SerializationError: Error {
    case missing(String)
    case invalid(String, Any)
}

struct GenderData
{
    var name: String = ""
    var gender: String = ""
    var samples: Int = 0
    var accuracy: Int = 0
    var duration: String = ""
    
    private init(){}
    static var instance = GenderData()
    
    static func GetGender(name: String, completion: @escaping () -> Void)
    {
        guard let safeName = name.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        guard let url = URL(string: "https://gender-api.com/get?name=\(safeName)&key=DKJatPQQqJyFYNPRjN")
        else {return}

        URLSession.shared.dataTask(with: url, completionHandler: {
            (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            else
            {
                do {
                    if let data = data,
                        let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    {
                        try GenderData.updateInstance(json: json!)
                    }
                
                    DispatchQueue.main.async {
                        completion()
                    }
                }
                catch{
                    print("error in JSONSerialization")
                }
        }
        }).resume()
    }
    static func updateInstance(json: [String: Any]) throws
    {
        guard let jsonName = json["name"] as? String else {
            throw SerializationError.missing("name")
        }
        guard let jsonGender = json["gender"] as? String else {
            throw SerializationError.missing("gender")
        }
        guard let jsonSamples = json["samples"] as? Int else {
            throw SerializationError.missing("samples")
        }
        guard let jsonAccuracy = json["accuracy"] as? Int else {
            throw SerializationError.missing("accuracy")
        }
        guard let jsonDuration = json["duration"] as? String else {
            throw SerializationError.missing("duration")
        }
        
        instance.name = jsonName
        instance.gender = jsonGender
        instance.samples = jsonSamples
        instance.accuracy = jsonAccuracy
        instance.duration = jsonDuration
    }

    mutating func resetInstance()
    {
        name.removeAll()
        gender.removeAll()
        samples = 0
        accuracy = 0
        duration.removeAll()
    }
}
