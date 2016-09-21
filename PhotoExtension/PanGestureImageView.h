//
//  PanGestureImageView.h
//  PhotoFiltster
//
//  Created by Rany on 16/9/21.
//  Copyright © 2016年 Rany. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PanGestureLocationBlock)(CGPoint point);

@interface PanGestureImageView : UIImageView
{
    PanGestureLocationBlock _locationBlock;
}

- (void)panGestureLocation:(PanGestureLocationBlock)locationBlock;
@end
