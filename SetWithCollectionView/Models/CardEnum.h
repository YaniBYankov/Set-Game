//
//  CardEnum.h
//  SetWithCollectionView
//
//  Created by Yani Yankov on 23.08.23.
//

#ifndef CardEnum_h
#define CardEnum_h

typedef enum : NSUInteger {
    green=0,
    red,
    purple,
    colorCnt
} Color;

typedef enum : NSUInteger {
    diamond=0,
    oval,
    squiggle,
    shapeCnt
} Shape;

typedef enum : NSUInteger {
    stripe=0,
    solid,
    unfilled,
    fillCnt
}Fill;

#endif /* CardEnum_h */
