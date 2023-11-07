//
//  SetGame.m
//  Set
//
//  Created by Yani Yankov on 11.08.23.
//

#import "SetGame.h"
#import "Deck.h"

@interface SetGame ()

@property (strong,nonatomic) Deck *deck;
@property (nonatomic,readwrite) NSInteger score;
@property (nonatomic,readwrite) BOOL hasStarted;
@property (nonatomic,strong,readwrite) NSMutableArray<Card*> *drawnCards;

@end


@implementation SetGame


-(instancetype)init:(NSUInteger)numberOfCards{
    self = [super init];
    if (self){
        self.deck = [[Deck alloc]init];
        self.drawnCards = [[NSMutableArray alloc]init];
        [self.deck shuffle];
        self.score = 0;
        self.hasStarted = YES;
        self.drawnCards = [self.deck drawCards:numberOfCards];
    }
    
    return self;
}

-(Card *)cardAtIndex:(NSUInteger)index{
    return [self.deck getCardAt:index];
}

-(void)dealCards{
    NSArray *drawnCardsFromDeck = [self.deck drawCards:3];//
    [self.drawnCards addObjectsFromArray:drawnCardsFromDeck];
}


-(Card *)getCardAt:(NSUInteger)index{
    return [self.deck getCardAt:index];
}

- (Card*)getDrawnCardAt:(NSUInteger)index{
    return self.drawnCards[index];
}

-(BOOL)matchCards:(NSMutableArray<Card *> *)cards{
    
    NSMutableArray *appearanceOfShape = [[NSMutableArray alloc]init];
    NSMutableArray *appearanceOfColor = [[NSMutableArray alloc]init];
    NSMutableArray *appearanceOfFill = [[NSMutableArray alloc]init];
    NSMutableArray *appearanceOfCount = [[NSMutableArray alloc]init];
    
    for (Card * card in cards){
        
        if (![appearanceOfShape containsObject:@(card.shape)]){
            [appearanceOfShape addObject:@(card.shape)];
        }
        if (![appearanceOfColor containsObject:@(card.color)]){
            [appearanceOfColor addObject:@(card.color)];
        }
        if (![appearanceOfFill containsObject:@(card.fill)]){
            [appearanceOfFill addObject:@(card.fill)];
        }
        if (![appearanceOfCount containsObject:@(card.count)]){
            [appearanceOfCount addObject:@(card.count)];
        }
    }
    
    if (appearanceOfShape.count==cards.count &&
        appearanceOfColor.count==cards.count &&
        appearanceOfFill.count==cards.count &&
        appearanceOfCount.count==cards.count) {
        self.score-=3;
        return NO;
    }
    
    if ((appearanceOfShape.count==1 || appearanceOfShape.count == cards.count) &&
        (appearanceOfColor.count==1 || appearanceOfColor.count == cards.count) &&
        (appearanceOfFill.count==1 || appearanceOfFill.count == cards.count) &&
        (appearanceOfCount.count==1 || appearanceOfCount.count == cards.count) ) {
        self.score+=6;
        return YES;
    }
    
    self.score-=3;
    return NO;
}

-(BOOL)canDraw:(NSUInteger)amount{
    return (amount<=self.deck.cards.count);
}

- (void)drawCard:(NSUInteger)atIndex{
    if (self.deck.cards.count>0){
        Card* drawnCard = [[self.deck drawCards:1] lastObject];
        
        self.drawnCards[atIndex] = drawnCard;
        //return drawnCard;
    } else {
       // return nil;
    }
}

- (void)shuffle{
    
    NSMutableArray *allNonmatchedCards = [[NSMutableArray alloc]init];
    [allNonmatchedCards addObjectsFromArray:self.drawnCards];
    [allNonmatchedCards addObjectsFromArray:self.deck.cards];
    
    allNonmatchedCards = [Deck shuffleArray:allNonmatchedCards];
    NSUInteger drawnCardsCount = self.drawnCards.count;
    NSUInteger cardsInDeckCount = self.deck.cards.count;
    
    [self.drawnCards removeAllObjects];
    [self.deck.cards removeAllObjects];
    
    for (NSUInteger i=0;i<drawnCardsCount;i++){
        if (allNonmatchedCards.count)
            [self.drawnCards addObject:[allNonmatchedCards lastObject]];
        [allNonmatchedCards removeLastObject];
    }
    
    for (NSUInteger i=0;i<cardsInDeckCount;i++){
        if (allNonmatchedCards.count)
            [self.deck.cards addObject:[allNonmatchedCards lastObject]];
        [allNonmatchedCards removeLastObject];
    }
}

- (Card *)removeCardAtIndex:(NSUInteger)index inArray:(NSMutableArray *)arr {
    if (arr.count){
        Card *cardToRemove = [[Card alloc]init];
        cardToRemove = arr[index];
        [arr removeObjectAtIndex:index];
        return cardToRemove;
    }
    return nil;
}

-(NSUInteger)generateRandomIndex:(NSMutableArray *)arr{
    NSUInteger index = arc4random() % arr.count;
    return index;
}


@end
