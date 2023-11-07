//
//  MyCollectionViewCell.m
//  SetWithCollectionView
//
//  Created by Yani Yankov on 24.08.23.
//

#import "MyCollectionViewCell.h"


@interface MyCollectionViewCell ()
@property (weak, readwrite) IBOutlet CardView *cardView;
@end

@implementation MyCollectionViewCell

- (instancetype)init{
    self = [super init];
    return self;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)configure:(Color)color withShape:(Shape)shape withFill:(Fill)fill withCount:(NSUInteger)count{
    [self.cardView setCard:color withShape:shape withFill:fill withCount:count];
}


- (void)configWithCard:(Card*)card{
    [self.cardView setCard:card.color withShape:card.shape withFill:card.fill withCount:card.count];
}

+ (UINib *)nib{
    UINib * nib = [UINib nibWithNibName:@"MyCollectionViewCell" bundle:nil];
    return nib;
}

@end
