//
//  ApiProviderError.swift
//  DragonBall
//
//  Created by Juan Carlos Torrejón Cañedo on 3/3/24.
//

import Foundation

enum ApiProviderError: Error {
    case badURLRequest
    case tokenUnavailable
    case responseDecodingFailed
}
