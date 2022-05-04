import Foundation
import SwiftUI

class LocalFileManager {
    
    static let instance = LocalFileManager()
    
    private init(){}
    
    func saveImage(image: UIImage, imageName: String, folderName: String){
        
        createFolder(folderName: folderName)
        
        guard let data = image.pngData(), let url = getURLofImage(imageName: imageName, folderName: folderName) else {return}
        
        do {
            try data.write(to: url)
        }catch{
            print("Error occured while saving image: \(error)")
        }
    }
    
    private func createFolder(folderName: String){
        guard let folderURL = getURLofFolder(folderName: folderName) else {
            return
        }
        
        if !FileManager.default.fileExists(atPath: folderURL.path){
            do {
                try FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: true, attributes: nil)
            }catch {
                print("Error creating directory for images: \(folderName). \(error)")
            }
        }
    }
    
    private func getURLofFolder(folderName: String) -> URL? {
        guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else{
            return nil
        }
        
        return url.appendingPathComponent(folderName)
    }
    
    private func getURLofImage(imageName: String, folderName: String) -> URL? {
        guard let folderURL = getURLofFolder(folderName: folderName) else {
            return nil
        }
        
        return folderURL.appendingPathComponent(imageName + ".png")
    }
    
    func getImage(imageName: String, folderName: String) -> UIImage? {
        guard let url = getURLofImage(imageName: imageName, folderName: folderName), FileManager.default.fileExists(atPath: url.path) else {
            return nil
        }
        
        return UIImage(contentsOfFile: url.path)
    }
    
}
