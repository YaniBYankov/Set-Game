//
//  CardView.m
//  Set
//
//  Created by Yani Yankov on 21.08.23.
//

#import "CardView.h"

const CGFloat shapeMargin = 0.2;

@interface CardView ()

@property (nonatomic,readwrite) Color color;
@property (nonatomic, readwrite) Shape shape;
@property (nonatomic, readwrite) Fill fill;
@property (nonatomic,readwrite) NSUInteger count;
@property (nonatomic,readwrite) CGFloat cornerRadius;
@property (nonatomic,readwrite) CGFloat borderWidth;

@property (nonatomic,readwrite) BOOL isSelected;
@property (nonatomic,readwrite) UIColor* outlineColor;
@end

@implementation CardView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.isSelected = NO;
        self.count = 0;
        self.cornerRadius = 0;
    }
    return self;
}

- (void)setCard:(Color)color withShape:(Shape)shape withFill:(Fill)fill withCount:(NSUInteger)count{
    self.color = color;
    self.shape = shape;
    self.fill = fill;
    self.count = count;
    [self setNeedsDisplay];
}

-(void)setup{
    self.cornerRadius = MIN(self.bounds.size.width, self.bounds.size.height)*0.1;
    UIBezierPath* cardPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.cornerRadius];
    self.layer.cornerRadius = self.cornerRadius;
    [cardPath addClip];
    [UIColor.clearColor setFill];
    [cardPath fill];
    self.borderWidth = MIN(self.bounds.size.width, self.bounds.size.height)*0.1;
    cardPath.lineWidth = self.borderWidth;
    
    if (self.isSelected){
            [UIColor.blueColor setStroke];
    } else if (self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark){
        [UIColor.whiteColor setStroke];
    } else {
        [UIColor.blackColor setStroke];
    }
    
    [cardPath fill];
    [cardPath stroke];
    
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self setup];
    NSMutableArray <NSValue *>*  rects = [self createRectsForNumberOfShapes: self.count];
    for (NSValue *value in rects){
        CGRect rectangle = [value CGRectValue];
        CGContextResetClip(context);
        [self drawBlock:self.color with:self.fill forShape:self.shape rect:rectangle cntx:context];
    }
}

-(void)drawBlock:(Color)color with:(Fill)fill forShape:(Shape)shape rect:(CGRect)rect cntx:(CGContextRef) context {
    UIBezierPath * shapePath = [self getPath:shape rect:rect];
    [self fillShape:[self getColor:color] with:fill forPath:shapePath rect:rect cntx:context];
}

-(void)fillShape:(UIColor *)color with:(Fill)fill forPath:(UIBezierPath *)path rect:(CGRect)rect cntx:(CGContextRef) context{
    self.borderWidth = MIN(rect.size.width, rect.size.height)*0.01;
    path.lineWidth = self.borderWidth;
    
    switch (fill) {
        case stripe:
            path = [self getStripedVersion:path rect:rect cntx:context];
            [color setStroke];
            [path stroke];
            CGContextSaveGState(context);
            CGContextResetClip(context);
            break;
        case solid:
            [color setFill];
            [color setStroke];
            [path fill];
            [path stroke];
            break;
        case unfilled:
            [color setStroke];
            [path stroke];
            break;
        default:
            break;
    }
}

-(CGRect)createRectForSingleShape:(CGSize)sizeOfSingleShapeRect{
    
    CGFloat x = CGRectGetMidX(self.bounds)-sizeOfSingleShapeRect.width/2;
    CGFloat y = CGRectGetMidY(self.bounds)-sizeOfSingleShapeRect.height/2;
    
    CGRect rectForSingleShape = CGRectMake(x, y, sizeOfSingleShapeRect.width, sizeOfSingleShapeRect.height);
    return rectForSingleShape;
}

-(NSMutableArray<NSValue *>*)createRectForTwoShapes:(CGSize)sizeOfSingleShapeRect{
    
    CGRect rectForSingleShape = [self createRectForSingleShape:sizeOfSingleShapeRect];
    
    CGRect firstRect = CGRectZero;
    CGRect secondRect= CGRectZero;
    
    if (self.bounds.size.width>self.bounds.size.height){
        firstRect = CGRectOffset(rectForSingleShape, -rectForSingleShape.size.width/2, 0);
        secondRect = CGRectOffset(rectForSingleShape, rectForSingleShape.size.width/2, 0);
    } else if (self.bounds.size.width<=self.bounds.size.height) {
        firstRect = CGRectOffset(rectForSingleShape, 0, -rectForSingleShape.size.height/2);
        secondRect = CGRectOffset(rectForSingleShape,0, rectForSingleShape.size.height/2);
    }
    
    NSMutableArray *arrayOfRectsForTwoShapes = [NSMutableArray array];
    [arrayOfRectsForTwoShapes addObject:[NSValue valueWithCGRect:firstRect]];
    [arrayOfRectsForTwoShapes addObject:[NSValue valueWithCGRect:secondRect]];
    return arrayOfRectsForTwoShapes;
}

