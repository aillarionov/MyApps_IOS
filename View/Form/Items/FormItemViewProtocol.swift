//
//  FormItemViewProtocol.swift
//  Informer
//
//  Created by Александр on 24.02.18.
//  Copyright © 2018 Александр. All rights reserved.
//

import UIKit

protocol FormItemViewProtocol {
    var data: FormItemData? { get set }
    var listController: UIViewController? { get set }
    func checkRequired()
}
