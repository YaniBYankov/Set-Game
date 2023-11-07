//
//  CardView.h
//  Set
//
//  Created by Yani Yankov on 21.08.23.
//

#import <UIKit/UIKit.h>
#import "CardEnum.h"

NS_ASSUME_NONNULL_BEGIN
 

@interface CardView : UIView


@property (nonatomic,readonly) Color color;
@property (nonatomic, readonly) Shape shape;
@property (nonatomic, readonly) Fill fill;
@property (nonatomic,readonly) NSUInteger count;

@property (nonatomic,readonly) BOOL isSelected;

@property (nonatomic,readonly) CGFloat cornerRadius;
@property (nonatomic,readonly) CGFloat borderWidth;

-(void)setCard: (Color)color withShape:(Shape)shape withFill:(Fill)fill withCount:(NSUInteger)count;

-(void)selected: (BOOL)isSelected;
@end

NS_ASSUME_NONNULL_END
