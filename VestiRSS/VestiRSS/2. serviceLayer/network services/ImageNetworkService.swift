//
//  ImageManager.swift
//  VestiRSS
//
//  Created by Элла Чурсина on 15.06.2020.
//  Copyright © 2020 Элла Чурсина. All rights reserved.
//

import UIKit

protocol ImageNetworkService {
    func downloadImage(with urlString: String, completionHandler: @escaping (UIImage?) -> Void)
}

final class ImageNetworkServiceImpl: ImageNetworkService {
    
    func downloadImage(with urlString: String, completionHandler: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString),
            let data = try? Data(contentsOf: url),
            let image = UIImage(data: data) else {
                return completionHandler(nil)
        }
        completionHandler(image)
    }
}
