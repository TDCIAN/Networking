//
//  Request.swift
//  Networking
//
//  Created by APPLE on 2020/01/12.
//  Copyright © 2020 JeongminKim. All rights reserved.
//

import Foundation

let DidReceiveFriendsNotification: Notification.Name = Notification.Name("DidRecieveFriends")

func requestFriends() {
    guard let url: URL = URL(string: "https://randomuser.me/api/?results=20&inc=name,email,picture") else { return }
    
    let session: URLSession = URLSession(configuration: .default)
    
    // 이 변수의 뒤에 붙은 클로저는 요청에 대한 서버의 응답이 왔을 때 호출될 내용 -> 서버에서 보내준 데이터, 거기에 대한 응답, 오류
    let dataTask: URLSessionDataTask = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
        // 만약 오류가 발생했다면
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        // 받아온 데이터를 가지고 JSONDecoder를 사용해서 APIResponse 형식으로 디코드 한다
        guard let data = data else { return }
        
        do {
            let apiResponse: APIResponse = try JSONDecoder().decode(APIResponse.self, from: data)
            // 프렌즈에 디코드의 결과를 넣어주고
            NotificationCenter.default.post(name: DidReceiveFriendsNotification, object: nil, userInfo: ["friends":apiResponse.results])

        } catch (let err) {
            print(err.localizedDescription)
        }
    }
    // 데이터 태스크를 실행하고 서버에 요청하게 된다
    dataTask.resume()
}
