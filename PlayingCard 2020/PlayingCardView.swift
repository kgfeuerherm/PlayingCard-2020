//
//  PlayingCardView.swift
//  PlayingCard 2020
//
//  Created by Karljürgen Feuerherm on 2020-04-20.
//  Copyright © 2020 Karljürgen Feuerherm. All rights reserved.
//

import UIKit

// The next line allows us to see mock-ups in the storyboard.
//     Be advised, however, that images do not render there unless
// 'in: Bundle...' has been specified in the 'UIImage' calls.
@IBDesignable
class PlayingCardView: UIView
{
    private func centredAttributedString
        (
            _ string    :   String, // string to be displayed
            fontSize    :   CGFloat // how large to make it
        )                -> NSAttributedString
    {
        // Set up the desired font.
        var font                    =   UIFont.preferredFont(
                                            forTextStyle    :   .body).withSize( fontSize )
        
        // As defined, the font will have a rigid text size which won't scale
        // if and when a user has changed the Accessibility font size.
        //     The next line remedies that.
        font                        =   UIFontMetrics(
                                            forTextStyle    :   .body ).scaledFont( for: font )
        
        // Now, set up the paragraph style.
        let paragraphStyle          =   NSMutableParagraphStyle()
        paragraphStyle.alignment    =   .center
        
        return NSAttributedString(
            string      :   string,
            attributes  :   [ .paragraphStyle   :   paragraphStyle,
                              .font             :   font            ] )
    }
    
    // Remember that we are inside a view, i.e., a generic item which knows nothing of
    // models (i.e., enums etc.), so the types must be generic.
    //     We need to initialize these things somehow, so pick something.
    //     The '@IBInspectable' line allows us to manipulate variables which are so
    // identified in the Attribute Inspector.
    //     In this situation, however, variables must be explicitly typed.
    @IBInspectable
    var rank            :   Int     =   7
    {
        didSet
        {
            // Remember that a view needs to be redrawn if/when its content changes.
            setNeedsDisplay()
            
            // Also, when there are subviews as well, redo the layout.
            setNeedsLayout()
        }
    }
    
    @IBInspectable
    var suit            :   String  =   "♥️"
    {
        didSet
        {
            setNeedsDisplay()
            setNeedsLayout()
        }
    }

    @IBInspectable
    var isFaceUp        :   Bool    =   false
    {
        didSet
        {
            setNeedsDisplay()
            setNeedsLayout()
        }
    }

    // Provide a default scale for face card images.
    // '@IBInspectable' was not in the lecture demo.
    @IBInspectable
    var faceCardScale   :   CGFloat =   SizeRatio.faceCardImageSizeToBoundsSize
    {
        didSet
        {
            // Changing the size of the image does not affect the layout itself,
            // so no need for 'setNeedsLayout()'.
            setNeedsDisplay()
        }
    }

    // Handlers must be marked '@objc'.
    @objc func adjustFaceCardScale( byHandlingGestureRecognizerBy recognizer: UIPinchGestureRecognizer )
    {
        switch recognizer.state
        {
        case .changed, .ended   :   faceCardScale       *=  recognizer.scale
                                    // To prevent exponential growth, reset the
                                    // scale in incremental changes.
                                    recognizer.scale    =   1.0
        default                 :   break
        }
    }

    private var cornerString    :   NSAttributedString
    {
        return centredAttributedString( rankString + "\n" + suit, fontSize: cornerFontSize )
    }
    
    private lazy var upperLeftCornerLabel   =   createCornerLabel()
    
    private lazy var lowerRightCornerLabel  =   createCornerLabel()
    
    private func createCornerLabel()    ->  UILabel
    {
        let label   =   UILabel()
        
        // Configure the label appropriately.
        label.numberOfLines =   0   // i.e., indeterminate (rather than fixed) number of lines
        
        // Make it available to the current view.
        addSubview( label )
        
        return label
    }
    
    // Traits define such things as orientation etc., and when one of these changes
    // mid-run (in the demo we changed the accessibility font size), we need to ensure
    // that we force redrawing and remapping of layout.
    override func traitCollectionDidChange( _ previousTraitCollection: UITraitCollection? )
    {
        setNeedsDisplay()
        setNeedsLayout()
    }
    
    private func configureCornerLabel( _ label: UILabel )
    {
        label.attributedText    =   cornerString
        
        // Wipe out any pre-existing size information to ensure that we get
        // what we want in both dimensions.
        label.frame.size        =   CGSize.zero
        
        // Now, 'sizeToFit' will take care of resetting both dimensions as
        // required by the contents.
        label.sizeToFit()
        
        // Make sure we only draw this when the card is face up.
        label.isHidden          =   !isFaceUp
    }
 
