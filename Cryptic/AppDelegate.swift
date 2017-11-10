//
//  AppDelegate.swift
//  Cryptic
//
//  Created by Maroof Khan on 10/11/2017.
//  Copyright © 2017 Maroof Khan. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    let kRefresh: TimeInterval = 4.5
    
    let rate = Coinbase.bitcoin
    var currency: Currency = .USD

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        update()
        Timer.scheduledTimer(withTimeInterval: kRefresh, repeats: true, block: update)
    }
    
    func update(with timer: Timer? = nil) {
        rate
            .success { response in
                DispatchQueue.main.async {
                    self.update(with: response)
                }
            }
            .failure { assertionFailure($0.localizedDescription) }
            .execute()
    }
    
    lazy var stausItem: NSStatusItem = {
        let bar: NSStatusBar = .system
        let item = bar.statusItem(withLength: NSStatusItem.variableLength)
        return item
    } ()
    
    lazy var bitcoin: NSImage? = {
        let image = #imageLiteral(resourceName: "bitcoin")
        image.size = .init(width: 15.0, height: 15.0)
        return image
    } ()
    
    func update(with response: Response) {
        guard let title = currency.format(from: response) else {
            assertionFailure("Oh my God! We are levitating!")
            return
        }
        
        let attributed: NSAttributedString = .init(string: title, attributes: [
            .foregroundColor: NSColor.controlTextColor,
            .font: NSFont.systemFont(ofSize: 14.0)
        ])
        let item = stausItem
        item.image = bitcoin
        item.button?.attributedTitle = attributed
    }
}
