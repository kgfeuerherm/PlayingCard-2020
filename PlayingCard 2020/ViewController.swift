//
//  ViewController.swift
//  PlayingCard 2020
//
//  Created by Karljürgen Feuerherm on 2020-04-17.
//  Copyright © 2020 Karljürgen Feuerherm. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // This is a good place to do initialiations and/or add debugging code.
        //     Let's just draw 10 cards and display them as a test of the model.
        var deck    =   PlayingCardDeck()
        
        for _ in 1 ... 10
        {
            if let card = deck.draw()
            {
                print( "\( card )" )
            }
        }
    }
    
    // In lecture 5, an overridden function 'didReceiveMemoryWarning()' was deleted.
    //     It was not present in the default code in this version of Xcode to begin with.
}

