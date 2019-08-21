//
//  SettingsCell.swift
//  Inform
//
//  Created by Александр on 01.04.2018.
//  Copyright © 2018 Александр. All rights reserved.
//

import UIKit

class SettingsCell: UITableViewCell, CommonTableViewCell {
    typealias D = (Settings, UINavigationController)
    
    static let nib = UINib(nibName: "SettingsCell", bundle: nil)
    static let cellIdentifier = "SettingsCell"
    
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var buttonChoose: UIButton!
    @IBOutlet weak var buttonSettings: UIButton!
    
    
    var cancelable: Cancelable?
    var data: Settings?
    var navigation: UINavigationController?
    
    static func getCellHeight() -> CGFloat {
        let imgAspect: CGFloat = 16 / 9
        
        let s = UIScreen.main.nativeScale
        let w = UIScreen.main.nativeBounds.width
        
        let imgH = (w - 10.0 * s) / imgAspect
        let h = imgH / s + 10.0/* outter */ + 10.0/* inner */ + 30.0/* button */
        
        return h
    }
    
    func fillData(_ data: (Settings, UINavigationController)) {
        self.data = data.0
        self.navigation = data.1
        
        self.picture.image = nil
        if let org = data.0.org {
            self.cancelable = ImageLoader.getTmpImage(imageView: self.picture, url: org.logo, orgId: data.0.id)
        } else {
            self.cancelable = nil
        }
    }

    
    @IBAction func choosePressed(_ sender: Any) {
        if let id = self.data?.id {
            _ = LocalDataStore.loadOrg(id, success: {}, failure: {_ in })
        }
        (UIApplication.shared.delegate as! AppDelegate).setOrgId(self.data?.id)
    }
    
    @IBAction func settingsPressed(_ sender: Any) {
        if let data = self.data, let navigation = self.navigation {
            let showUI = SettingsViewController(settings: data, navigation: navigation)
            navigation.pushViewController(showUI, animated: true)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
