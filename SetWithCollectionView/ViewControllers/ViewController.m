//
//  ViewController.m
//  Set
//
//  Created by Yani Yankov on 11.08.23.
//

#import "ViewController.h"
#import "Card.h"
#import "Deck.h"
#import "SetGame.h"
#import "CardView.h"
#import "MyCollectionViewCell.h"

@interface ViewController ()


//MARK: -------------------------IBOutlets-------------------------
@property (weak, nonatomic) IBOutlet UIButton *dealButton;
@property (weak, nonatomic) IBOutlet UIButton *startGameButton;
@property (weak, nonatomic) IBOutlet UILabel *score;
@property (weak,nonatomic) IBOutlet UICollectionView *collectionView;

//MARK: -------------------------Properties-------------------------
@property (nonatomic) BOOL hasTriedMatch;
@property (nonatomic) BOOL hasSuccessfulMatch;
@property (strong,nonatomic) SetGame* game;
@property (strong, nonatomic) NSMutableArray<Card *>* selectedCards;
@property (strong, nonatomic) NSMutableArray<MyCollectionViewCell *>* selectedCardViews;
@property (strong, nonatomic) NSMutableArray<CardView *>* cardViews;
@property (nonatomic) BOOL hasStartedGame;

@property (strong,nonatomic) UIImpactFeedbackGenerator *feedbackTap;

@end



@implementation ViewController

//MARK: -------------------------viewDidLoad-------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initGame];
    
    _dealButton.layer.cornerRadius = 15;
    _dealButton.clipsToBounds = YES;
    
    _startGameButton.layer.cornerRadius = 15;
    _startGameButton.clipsToBounds = YES;
    
    [self showContent:NO];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(300, 300);
    
    self.collectionView.collectionViewLayout = layout;
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.collectionView registerNib:[MyCollectionViewCell nib] forCellWithReuseIdentifier:@"MyCollectionViewCell"];
    
    self.feedbackTap = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleRigid];

}

//MARK: -------------------------viewWillTransitionToSize-------------------------

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [self.collectionView reloadData];
}

//MARK: -------------------------IBActions-------------------------

- (IBAction)startGame:(UIButton *)sender {
    if (!self.hasStartedGame){
        [self showContent:YES];
        [self updateUI];
        self.hasStartedGame = YES;
        for (Card* drawnCard in self.game.drawnCards){
            CardView *cardView = [[CardView alloc]init];
            [cardView setCard:drawnCard.color withShape:drawnCard.shape withFill:drawnCard.fill withCount:drawnCard.count];
            [self.cardViews addObject:cardView];
            
        }
    } else {
        SetGame* newGame = [[SetGame alloc]init:12];
        self.game = newGame;
    
        if (self.selectedCards) {
            [self.selectedCards removeAllObjects];
        }
        [self updateUI];
    }
}

- (IBAction)DealThreeCards:(UIButton *)sender {
    [self.game dealCards];
    [self deselectCards];
    [self updateUI];
    
}

- (IBAction)rotationGestureToShuffle:(UIRotationGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded){
        [self.game shuffle];
        [self deselectCards];
        [self updateUI];}
}

//MARK: -------------------------UIFunctions-------------------------

-(void)updateUI{
    
    [self updateScore:self.game.score];
    
    if (![self.game canDraw:3]){
        self.dealButton.enabled = NO;
        self.dealButton.alpha = 0.5;
    } else {
        self.dealButton.enabled = YES;
        self.dealButton.alpha = 1;
    }
    [self.collectionView reloadData];
}

-(void)updateScore:(NSUInteger) withScore{
    
    if (!self.game.drawnCards.count){
        self.score.text = [NSString stringWithFormat:@"You win with %ld score!", withScore];
    } else {
        self.score.text = [NSString stringWithFormat:@"Score: %ld", withScore];
    }
}

-(void)showContent:(BOOL)isHidden{
    
    self.dealButton.hidden = !isHidden;
    self.score.hidden=!isHidden;
    self.collectionView.hidden = !isHidden;
}