    // BORROWED from
    // https://github.com/BestKora/CS193P-Fall-2017-DEMO/blob/master/PlayingCard%20L6/PlayingCard/PlayingCardView.swift
    // and reformated.
    private func drawPips()
    {
        let pipsPerRowForRank   =
        [
            [ 0 ], [ 1 ], [ 1, 1 ], [ 1, 1, 1 ], [ 2, 2 ], [ 2, 1, 2 ], [ 2, 2, 2 ], [ 2, 1, 2, 2 ], [ 2, 2, 2, 2 ], [ 2, 2, 1, 2, 2 ], [ 2, 2, 2, 2, 2 ]
        ]
        
        func createPipString( thatFits pipRect: CGRect )    ->  NSAttributedString
        {
            let maxVerticalPipCount     =   CGFloat( pipsPerRowForRank.reduce( 0 )
                                                { max( $1.count, $0 ) } )
            let maxHorizontalPipCount   =   CGFloat( pipsPerRowForRank.reduce( 0 )
                                                { max( $1.max() ?? 0, $0 ) } )
            let verticalPipRowSpacing   =   pipRect.size.height / maxVerticalPipCount
            let attemptedPipString      =   centredAttributedString(
                                                suit, fontSize: verticalPipRowSpacing )
            let probablyOkayPipStringFontSize
                                        =   verticalPipRowSpacing /
                                            ( attemptedPipString.size().height / verticalPipRowSpacing )
            let probablyOkayPipString   =   centredAttributedString(
                                                suit, fontSize: probablyOkayPipStringFontSize )
            if probablyOkayPipString.size().width
                                        >   pipRect.size.width / maxHorizontalPipCount
            {
                return centredAttributedString( suit, fontSize: probablyOkayPipStringFontSize /
                    ( probablyOkayPipString.size().width /
                        ( pipRect.size.width / maxHorizontalPipCount ) ) )
            }
            else
            {
                return probablyOkayPipString
            }
        }
        
        if pipsPerRowForRank.indices.contains( rank )
        {
            let pipsPerRow              =   pipsPerRowForRank[ rank ]
            var pipRect                 =   bounds.insetBy( dx: cornerOffset, dy: cornerOffset )
                .insetBy( dx: cornerString.size().width, dy: cornerString.size().height / 2 )
            let pipString               =   createPipString( thatFits: pipRect )
            let pipRowSpacing           =   pipRect.size.height / CGFloat( pipsPerRow.count )
            pipRect.size.height         =   pipString.size().height
            pipRect.origin.y            +=  ( pipRowSpacing - pipRect.size.height ) / 2
            for pipCount in pipsPerRow
            {
                switch pipCount
                {
                case 1  :   pipString.draw( in: pipRect )
                case 2  :   pipString.draw( in: pipRect.leftHalf )
                            pipString.draw( in: pipRect.rightHalf )
                default :   break
                }
                
                pipRect.origin.y        +=  pipRowSpacing
            }
        }
    }
    
    // When we have subviews, we must provide the following function.
    //     Note that it is never called directly; it is invoked at the appropriate
    // time when 'setNeedsLayout()' has been invoked previously.
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        configureCornerLabel( upperLeftCornerLabel )
        
        // Setting up the left corner label is straightforward; it fits into
        // the upper left corner.
        upperLeftCornerLabel.frame.origin   =   bounds.origin.offsetBy( dx: cornerOffset, dy: cornerOffset )
        
        configureCornerLabel( lowerRightCornerLabel )
        
        // Remember that on a playing card, the bottom right identifier is
        // upside down.
        lowerRightCornerLabel.transform     =   CGAffineTransform.identity
                                                    .rotated( by: CGFloat.pi )
            .translatedBy( x: lowerRightCornerLabel.frame.size.width, y: lowerRightCornerLabel.frame.size.height )
        
