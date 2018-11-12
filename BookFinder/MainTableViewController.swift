//
//  MainTableViewController.swift
//  BookFinder
//
//  Created by D7702_10 on 2018. 11. 12..
//  Copyright © 2018년 jik. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {
    var items:[Any]?
    
    let appKey = "7eb586ed14744bbb8028c7f752590443"
    override func viewDidLoad() {
        super.viewDidLoad()
        search(query: "가을", page: 1)
    }

    
    // 외부와 내부가 query와 page로 같다
    // ex) query q 로할 경우 외부는 query 내부는 q
    // search에서 요청
    func search(query:String, page:Int) {
        let str = "https://dapi.kakao.com/v3/search/book?query=\(query)&page=\(page)" as NSString
        // 원래 str이 String인데 NSString으로 변환 해줌
        
        if let strURL = str.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed){
        
            //url 만들고
        if let url = URL(string: strURL){
            //url로 request 만들고
            var request = URLRequest(url: url)
            request.addValue("KakaoAK \(appKey)" , forHTTPHeaderField:  "Authorization")
            //세션 만들고
            let session = URLSession.shared
            //task에 handler 불러주고
            let task = session.dataTask(with: request, completionHandler: handler)
            task.resume()
        }
            
        }
    }
    func handler(data:Data?, response:URLResponse?, error:Error?) -> Void {
        if error != nil { return }
        
        if let dat = data {
            do {
               if let dic = try JSONSerialization.jsonObject(with: dat, options: []) as? [String:Any]{
                if let books = dic["documents"] as? [Any] {
                    print(books)
                    items = books
                    DispatchQueue.main.async {
                       self.tableView.reloadData()
                    }
                }
            }
            } catch {
                print("parsing error")
            }
        }
        
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if let books = items {
            return books.count
        } else {
            return 0
        }
    }

    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if let items1 = items {
            if let book = items1[indexPath.row] as? [String:Any] {
                  cell.textLabel?.text = book["title"] as? String
                 //Any타입을 String으로 변환
            }
            
          
        }
        
        
        
        // Configure the cell...

        return cell
    }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
