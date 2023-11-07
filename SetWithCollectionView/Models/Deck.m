//
//  Deck.m
//  Set
//
//  Created by Yani Yankov on 11.08.23.
//

#import "Deck.h"

@interface Deck ()

@property (nonatomic,strong) NSMutableArray *cards;

@end

@implementation Deck

-(instancetype) init {
    self = [super init];
    if (self) {
        self.cards = [[NSMutableArray alloc]init];
        for (int color=0;color<colorCnt;color++){
            for (int fill=0;fill<fillCnt;fill++)
            {
                for (int shape=0;shape<shapeCnt;shape++) {
                    for (int number=1;number<=3;number++){
                        Card *card = [[Card alloc]initWith:color withShape:shape withFill:fill withNumber:number];
                        [self addCard:card];
                    }
                }
            }
        }
    }
    return self;
}

- (void)addCard:(Card *)card {
    [self.cards addObject:card];
}

-(NSMutableArray *)drawCards:(NSUInteger)numberOfCards{
    if (numberOfCards<=self.cards.count){
        NSMutableArray* drawnCards = [[NSMutableArray alloc]init];
        for (int i=0;i<numberOfCards;i++){
            [drawnCards addObject:[self removeCardAtIndex:0]];
        }
        return drawnCards;
    }
    return nil;
}

- (Card *)removeCardAtIndex:(NSUInteger)index {
    if (self.cards && index<self.cards.count){
        Card *cardToRemove = self.cards[index];
        [self.cards removeObjectAtIndex:index];
        return cardToRemove;
    }
    return nil;
}

- (void)shuffle{
    self.cards = [Deck shuffleArray:self.cards];
}

+ (NSMutableArray *)shuffleArray:(NSMutableArray *)arr{
    
    for (NSUInteger i=0;i<arr.count;i++){
        NSUInteger j=arc4random() % arr.count;;
        [arr exchangeObjectAtIndex:i withObjectAtIndex:j];
    }
    return arr;
}

-(Card *)getCardAt:(NSUInteger)index{
    if (index<self.cards.count){
        return self.cards[index];
    }
    return nil;
}


@end
