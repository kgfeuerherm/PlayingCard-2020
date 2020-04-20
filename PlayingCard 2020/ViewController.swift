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
    var deck    =   PlayingCardDeck()

    // Set up an outlet for swipes.
    @IBOutlet weak var playingCardView: PlayingCardView!
    {
        didSet
        {
            // Swipe affects the model, so it must be handled by the controller,
            // i.e., 'self'.
            let swipe       =   UISwipeGestureRecognizer(
                                    target: self, action: #selector( nextCard ) )
            
            // Direction can be singular, e.g., '.left', '.right', or plural, via array.
            swipe.direction =   [ .left, .right ]
            
            // Now, make the gesture recognizer available to the view.
            playingCardView.addGestureRecognizer( swipe )
            
            // Add recognition for pinches.
            let pinch       =       UIPinchGestureRecognizer( target: playingCardView,
                                        action: #selector( PlayingCardView.adjustFaceCardScale( byHandlingGestureRecognizerBy: ) ) )
            playingCardView.addGestureRecognizer( pinch )
        }
    }
   
    // Set up an action for flips.
    @IBAction func flipCard( _ sender: UITapGestureRecognizer )
    {
        // Although the demo works without this switch, the proper way to
        // do this is to ensure that the gesture has ended before handling it.
        switch sender.state
        {
        case .ended :   // Change the state of the card.
                        playingCardView.isFaceUp    =   !playingCardView.isFaceUp
            
        default     :   // Even though there is nothing to do in this case (no-op),
                        // Swift requires an 'executable' line, so add 'break'.
                        break
        }
    }
    
    // The selector function must have access to the Objective-C run-time, so mark it as such.
    @objc func nextCard()
    {
        // Go to the next card where possible.
        if let card =   deck.draw()
        {
            // The controller must genericize the model's information
            // for the view.
            playingCardView.rank    =   card.rank.order
            playingCardView.suit    =   card.suit.rawValue
        }
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // This is a good place to do initialiations and/or add debugging code.
        //     Let's just draw 10 cards and display them as a test of the model.
    }
}

