//
//  ImageManager.swift
//  VestiRSS
//
//  Created by Элла Чурсина on 15.06.2020.
//  Copyright © 2020 Элла Чурсина. All rights reserved.
//

import UIKit

final class ImageManager {
    
    private func downloadImage(with urlString: String, completionHandler: @escaping (UIImage) -> Void) {
        DispatchQueue.global().async {
            guard let url = URL(string: urlString),
                let data = try? Data(contentsOf: url),
                let image = UIImage(data: data) else {
                    return
            }
            completionHandler(image)
        }
    }
    
}
