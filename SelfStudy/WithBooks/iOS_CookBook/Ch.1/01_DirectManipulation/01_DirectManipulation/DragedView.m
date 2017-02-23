
//
//  DragedView.m
//  01_DirectManipulation
//
//  Created by Dabu on 2017. 2. 20..
//  Copyright © 2017년 Dabu. All rights reserved.
//

#import "DragedView.h"

@interface DragedView ()

@property (nonatomic) CGPoint startPoint;

@end

@implementation DragedView

- (instancetype)init {
    
    self = [super init];
    
    if (self != nil) {
        
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    self.startPoint = [[touches anyObject] locationInView:self];
    [self.superview bringSubviewToFront:self];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    CGPoint movedPoint = [[touches anyObject] locationInView:self];
    NSLog(@"%.1f : %.1f", movedPoint.x, movedPoint.y);
    
    float dx = movedPoint.x - _startPoint.x;
    float dy = movedPoint.y - _startPoint.y;
    CGPoint newcenter = CGPointMake(self.center.x + dx, self.center.y + dy);
    
    // Set new location
    self.center = newcenter;
}


@end