-(NSMutableArray<NSValue *>*)createRectsForNumberOfShapes:(NSUInteger)count{
    if (count>3){
        return nil;
    }
    
    NSMutableArray *arrayOfRects = [NSMutableArray array];
    CGSize sizeOfRect = CGSizeMake(MAX(self.bounds.size.width, self.bounds.size.height)/3,MAX(self.bounds.size.width, self.bounds.size.height)/3);
    
    if (count == 1){
        [arrayOfRects addObject:[NSValue valueWithCGRect:[self createRectForSingleShape:sizeOfRect]]];
    } else if (count == 2){
        [arrayOfRects addObjectsFromArray:[self createRectForTwoShapes:sizeOfRect]];
    } else if (count == 3) {
        [arrayOfRects addObjectsFromArray:[self createRectForThreeShapes:sizeOfRect]];
    }
    
    return arrayOfRects;
}

-(NSMutableArray<NSValue *>*)createRectForThreeShapes:(CGSize)sizeOfSingleShapeRect{
    
    CGRect rectForSingleShape = [self createRectForSingleShape:sizeOfSingleShapeRect];
    
    CGRect firstRect = CGRectZero;
    CGRect secondRect= CGRectZero;
    
    if (self.bounds.size.width>self.bounds.size.height){
        firstRect = CGRectOffset(rectForSingleShape, -rectForSingleShape.size.width, 0);
        secondRect = CGRectOffset(rectForSingleShape, rectForSingleShape.size.width, 0);
    } else if (self.bounds.size.width<=self.bounds.size.height) {
        firstRect = CGRectOffset(rectForSingleShape, 0, -rectForSingleShape.size.height);
        secondRect = CGRectOffset(rectForSingleShape,0, rectForSingleShape.size.height);
    }
    
    NSMutableArray *arrayOfRectsForTwoShapes = [[NSMutableArray alloc]initWithObjects:@(firstRect),@(rectForSingleShape),@(secondRect), nil];
    return arrayOfRectsForTwoShapes;
}

-(UIBezierPath *)getPath:(Shape)shape rect:(CGRect)rect{
    switch (shape) {
        case oval:
            return [self ovalPath:rect];
            break;
        case diamond:
            return [self diamondPath:rect];
            break;
        case squiggle:
            return [self squigglePath:rect];
            break;
        default:
            break;
    }
    return  nil;
}

-(UIColor *)getColor:(Color)color{
    switch (color) {
        case red:
            return UIColor.redColor;
            break;
        case green:
            return UIColor.greenColor;
            break;
        case purple:
            return UIColor.purpleColor;
            break;
        default:
            break;
    }
    return nil;
}

-(UIBezierPath *)ovalPath:(CGRect)rect{
    
    CGFloat margin = MIN(rect.size.width, rect.size.height) * shapeMargin;
    CGRect rectForShape = CGRectMake(rect.origin.x + margin, rect.origin.y +margin, rect.size.width - 2*margin, rect.size.height-2*margin);
    UIBezierPath * ovalPath = [UIBezierPath bezierPathWithOvalInRect:rectForShape];
    return ovalPath;
}

-(UIBezierPath *)diamondPath:(CGRect)rect{
    
    CGFloat margin = MIN(rect.size.width, rect.size.height) * shapeMargin;
    UIBezierPath * diamondPath = [[UIBezierPath alloc]init];
    
    
    CGPoint topCenter = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect) + margin);
    CGPoint bottomCenter = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect) - margin);
    CGPoint rightCenter = CGPointMake(CGRectGetMaxX(rect)-margin, CGRectGetMidY(rect));
    CGPoint leftCenter = CGPointMake(CGRectGetMinX(rect)+margin, CGRectGetMidY(rect));
    
    
    [diamondPath moveToPoint:topCenter];
    [diamondPath addLineToPoint:rightCenter];
    [diamondPath addLineToPoint:bottomCenter];
    [diamondPath addLineToPoint:leftCenter];
    [diamondPath closePath];
    
    return diamondPath;
}

