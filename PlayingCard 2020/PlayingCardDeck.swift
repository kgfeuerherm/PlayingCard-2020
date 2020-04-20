//
//  PlayingCardDeck.swift
//  PlayingCard 2020
//
//  Created by Karljürgen Feuerherm on 2020-04-17.
//  Copyright © 2020 Karljürgen Feuerherm. All rights reserved.
//

import Foundation

struct PlayingCardDeck
{
    // Assume we will allow outsiders to query the cards but not alter them.
    private( set ) var cards = [ PlayingCard ]()
    
    // The approach using an optional allows for attempted draws beyond the
    // end of the deck.
    //     It means that one will test for success after the fact, rather than
    // test for feasibility in advance; but since the function does an internal
    // test, this amounts to two tests where one would do.
    mutating func draw() -> PlayingCard?
    {
        if cards.count > 0
        {
            // As noted in Concentration 2020, Int now has a static random function.
            // This replaces 'at: cards.count.arc4random'.
// BUG CORRECTION: The previous version had a range 1 ... cards.count in the call
//                 which of course occasionally resulted in an out-of-bounds
//                 violation.
            return cards.remove(at: Int.random(in: 0 ..< cards.count) )
        }
        else
        {
            return nil
        }
    }
    
    init()
    {
        // Build the deck by looping through all possible cards by suit and rank.
        for suit in PlayingCard.Suit.all
        {
            for rank in PlayingCard.Rank.all
            {
                cards.append( PlayingCard( suit: suit, rank: rank ) )
            }
        }
        // In my view, building an ordered deck from which one draws a random card
        // is likley more computationally expensive than shuffling the deck once,
        // but this architecture does have the advantage that one can have an ordered deck
        // if desired.
        //     One could, of course, shuffle the deck later, as well.
    }
}
