//
//  CustomCell.h
//  PhotoFiltster
//
//  Created by Rany on 16/9/21.
//  Copyright © 2016年 Rany. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CoverDismissBlock)();

@interface CustomCell : UICollectionViewCell

{
    CoverDismissBlock _coverDismissBlock;
}
@property (strong, nonatomic) IBOutlet UIImageView *cell_imageView;
@property (strong, nonatomic) IBOutlet UIControl *coverView;


-(void)coverDismiss:(CoverDismissBlock)block;

@end
