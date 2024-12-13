//
//  NetworkStorage.swift
//  swift-snapshot-testing
//
//  Created by Macbook on 2024-12-11.
//

import Foundation
import XCTest

extension FileManager{
  
  func createFile(
    atURL url: URL,
    contents data: Data,
    attributes attr: [FileAttributeKey : Any]? = nil
  ) -> Bool{
    if(url.isFileURL){
      return createFile(atPath: url.path, contents: data, attributes: attr);
    }else{
      return true;
    }
  }
  
  func createDirectory(
    atURL url : URL,
    withIntermediateDirectories withIntermediates: Bool
  ) throws {
    if(url.isFileURL){
      return try createDirectory(
        at: url,
        withIntermediateDirectories: withIntermediates
      )
    }else{
      
    }
  }
  
  
  func fileExists(atURL url: URL) -> Bool{
    if(url.isFileURL){
      return fileExists(atPath: url.path);
    }else{
      do{
        let data = try Data(contentsOf: url)
        return data.count > 0;
      }catch{
        return false;
      }
    }
  }
  
}


extension Data{
  
  func write(atURL url : URL) throws {
    if(url.isFileURL){
      return try write(to: url);
    }else{
      
      var error: Error?
      let uploadScreenshot = XCTestExpectation(
        description: "Uploading Screenshot: \(url.absoluteString)"
      )
      var request = URLRequest(url: url)
      request.httpBody = self;
      request.httpMethod = "POST"
      
      URLSession.shared.dataTask(with: request){
        error = $2
        uploadScreenshot.fulfill()
      }.resume()
      
      let result = XCTWaiter.wait(for: [uploadScreenshot], timeout: 10)
      
      if error != nil{
        throw error!;
      }
    }
  }
}
