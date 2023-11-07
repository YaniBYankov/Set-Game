//
//  Deck.h
//  Set
//
//  Created by Yani Yankov on 11.08.23.
//

#import <Foundation/Foundation.h>
#import "Card.h"

NS_ASSUME_NONNULL_BEGIN



@interface Deck : NSObject

@property (nonatomic,strong,readonly) NSMutableArray*cards;

-(void)addCard:(Card *)card;
-(Card *)getCardAt:(NSUInteger)index;
-(NSMutableArray *)drawCards:(NSUInteger)numberOfCards;
-(void)shuffle;

+(NSMutableArray *) shuffleArray:(NSMutableArray *)arr;

@end

NS_ASSUME_NONNULL_END
