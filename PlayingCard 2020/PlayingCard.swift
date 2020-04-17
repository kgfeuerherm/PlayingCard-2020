//
//  PlayingCard.swift
//  PlayingCard 2020
//
//  Created by Karljürgen Feuerherm on 2020-04-17.
//  Copyright © 2020 Karljürgen Feuerherm. All rights reserved.
//

import Foundation

// Conformance to protocol 'CustomStringConvertible' allows for a convenient
// export of a descriptoni of an item.
struct PlayingCard  :   CustomStringConvertible
{
    var suit            :   Suit     // Suit and Rank are defined below.
    
    var rank            :   Rank
    
    var description: String
    {
        // Inverted from the lecture to conform to the more typical format.
        return "\( suit )\( rank )"
    }

    // Showcase enum with 'raw values'.
    enum Suit           :   String, CustomStringConvertible
    {
        case clubs      =   "♣️"
        case spades     =   "♠️"
        case hearts     =   "♥️"
        case diamonds   =   "♦️"
        
        static var all  :   [ Suit ]
        {
            // It is necessary to type the array explicitly, since any of the enum
            // cases could potentially be ambiguous; but once the type has been specified,
            // it is no longer necessary to repeat it.
            return [ Suit.clubs, .spades, .hearts, .diamonds ]
        }
        
        var description: String
        {
            return rawValue
        }
    }
    
    // How to define Rank the 'right' way:
//    enum Rank           :   Int
//    {
//        case two
//        case three
//        case four
//        case five
//        case six
//        case seven
//        case eight
//        case nine
//        case ten
//        case jack
//        case queen
//        case king
//        case ace        // In the lecture, ace was placed below two.
//    }
    
    // But for the purposes of demonstration and compatibility with lecture 5:
    enum Rank           :   CustomStringConvertible
    {
        case ace
        case face( String ) // "J", "Q", or "K"
        case numeric( Int ) // Self-explanatory.
        
        var order       :   Int
        {
            // Simple way of converting from the internal enum case to an external value.
            switch self
            {
            case .ace                                   :   return 1
            case .numeric( let pips )                   :   return pips
            case .face( let kind ) where kind == "J"    :   return 11
            case .face( let kind ) where kind == "Q"    :   return 12
            case .face( let kind ) where kind == "K"    :   return 13
            // This default is another indicator of a poor architecture, since a rank
            // of 0 doesn't really make logical sense.
            default                                     :   return 0
            }
        }
        
        static var all  :   [ Rank ]
        {
            var allRanks    :   [ Rank ]    =   [ .ace ]
            
            for pips in 2 ... 10
            {
                allRanks.append( Rank.numeric( pips ) )
            }
            allRanks    +=  [ .face( "J" ), .face( "Q" ), .face( "K" ) ]
            
            return allRanks
        }
        
        var description: String
        {
            switch self
            {
            case .ace                   :   return "A"
            case .numeric( let pips )   :   return String( pips )
            case .face( let kind )      :   return kind
            }
        }
    }
}
