//
//  PhotoGridView.swift
//  TrapicJam
//
//  Created by bishoe on 6/24/25.
//

import SwiftUI
import Photos

struct PhotoGridView: View {
    @StateObject private var photoManager = PhotoManager()
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationView {
            Group {
                if photoManager.isLoading {
                    ProgressView("사진 로딩 중...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if photoManager.authorizationStatus != .authorized && photoManager.authorizationStatus != .limited {
                    VStack(spacing: 20) {
                        Image(systemName: "photo.on.rectangle")
                            .font(.system(size: 80))
                            .foregroundColor(.gray)
                        
                        Text("갤러리 접근 권한이 필요합니다")
                            .font(.title2)
                        
                        Button("권한 허용") {
                            photoManager.requestAuthorization()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                } else if photoManager.photos.isEmpty {
                    Text("사진이 없습니다")
                        .font(.title2)
                        .foregroundColor(.gray)
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 2) {
                            ForEach(photoManager.photos.indices, id: \.self) { index in
                                PhotoThumbnailView(asset: photoManager.photos[index])
                                    .aspectRatio(1, contentMode: .fit)
                                    .clipped()
                            }
                        }
                        .padding(2)
                    }
                }
            }
            .navigationTitle("갤러리 (\(photoManager.photos.count))")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("새로고침") {
                        photoManager.loadPhotos()
                    }
                }
            }
        }
    }
}

