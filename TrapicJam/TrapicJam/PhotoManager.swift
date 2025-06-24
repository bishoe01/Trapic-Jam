//
//  PhotoManager.swift
//  TrapicJam
//
//  Created by bishoe on 6/24/25.
//

import Photos
import SwiftUI

class PhotoManager: ObservableObject {
    @Published var photos: [PHAsset] = []
    @Published var isLoading = false
    @Published var authorizationStatus: PHAuthorizationStatus = .notDetermined
    
    init() {
        checkAuthorization()
    }
    
    func checkAuthorization() {
        authorizationStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        
        switch authorizationStatus {
        case .authorized, .limited:
            loadPhotos()
        case .notDetermined:
            requestAuthorization()
        default:
            break
        }
    }
    
    func requestAuthorization() {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] status in
            DispatchQueue.main.async {
                self?.authorizationStatus = status
                if status == .authorized || status == .limited {
                    self?.loadPhotos()
                }
            }
        }
    }
    
    func loadPhotos() {
        isLoading = true
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchOptions.fetchLimit = 100
        
        let allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        
        var photoAssets: [PHAsset] = []
        allPhotos.enumerateObjects { asset, _, _ in
            photoAssets.append(asset)
        }
        
        DispatchQueue.main.async {
            self.photos = photoAssets
            self.isLoading = false
        }
    }
}
