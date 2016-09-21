//
//  FiltsterFilter.h
//  PhotoFiltster
//
//  Created by Rany on 16/9/20.
//  Copyright © 2016年 Rany. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@protocol FiltsterFilterDelegate <NSObject>

- (void)outputImageDidUpdate:(CIImage *)outputImage;

@end

@interface FiltsterFilter : NSObject

@property (nonatomic ,strong) CIImage *outputImage;

@property (nonatomic ,weak) id<FiltsterFilterDelegate>delegate;

@end
