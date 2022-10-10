//
//  SettingViewController.swift
//  MOGMOG
//
//  Created by 石丸剣心 on 2022/10/06.
//

import UIKit

class SettingViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    let settingMenu = ["メールアドレス変更","ユーザーネーム変更"]
    
    @IBOutlet weak var setting_tableView: UITableView!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setting_tableView.delegate = self
        setting_tableView.dataSource = self
        
        setting_tableView.register(UINib(nibName: "SettingCell", bundle: nil), forCellReuseIdentifier: "settingCell")
        // Do any additional setup after loading the view.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = setting_tableView.dequeueReusableCell(withIdentifier: "settingCell") as! SettingCell
        
        cell.setting_label.text = self.settingMenu[indexPath.row]
        
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
            
            // メールアドレス変更
        case 0:
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mailChangeVC = storyboard.instantiateViewController(withIdentifier: "mailChangeVC") as! MailChangeViewController
            self.navigationController?.pushViewController(mailChangeVC, animated: true)
            
            // ユーザーネーム変更
        case 1:
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let nameChangeVC = storyboard.instantiateViewController(withIdentifier: "nameChangeVC") as! NameChangeViewController
            self.navigationController?.pushViewController(nameChangeVC, animated: true)
            
            
        default: break
            
        }
        
        
    }
    

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
