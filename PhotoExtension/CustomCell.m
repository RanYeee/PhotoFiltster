//
//  CustomCell.m
//  PhotoFiltster
//
//  Created by Rany on 16/9/21.
//  Copyright © 2016年 Rany. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell

- (IBAction)showOrHideCoverView:(UIControl *)sender {
    
    sender.hidden = YES;
    
    if (_coverDismissBlock) {
        
        _coverDismissBlock();
    }
    
}

-(void)coverDismiss:(CoverDismissBlock)block
{
    _coverDismissBlock = block;
}


@end
