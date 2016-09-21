//
//  FiltsterFilter.m
//  PhotoFiltster
//
//  Created by Rany on 16/9/20.
//  Copyright © 2016年 Rany. All rights reserved.
//

#import "FiltsterFilter.h"

@implementation FiltsterFilter


- (void)performFilter
{
    if (self.delegate) {
        
        [self.delegate outputImageDidUpdate:self.outputImage];
    }
}



@end
