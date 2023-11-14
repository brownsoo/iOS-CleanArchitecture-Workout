//
//  AppNotification.swift
//  Shared
//
//  Created by hyonsoo on 11/13/23.
//

import Foundation

public class AppNotification {
    public static let FavoritesChanged = Notification.Name("FavoritesChanged")
    
    public static let shared = AppNotification()
    
    private init() {}
    
    public func notifyFavoritesChanged(_ changes: FavoritesChanges) {
        NotificationCenter.default.post(name: AppNotification.FavoritesChanged,
                                        object: changes)
    }
}
