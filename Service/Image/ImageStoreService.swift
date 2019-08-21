//
//  ImageStoreService.swift
//  Inform
//
//  Created by Александр on 19.03.18.
//  Copyright © 2018 Александр. All rights reserved.
//

import UIKit

class ImageStoreService {
    static let tmpImagesDir = "images/tmp/"
    static let permanentImagesDir = "images/perm/"
    static let systemImagesDir = "images/sys/"
    
    
    public static func isImageLoaded(fromUrl url: URL, orgId: Int?, storeType: ImageStoreType) -> Bool {
        let path = self.getStorePath(storeType) + String(orgId ?? 0) + "/"
        let fileName = self.generateFileName(url)
        let fileWithPath = self.fileWithPath(path: path, fileName: fileName)
        
        return self.isFileExists(fileWithPath: fileWithPath)
    }
    
    public static func getImageAsync(fromUrl url: URL, orgId: Int?, storeType: ImageStoreType, success: @escaping ((UIImage) -> Void), failure: @escaping ((Error) -> Void)) -> Cancelable {
        
        let cancelable = Cancelable {
            failure(ErrorCanceled())
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            if cancelable.isCanceled() { return }
            
            let path = self.getStorePath(storeType) + String(orgId ?? 0) + "/"
            let fileName = self.generateFileName(url)
            let fileWithPath = self.fileWithPath(path: path, fileName: fileName)
            
            if (self.isFileExists(fileWithPath: fileWithPath)) {
                // File already exists
                if cancelable.isCanceled() { return }
                
                if let image = UIImage(contentsOfFile: fileWithPath) {
                    success(image)
                } else {
                    failure(ImageServiceError.UnableToMakeImageFromFile)
                }

            } else {
                // File will loaded
                if cancelable.isCanceled() { return }
                
                let rc = self.retrieveImageAsync(
                    fromUrl: url,
                    success: { data in
                        if cancelable.isCanceled() { return }
                        
                        self.storeImage(toPath: path, fileName: fileName, data: data)

                        if cancelable.isCanceled() { return }

                        if let image = UIImage(data: data) {
                            success(image)
                        } else {
                            failure(ImageServiceError.UnableToMakeImageFromData)
                        }
                    },
                    failure: {
                        if cancelable.isCanceled() { return }
                        failure($0)
                    }
                )
                
                cancelable.addCancel{ rc.cancel() }
            }
            
        }
        
        return cancelable
        
    }
    
    public static func getImageSync(fromUrl url: URL, orgId: Int?, storeType: ImageStoreType) -> UIImage? {
        let path = self.getStorePath(storeType) + String(orgId ?? 0) + "/"
        let fileName = self.generateFileName(url)
        let fileWithPath = self.fileWithPath(path: path, fileName: fileName)
        
        if (self.isFileExists(fileWithPath: fileWithPath)) {
            // File already exists
            if let image = UIImage(contentsOfFile: fileWithPath) {
                return image
            } else {
                print("Unable to make image from file")
            }
        } else {
            // File will loaded
            do {
                let data = try Data(contentsOf: url)
                self.storeImage(toPath: path, fileName: fileName, data: data)
                return UIImage(data: data)
            } catch let error {
                print(error)
            }
        }
        
        return nil
    }
    
    static func clearImages(forOrg id: Int, storeType: ImageStoreType) throws {
        let path = self.getStorePath(storeType)
        
        if path != "" {
            let rootDir = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString)
            let dir = rootDir.appendingPathComponent(path)
            
            let fileManager = FileManager.default
            try fileManager.removeItem(atPath: dir)
        }
    }
    
    private static func getStorePath(_ storeType: ImageStoreType) -> String {
        switch storeType {
        case .Permanent: return ImageStoreService.permanentImagesDir
        case .System: return ImageStoreService.systemImagesDir
        case .Temporary: return ImageStoreService.tmpImagesDir
        default: return ImageStoreService.tmpImagesDir
        }
    }
    
    private static func generateFileName(_ url: URL) -> String {
        return url.absoluteString.MD5
    }
    
    private static func fileWithPath(path: String, fileName: String) -> String {
        let rootDir = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString)
        return rootDir.appendingPathComponent(path + fileName)
    }
    
    private static func isFileExists(fileWithPath: String) -> Bool {
        let fileManager = FileManager.default
        return fileManager.fileExists(atPath: fileWithPath)
    }
    
    private static func storeImage(toPath: String, fileName: String, data: Data) {
        let fileManager = FileManager.default
        
        let rootDir = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString)
        
        // Dir
        let dirPath = rootDir.appendingPathComponent(toPath)
        
        if !fileManager.fileExists(atPath: dirPath){
            try! fileManager.createDirectory(atPath: dirPath, withIntermediateDirectories: true, attributes: nil)
        }
        
        // File
        let filePath = rootDir.appendingPathComponent(toPath + fileName)
        
        fileManager.createFile(atPath: filePath as String, contents: data, attributes: nil)
    }
    
    private static func retrieveImageAsync(fromUrl url: URL, success: @escaping ((Data) -> Void), failure: @escaping ((Error) -> Void)) -> Cancelable {
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                failure(error)
                return
            }
            guard let data = data else {
                failure(ServiceDataError.NoData)
                return
            }
            
            success(data)
        }
        
        task.resume()
        
        return Cancelable {
            if task.state == .running || task.state == .suspended {
                task.cancel()
            }
        }
    }
    
}

