//
//  Card.h
//  Set
//
//  Created by Yani Yankov on 11.08.23.
//

#import <Foundation/Foundation.h>
#import "CardEnum.h"

NS_ASSUME_NONNULL_BEGIN

@interface Card : NSObject

@property (nonatomic,readonly) Fill fill;
@property (nonatomic,readonly) Shape shape;
@property (nonatomic,readonly) NSUInteger count;
@property (nonatomic,readonly) Color color;

-(instancetype)initWith:(Color) color withShape:(Shape) type withFill:(Fill) fill withNumber:(NSUInteger) count;


@end

NS_ASSUME_NONNULL_END
