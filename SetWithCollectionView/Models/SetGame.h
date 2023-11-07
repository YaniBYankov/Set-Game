//
//  SetGame.h
//  Set
//
//  Created by Yani Yankov on 11.08.23.
//

#import <Foundation/Foundation.h>
#import "Card.h"

NS_ASSUME_NONNULL_BEGIN

@interface SetGame : NSObject

@property (nonatomic,readonly) NSInteger score;
@property (nonatomic, readonly) BOOL hasStarted;
@property (nonatomic,strong,readonly) NSMutableArray<Card*> *drawnCards;

-(instancetype)init:(NSUInteger)numberOfCards;
-(void)dealCards;

-(Card *)getCardAt:(NSUInteger)index;
-(Card *)getDrawnCardAt:(NSUInteger)index;
-(BOOL)matchCards:(NSMutableArray *)cards;
-(BOOL)canDraw:(NSUInteger)amount;
-(void)drawCard:(NSUInteger)atIndex;
-(void)shuffle;

@end

NS_ASSUME_NONNULL_END
