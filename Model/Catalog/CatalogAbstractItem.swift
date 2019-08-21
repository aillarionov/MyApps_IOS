//
//  CatalogAbstractItem.swift
//  Inform
//
//  Created by Александр on 29.03.2018.
//  Copyright © 2018 Александр. All rights reserved.
//


protocol CatalogAbstractItem {

    var id: String { get }
    var itemId: Int  { get }
    var orgId: Int  { get }
    var catalogId: Int  { get }
    var order: Int  { get }
    
    var pictures: [Picture] { get }
    
    var favorite: Bool  { get }
    
    var title: String  { get }
    var catalogType: CatalogType  { get }
    
}
