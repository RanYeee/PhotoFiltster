//
//  PanGestureImageView.m
//  PhotoFiltster
//
//  Created by Rany on 16/9/21.
//  Copyright © 2016年 Rany. All rights reserved.
//

#import "PanGestureImageView.h"

@implementation PanGestureImageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.frame = frame;
        
        self.userInteractionEnabled = YES;
        
        self.contentMode = UIViewContentModeScaleAspectFill;
        
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePanGestures:)];
        
        [self addGestureRecognizer:panGesture];
        
        
    }
    
    return self;
}


- (void)handlePanGestures:(UIGestureRecognizer *)paramSender
{
    if (paramSender.state != UIGestureRecognizerStateEnded && paramSender.state != UIGestureRecognizerStateFailed){
        //通过使用 locationInView 这个方法,来获取到手势的坐标
        CGPoint location = [paramSender locationInView:paramSender.view.superview];
        paramSender.view.center = location;
        
//        NSLog(@"%@",NSStringFromCGPoint(location));
        
        if (_locationBlock) {
            
            _locationBlock(location);
        }
    }
    
    
}

-(void)panGestureLocation:(PanGestureLocationBlock)locationBlock
{
    _locationBlock = locationBlock;
}

@end
