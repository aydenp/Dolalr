//
//  ViewController+TouchBar.swift
//  Dolalr
//
//  Created by Ayden Panhuyzen on 2020-01-09.
//  Copyright © 2020 Ayden Panhuyzen. All rights reserved.
//

import UIKit

// MARK: - Touch Bar Support

#if targetEnvironment(macCatalyst)
fileprivate let buttonGroupIdentifier = NSTouchBarItem.Identifier.init(rawValue: "Dolalr.ButtonGroup.TouchBardentifier")

extension ViewController {
    override func makeTouchBar() -> NSTouchBar? {
        let mainBar = NSTouchBar()
        mainBar.delegate = self
        mainBar.defaultItemIdentifiers = [.flexibleSpace, buttonGroupIdentifier, .flexibleSpace]
        mainBar.principalItemIdentifier = buttonGroupIdentifier
        return mainBar
    }
}

extension ViewController: NSTouchBarDelegate {
    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
        guard identifier == buttonGroupIdentifier, let (primary, secondary) = buttonTemplates else { return nil }
            
        let group = NSGroupTouchBarItem(identifier: identifier, items: [primary, secondary].enumerated().map {
            let buttonIdentifier = NSTouchBarItem.Identifier(rawValue: identifier.rawValue + String($0.offset))
            let item = NSButtonTouchBarItem(identifier: buttonIdentifier, title: $0.element.title, target: $0.element, action: #selector($0.element.performAction))
            item.isEnabled = $0.element.isEnabled
            if $0.offset == 0 { item.bezelColor = .systemBlue }
            return item
        })
        group.prefersEqualWidths = true
        group.preferredItemWidth = 90
        return group
    }
}
#endif
