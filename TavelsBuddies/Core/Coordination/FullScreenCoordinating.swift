//
//  FullScreenCoordinating.swift
//  TavelsBuddies
//
//  Created by tarek on 24/09/2025.
//

import Foundation
import SwiftUI

protocol FullScreenCoordinating : AnyObject {
    associatedtype FullScreenCoverPage: Hashable
    associatedtype FullScreenCustomView : View
    
    func presentFullScreenCover(_ page: FullScreenCoverPage)
    func dismissFullScreenCover()
    func showFullScreenCover(_ page: FullScreenCoverPage) -> FullScreenCustomView
}
