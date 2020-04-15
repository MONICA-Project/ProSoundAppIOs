//
//  AsyncTask.swift
//  EiB Solar
//
//  Created by Daniel Eriksson on 14/09/15.
//  Copyright (c) 2015 Daniel Eriksson. All rights reserved.
//

import UIKit

class AsyncTask: NSObject {

    private static let baseStart = "https://portal.monica-cloud.eu/"
    private static let baseEnd = "/cop/api/"

    
    func jsonFromUrl(_ strUrl: String, postBody:Dictionary<String, Any>=Dictionary(), method:String?=nil, completion: @escaping (_ result: Any?) -> Void) {
        
        let escUrl = strUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!//.replacingOccurrences(of: "+", with: "%2B")// '+'
        print("LOADING:"+escUrl)
        let event = (UserDefaults.standard.object(forKey: "eventNameEndpoint") as? String) ?? "ROSKILDE"
        let url = URL(string: AsyncTask.baseStart + event + AsyncTask.baseEnd + escUrl)
        let session = URLSession.shared
        var req = URLRequest(url: url!)
        req.setValue("6e1c06ad-0be8-42bf-8033-93fada21d3bf", forHTTPHeaderField: "Authorization")

        if let postString = postData(dictionary: postBody) {
            req.setValue("application/json-patch+json", forHTTPHeaderField: "Content-Type")
            req.setValue("application/json", forHTTPHeaderField: "Accept")
            req.httpMethod = "POST"
            req.httpBody = postString.data(using: String.Encoding.utf8)
        }
        req.httpMethod = method ?? req.httpMethod
        let task = session.dataTask(with: req, completionHandler: { (data:Data?, response:URLResponse?, error:Error?) -> Void in
            //print(NSString(data: data ?? NSData(), encoding: NSUTF8StringEncoding))
            let toLog = NSString(data: data ?? Data(), encoding: String.Encoding.utf8.rawValue)

            var retObj: Any? = "ERR" as Any?
            do {
                let status = (response as? HTTPURLResponse)?.statusCode
                print("response status: + " + String(status ?? 0))
 
                NSLog("Resp len:" + String(String(describing: toLog).characters.count))
                retObj = try JSONSerialization.jsonObject(with: data ?? Data(), options: JSONSerialization.ReadingOptions.mutableContainers)
            } catch _ as NSError {
                NSLog("CATCH, converting JSON to string")
                retObj = (NSString(data: data ?? Data(), encoding: String.Encoding.utf8.rawValue))
            } catch {
                NSLog("FATAL ERROR")
                fatalError()
            }
            completion(retObj)

        })
        
        task.resume()
    }
    func postData(dictionary:Dictionary<String, Any>) -> String? {
        if dictionary.count == 0{
            return nil
        }
        if let theJSONData = try? JSONSerialization.data(
            withJSONObject: dictionary,
            options: []) {
            let theJSONText = String(data: theJSONData,
                                     encoding: .ascii)
            return theJSONText
            
        }
        return nil
    }
}
