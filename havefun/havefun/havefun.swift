//
//  havefun.swift
//  havefun
//
//  Created by PanDapao on 2021/10/29.
//  Copyright © 2021 PanDapao. All rights reserved.
//

import Foundation

struct Card
{
    var identifier: Int //卡片标识
    var isFaceUp: Bool = false
    static var identiferFactory = 0
    
    static func getUniqueIdentifier()->Int
    {
        identiferFactory += 1
        return identiferFactory
    }
    init()
    {
        self.identifier = Card.getUniqueIdentifier()
    }
}

class havefun
{
    var cards : [Card]
    init(numberOfCards : Int)
    {
        cards = [Card]()
        for _ in 0..<numberOfCards
        {
            let card = Card()
            cards += [card]
        }
    }
    
    func UptheCard(at index : Int)
    {
        cards[index].isFaceUp = true
    }
    
    func DowntheCard(at index : Int)
    {
        cards[index].isFaceUp = false
    }
    
    func start_init()
    {
        for i in 0...cards.count - 1
        {
            cards[i].isFaceUp = false
        }
    }
}