-(void)showMatchingIndication{
    
    for (MyCollectionViewCell* cardView in self.selectedCardViews) {
        cardView.layer.cornerRadius = cardView.cardView.cornerRadius;
        if (self.hasSuccessfulMatch){
            cardView.layer.borderColor = UIColor.greenColor.CGColor;
        } else{
            cardView.layer.borderColor = UIColor.redColor.CGColor;
        }
        cardView.layer.borderWidth = cardView.cardView.borderWidth*10;
        [UIView animateWithDuration:0.3 delay:0.0 options: UIViewAnimationOptionAllowUserInteraction
                         animations:^{cardView.layer.borderColor = UIColor.clearColor.CGColor;
        }
                         completion:^(BOOL finished){
            [self updateUI];
            cardView.layer.cornerRadius = 0 ;
        }];
    }
}

//MARK: -------------------------GameLogicFunctions-------------------------

- (void)initGame{
    self.game = [[SetGame alloc]init:12];
    self.selectedCards = [[NSMutableArray alloc]init];
    self.selectedCardViews = [[NSMutableArray<MyCollectionViewCell *> alloc]init];
    self.cardViews = [[NSMutableArray<CardView *> alloc]init];
    self.hasTriedMatch = NO;
    self.hasStartedGame = NO;
    self.hasSuccessfulMatch = NO;
}

-(void)matchSelectedCards{
    
    if (self.selectedCards.count){
        self.hasSuccessfulMatch = [self.game matchCards:self.selectedCards];
    }
}

-(void)replaceMatchedCards{
    
    for (Card* matchedCard in self.selectedCards){
        NSUInteger indexToAdd = [self.game.drawnCards indexOfObject:matchedCard];
        if ([self.game canDraw:1]){
            [self.game drawCard:indexToAdd];
        } else {
            [self.game.drawnCards removeObjectAtIndex:indexToAdd];
        }
    }
}

-(void)deselectCards{
    
    for (MyCollectionViewCell *cardView in self.selectedCardViews){
        [cardView.cardView selected:NO];
    }
    
    [self.selectedCards removeAllObjects];
    [self.selectedCardViews removeAllObjects];
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    MyCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"MyCollectionViewCell" forIndexPath:indexPath];
    Card * card=self.game.drawnCards[indexPath.item];
    [cell configWithCard:card];
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.game.drawnCards.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.feedbackTap prepare];
    [self.feedbackTap impactOccurred];
    
    MyCollectionViewCell* selectedCard = (MyCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    if (self.selectedCards.count<3){
        if(!selectedCard.cardView.isSelected){
            [selectedCard.cardView selected:YES];
            [self.selectedCardViews addObject:selectedCard];
            [self.selectedCards addObject:self.game.drawnCards[indexPath.item]];
        } else {
            [selectedCard.cardView selected:NO];
            
            [self.selectedCardViews removeObject:selectedCard];
            [self.selectedCards removeObject:self.game.drawnCards[indexPath.item]];
        }
    }
    
    if (self.selectedCards.count == 3){
        self.hasTriedMatch = YES;
        [self matchSelectedCards];
        [self showMatchingIndication];
        if(self.hasSuccessfulMatch){
            [self replaceMatchedCards];
        }
        [self deselectCards];
    }
}

-(CGSize)calculateCellSize{
    
    CGFloat collectionWidth = self.collectionView.frame.size.width;
    CGFloat collectionHeight = self.collectionView.frame.size.height;
    
    NSUInteger numberOfCells=[self.collectionView numberOfItemsInSection:0];
    
    UICollectionViewFlowLayout * flowLayout=(UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    CGFloat itemSpacing = flowLayout.minimumInteritemSpacing;
    CGFloat lineSpacing = flowLayout.minimumLineSpacing;
    
    NSInteger rows = sqrt(numberOfCells);
    NSUInteger cols=rows;
    NSUInteger remainingCells = numberOfCells - rows*rows;
    
    if (remainingCells<=cols){
        cols+=1;
    } else {
        cols+=remainingCells/cols+1;
    }
    if (collectionWidth<collectionHeight){
        NSUInteger temp = cols;
        cols = rows;
        rows = temp;
    }
    
    CGFloat cellWidth = (collectionWidth-(cols-1)*itemSpacing)/cols;
    CGFloat cellHeight = (collectionHeight-(rows-1)*lineSpacing)/rows;
    
    return CGSizeMake(cellWidth, cellHeight);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return [self calculateCellSize];
}

@end

