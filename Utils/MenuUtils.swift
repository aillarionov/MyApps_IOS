//
//  MenuUtils.swift
//  Inform
//
//  Created by Александр on 26.03.18.
//  Copyright © 2018 Александр. All rights reserved.
//

import UIKit

class MenuUtils {

    var catalogs: [Int: Catalog] = [:]
    
    public func generateMenu(_ orgId: Int, success: @escaping (([UINavigationController]) -> Void),  failure: @escaping ((Error) -> Void)) -> Cancelable {
        
        let cancelable = Cancelable { failure(ErrorCanceled()) }
        
        self.catalogs = [:]
        for catalog in CatalogDAO(context: Globals.getViewContext()).list(forOrg: orgId) {
            self.catalogs[catalog.id] = catalog
        }
        
        let gi = LocalDataStore.getMenuItems(
            orgId: orgId,
            context: Globals.getViewContext(),
            success: { menuItems in
                if cancelable.isCanceled() { return }
                
                var buttons: [UINavigationController] = []
                var menuButtons: [UIViewController] = []
                
                // Menu button
                let menuTitle = NSLocalizedString("Menu", comment: "Name of menu button on main screen")
                let menu = UINavigationController()
                menu.tabBarItem.title = menuTitle
                menu.tabBarItem.image = #imageLiteral(resourceName: "menu")
                
                // My Apps ui
                let settingsTitle = NSLocalizedString("My applications", comment: "Name of settings button on main screen")
                let settingsUI = SettingsListViewController(navigation: menu)
                settingsUI.title = settingsTitle
                settingsUI.tabBarItem.title = settingsTitle
                settingsUI.tabBarItem.image = #imageLiteral(resourceName: "setting")
                menuButtons.append(settingsUI)
                
                // Items
                var i: Int = 0
                for menuItem in menuItems {
                    if cancelable.isCanceled() { return }
                    
                    do {
                        if i < 4 {
                            let nav = UINavigationController()
                            nav.tabBarItem.title = menuItem.name
                            nav.tabBarItem.image = IconUtils.getIconByName(menuItem.icon)
                            
                            let ui = try self.generateMenuItem(menuItem, navigation: nav)
                            ui.title = menuItem.name
                            nav.viewControllers = [ui]
                            
                            buttons.append(nav)
                        } else {
                            let ui = try self.generateMenuItem(menuItem, navigation: menu)
                            ui.title = menuItem.name
                            ui.tabBarItem.title = menuItem.name
                            ui.tabBarItem.image = IconUtils.getIconByName(menuItem.icon)
                            
                            menuButtons.append(ui)
                        }
                        
                        i += 1
                    } catch let error {
                        print(error)
                    }
                }
                
                
                
                // AboutApp ui
                let aboutAppTitle = NSLocalizedString("Callback", comment: "Name of callback button on main screen")
                let aboutAppUI = AboutAppViewController(navigation: menu)
                aboutAppUI.title = aboutAppTitle
                aboutAppUI.tabBarItem.title = aboutAppTitle
                aboutAppUI.tabBarItem.image = #imageLiteral(resourceName: "exhibition")
                menuButtons.append(aboutAppUI)
                
                // Menu ui
                let menuView = MenuListViewController(items: menuButtons, navigation: menu)
                menuView.title = menuTitle
                menu.viewControllers = [menuView]
               
                
                buttons.append(menu)
                
                if cancelable.isCanceled() { return }
                
                success(buttons)
            },
            failure: { failure($0) }
        )
        
        cancelable.addCancel {
            gi.cancel()
        }
        
        return cancelable
    }
    
    private func generateMenuItem(_ menuItem: MenuItem, navigation: UINavigationController) throws -> UIViewController {
        switch menuItem.type {
        
        case .Standart:
            return try self.generateStandart(menuItem, navigation: navigation)
        
        case .Form:
            return try self.generateForm(menuItem, navigation: navigation)
        
        case .Catalog:
            return try self.generateCatalog(menuItem, navigation: navigation)
        
        }
    }
    
    private func generateStandart(_ menuItem: MenuItem, navigation: UINavigationController) throws -> UIViewController {

        guard let cls = menuItem.params["cls"]?.getString() else { throw MenuItemGenerateError("No cls in menuItem params", menuItem) }
        
        guard let menuItemCls = MenuItemCls(rawValue: cls) else { throw MenuItemGenerateError("Unknown cls [" + cls + "]", menuItem) }

        switch menuItemCls {
        
        case .About:
            guard let catalogId = menuItem.params["catalog"]?.getInt() else { throw MenuItemGenerateError("No catalog in menuItem params", menuItem) }
            return AboutViewController(catalogId: catalogId, navigation: navigation)
          
        case .Favorites:
            return FavoriteListViewController(orgId: menuItem.orgId, navigation: navigation)

        case .Search:
            return SearchListViewController(orgId: menuItem.orgId, navigation: navigation)

        case .Map:
            return MapViewController(params: menuItem.params, navigation: navigation)
           
        case .Url:
            guard let url = menuItem.params["url"]?.getString() else { throw MenuItemGenerateError("No url in menuItem params", menuItem) }
            
            return URLViewController(url: url, navigation: navigation)
            
        case .Plan:
            guard let plans = menuItem.params["plans"]?.getString() else { throw MenuItemGenerateError("No plans in plan", menuItem) }
            
            return PlanViewController(orgId: menuItem.orgId, params: plans, navigation: navigation)
            
        case .Ticket:
            return SimpleTicketViewController(orgId: menuItem.orgId, navigation: navigation)
        
        }
    }

    private func generateForm(_ menuItem: MenuItem, navigation: UINavigationController) throws -> UIViewController {
        guard let formId: Int = menuItem.params["form"]?.getInt() else { throw MenuItemGenerateError("No form in menuItem params", menuItem) }
        
        return FormViewController(formId: formId, navigation: navigation)
    }

    private func generateCatalog(_ menuItem: MenuItem, navigation: UINavigationController) throws -> UIViewController {
        guard let catalogId: Int = menuItem.params["catalog"]?.getInt() else { throw MenuItemGenerateError("No catalog in menuItem params", menuItem) }
        
        guard let catalog = self.catalogs[catalogId] else { throw MenuItemGenerateError("Catalog not found", menuItem) }
        
        switch catalog.type {
            
        case .Item:
            return CatalogItemListViewController(catalogId: catalogId, navigation: navigation)
            
        case .Member:
            return CatalogMemberListViewController(catalogId: catalogId, navigation: navigation)
            
        case .Image:
            return CatalogImageListViewController(catalogId: catalogId, navigation: navigation)
            
        case .News:
            return CatalogNewsListViewController(catalogId: catalogId, navigation: navigation)
            
        }
    }
}
