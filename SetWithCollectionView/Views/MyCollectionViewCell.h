//
//  MyCollectionViewCell.h
//  SetWithCollectionView
//
//  Created by Yani Yankov on 24.08.23.
//

#import <UIKit/UIKit.h>
#import "CardView.h"
#import "Card.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyCollectionViewCell : UICollectionViewCell

@property (weak, readonly) IBOutlet CardView *cardView;

-(void)configure:(Color)color withShape:(Shape)shape withFill:(Fill)fill withCount:(NSUInteger)count;

-(void)configWithCard:(Card*)card;

+(UINib *)nib;
@end

NS_ASSUME_NONNULL_END
