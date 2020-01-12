//
//  ViewController.swift
//  Networking
//
//  Created by APPLE on 2020/01/12.
//  Copyright © 2020 JeongminKim. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    let cellIdentifier:String = "friendCell"
    var friends: [Friend] = [] // 받아온 친구 정보

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 셀을 디큐 해와서 친구 정보를 불러오고
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath)
        
        let friend: Friend = self.friends[indexPath.row]
        // 친구의 정보를 레이블에 넣어준다
        cell.textLabel?.text = friend.name.full
        cell.detailTextLabel?.text = friend.email
        // 셀이 재사용 되기 전에 해당 셀의 이미지를 없애줘야 재사용할 수 있다
        cell.imageView?.image = nil
        
        // 이미지뷰에 URL을 통해 불러온 이미지를 넣어줄 것
        // 글로벌큐 -> 백그라운드 등 아무데서나 동작을 하게 될 기본적으로 제공하는 백그라운드 큐
        DispatchQueue.global().async {
            guard let imageURL: URL = URL(string: friend.picture.thumbnail) else { return }
            guard let imageData: Data = try? Data(contentsOf: imageURL) else { return }
            
            DispatchQueue.main.async {
                
                // 데이터가 받아지는 도중 사용자가 테이블뷰를 움직여 인덱스패스가 바뀌는 경우를 대비하는 코드
                if let index: IndexPath = tableView.indexPath(for: cell) {
                    // 만약 인덱스의 로우가 지금 현재 인덱스 패스와 같다면
                    if index.row == indexPath.row {
                        // 셀에다가 이미지를 세팅해달라
                        cell.imageView?.image = UIImage(data: imageData)
                    }
                }
                
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 노티피케이션센터에 노티피케이션을 듣겠다고 알린다
        // 어떤 메소드를 통해서 들을 것인가(didReceiveFriendsNotification(_:))
        // 노티피케이션이 발생하면 메소드를 통해서 알려달라
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveFriendsNotification(_:)), name: DidReceiveFriendsNotification, object: nil)
    }
    
    @objc func didReceiveFriendsNotification(_ noti: Notification) {
        
        guard let friends: [Friend] = noti.userInfo?["friends"] as? [Friend] else { return }
        self.friends = friends
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        requestFriends()

    }


}