//got this from https://stackoverflow.com/questions/25387940/how-to-draw-a-perfect-squiggle-in-set-card-game-with-objective-c
-(UIBezierPath *)squigglePath:(CGRect)rect{
    CGFloat margin = MIN(rect.size.width, rect.size.height) * shapeMargin;
    CGRect rectForShape = CGRectInset(rect, margin, margin);
    
    UIBezierPath *squigglePath = [[UIBezierPath alloc] init];
    
    [squigglePath moveToPoint:CGPointMake(rectForShape.origin.x + rectForShape.size.width*0.05, rectForShape.origin.y + rectForShape.size.height*0.40)];
    
    [squigglePath addCurveToPoint:CGPointMake(rectForShape.origin.x + rectForShape.size.width*0.35, rectForShape.origin.y + rectForShape.size.height*0.25)
                    controlPoint1:CGPointMake(rectForShape.origin.x + rectForShape.size.width*0.09, rectForShape.origin.y + rectForShape.size.height*0.15)
                    controlPoint2:CGPointMake(rectForShape.origin.x + rectForShape.size.width*0.18, rectForShape.origin.y + rectForShape.size.height*0.10)];
    
    [squigglePath addCurveToPoint:CGPointMake(rectForShape.origin.x + rectForShape.size.width*0.75, rectForShape.origin.y + rectForShape.size.height*0.30)
                    controlPoint1:CGPointMake(rectForShape.origin.x + rectForShape.size.width*0.40, rectForShape.origin.y + rectForShape.size.height*0.30)
                    controlPoint2:CGPointMake(rectForShape.origin.x + rectForShape.size.width*0.60, rectForShape.origin.y + rectForShape.size.height*0.45)];
    
    [squigglePath addCurveToPoint:CGPointMake(rectForShape.origin.x + rectForShape.size.width*0.97, rectForShape.origin.y + rectForShape.size.height*0.35)
                    controlPoint1:CGPointMake(rectForShape.origin.x + rectForShape.size.width*0.87, rectForShape.origin.y + rectForShape.size.height*0.15)
                    controlPoint2:CGPointMake(rectForShape.origin.x + rectForShape.size.width*0.98, rectForShape.origin.y + rectForShape.size.height*0.00)];
    
    [squigglePath addCurveToPoint:CGPointMake(rectForShape.origin.x + rectForShape.size.width*0.45, rectForShape.origin.y + rectForShape.size.height*0.85)
                    controlPoint1:CGPointMake(rectForShape.origin.x + rectForShape.size.width*0.95, rectForShape.origin.y + rectForShape.size.height*1.10)
                    controlPoint2:CGPointMake(rectForShape.origin.x + rectForShape.size.width*0.50, rectForShape.origin.y + rectForShape.size.height*0.95)];
    
    [squigglePath addCurveToPoint:CGPointMake(rectForShape.origin.x + rectForShape.size.width*0.25, rectForShape.origin.y + rectForShape.size.height*0.85)
                    controlPoint1:CGPointMake(rectForShape.origin.x + rectForShape.size.width*0.40, rectForShape.origin.y + rectForShape.size.height*0.80)
                    controlPoint2:CGPointMake(rectForShape.origin.x + rectForShape.size.width*0.35, rectForShape.origin.y + rectForShape.size.height*0.75)];
    
    [squigglePath addCurveToPoint:CGPointMake(rectForShape.origin.x + rectForShape.size.width*0.05, rectForShape.origin.y + rectForShape.size.height*0.40)
                    controlPoint1:CGPointMake(rectForShape.origin.x + rectForShape.size.width*0.00, rectForShape.origin.y + rectForShape.size.height*1.10)
                    controlPoint2:CGPointMake(rectForShape.origin.x + rectForShape.size.width*0.005, rectForShape.origin.y + rectForShape.size.height*0.60)];
    
    [squigglePath closePath];
    
    return squigglePath;
}

-(UIBezierPath*)getStripedVersion:(UIBezierPath *)path rect:(CGRect)rect cntx:(CGContextRef) context {
    UIBezierPath *stripingPath = [[UIBezierPath alloc]init];
    CGPoint startingPoint= CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect)); // a point to the upper left corner of the rect
    for (CGFloat interval = CGRectGetMinX(rect);interval<CGRectGetMaxX(rect);interval+=(rect.size.width)/10.0){
        startingPoint.x=interval;
        [stripingPath moveToPoint:startingPoint];
        [stripingPath addLineToPoint:CGPointMake(startingPoint.x,CGRectGetMaxY(rect))];
    }
    
    [stripingPath closePath];
    [stripingPath appendPath:path];
    [stripingPath addClip];
    return stripingPath;
}

- (void)selected:(BOOL)isSelected{
    self.isSelected = isSelected;
    [self setNeedsDisplay];
}

@end
