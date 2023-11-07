//
//  Card.m
//  Set
//
//  Created by Yani Yankov on 11.08.23.
//

#import "Card.h"

@interface Card ()

@property (nonatomic,readwrite) Fill fill;
@property (nonatomic,readwrite) NSUInteger count;
@property (nonatomic,readwrite) Color color;
@property (nonatomic,readwrite) Shape shape;

@end

@implementation Card

-(instancetype)initWith:(Color) color withShape:(Shape) type withFill:(Fill) fill withNumber:(NSUInteger) count{
    self = [super init];
    if (self){
        self.shape = type;
        self.color = color;
        self.count = count;
        self.fill = fill;
    }
    return self;
}

@end