        // For the lower right, however, we must move the label in according to the corner rounding PLUS
        // the width or length of the corner label, respectively.
        lowerRightCornerLabel.frame.origin   =   CGPoint( x: bounds.maxX, y: bounds.maxY )
            .offsetBy( dx: -cornerOffset, dy: -cornerOffset )
            .offsetBy( dx: -lowerRightCornerLabel.frame.size.width,
                       dy: -lowerRightCornerLabel.frame.size.height )
    }
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw( _ rect: CGRect )
    {
/* DEMO 01: Drawing by means of a context
         
        if let context = UIGraphicsGetCurrentContext()
        {
            // Create a closed path and stroke width.
            context.addArc( center      :   CGPoint( x  :   bounds.midX,    y   :   bounds.midY ),
                            radius      :   100.0,
                            startAngle  :   0,
                            endAngle    :   2 * CGFloat.pi,
                            clockwise   :   false )
            context.setLineWidth( 5.0 )

            // Set the stroke and fill.
            UIColor.green.setFill()
            UIColor.red.setStroke()
            
            // Attempt to execute the drawing.
            // Only the stroke will be executed, because, unlike with the Bezier example,
            // 'strokePath' consumes the path, meaning that there is no path for the fill
            // to act upon; one would have to create the path again.
            context.strokePath()
            context.fillPath()
        }
*/

/* DEMO 02: Doing the same thing using a Bézier path
         
        // Contrast the following code, which does the 'same' thing:
        //     Note that rotating the view causes the pixel content to stretch or shrink
        // to fit the new dimensions by default;it is necessary to change the view's
        // behaviour to 'Redraw' (under 'Content Mode' in the Attributes Inspector).
        let path = UIBezierPath()
        
        path.addArc( withCenter :   CGPoint( x  :   bounds.midX,    y   :   bounds.midY ),
                     radius     :   100.0,
                     startAngle : 0,
                     endAngle   : 2 * CGFloat.pi,
                     clockwise  : false )
        path.lineWidth = 5.0
        UIColor.green.setFill()
        UIColor.red.setStroke()
        path.stroke()
        path.fill()
*/
        let roundedRect = UIBezierPath( roundedRect: bounds, cornerRadius: cornerRadius )
        // For the present purpose, the next line is not really needed, as there is
        // no anticipation of 'colouring outside the lines'; but it's a 'heads uo!'
        // for the future.
        //     Note that for the following to work, the background of the view must be
        // something other than white; 'clear' is the likely choice. here.
        //     The lecture also suggesting disabling the 'Opaque' checkbox, though it
        // seemed to work just fine with it on.
        roundedRect.addClip()
        UIColor.white.setFill()
        roundedRect.fill()
        
        if isFaceUp
        {
            // Draw the image in the case of a face card, and place pips
            // at appropriate positions otherwise.
            if let faceCardImage = UIImage( named: rankString + suit,
                                            in: Bundle( for: self.classForCoder ), compatibleWith: traitCollection )
            {
                // In the early part of the demo, the zoom was by
                // 'SizeRatio.faceCardImageSizeToBoundsSize'; but we want to be able
                // to change the size of the image now.
                faceCardImage.draw( in: bounds.zoom( by: faceCardScale ) )
            }
            else
            {
                drawPips()
            }
        }
        else
        {
            if let cardBackImage = UIImage.init( named: "cardback",
                                                 in: Bundle( for: self.classForCoder ), compatibleWith: traitCollection )
            {
                cardBackImage.draw( in: bounds )
            }
        }

    }
}

// Borrowed from
// https://github.com/BestKora/CS193P-Fall-2017-DEMO/blob/master/PlayingCard%20L6/PlayingCard/PlayingCardView.swift
// and reformated for consistency.

extension PlayingCardView
{
    // The preferred way to declare constants specific to a type is by means
    // of a private struct with static (i.e., type-specific) constant declarations.
    private struct SizeRatio    // choose an appropriate name here (often 'constant' will do)
    {
        static let cornerFontSizeToBoundsHeight :   CGFloat     =   0.085
        static let cornerRadiusToBoundsHeight   :   CGFloat     =   0.06
        static let cornerOffsetToCornerRadius   :   CGFloat     =   0.33
        static let faceCardImageSizeToBoundsSize:   CGFloat     =   0.75
    }
                            
    private var cornerRadius    :   CGFloat
    {
        return bounds.size.height * SizeRatio.cornerRadiusToBoundsHeight
    }
    
    private var cornerOffset    :   CGFloat
    {
        return cornerRadius * SizeRatio.cornerOffsetToCornerRadius
    }
    
    private var cornerFontSize  :   CGFloat
    {
        return bounds.size.height * SizeRatio.cornerFontSizeToBoundsHeight
    }
    
    private var rankString      :   String
    {
        switch rank
        {
        case 1          :   return "A"
        case 2 ... 10   :   return String( rank )
        case 11         :   return "J"
        case 12         :   return "Q"
        case 13         :   return "K"
        default         :   return "?"
        }
    }
}

extension CGRect
{
    var leftHalf:   CGRect
    {
        return CGRect( x: minX, y: minY, width: width/2, height: height )
    }
    
    var rightHalf:  CGRect
    {
        return CGRect( x: midX, y: minY, width: width/2, height: height )
    }
    
    func inset( by size: CGSize )               ->  CGRect
    {
        return insetBy( dx: size.width, dy: size.height )
    }
    
    func sized( to size: CGSize )               ->  CGRect
    {
        return CGRect( origin: origin, size: size )
    }
    
    func zoom( by scale: CGFloat )              ->  CGRect
    {
        let newWidth    = width * scale
        let newHeight   = height * scale
        return insetBy( dx: ( width - newWidth ) / 2, dy: ( height - newHeight ) / 2 )
    }
}

extension CGPoint
{
    func offsetBy( dx: CGFloat, dy: CGFloat )   ->  CGPoint
    {
        return CGPoint( x: x+dx, y: y+dy )
    }
}
