//
//  PhotoEditingViewController.m
//  PhotoExtension
//
//  Created by Rany on 16/9/20.
//  Copyright © 2016年 Rany. All rights reserved.
//

#import "PhotoEditingViewController.h"
#import <Photos/Photos.h>
#import <PhotosUI/PhotosUI.h>
#import "CustomCell.h"
#import "PanGestureImageView.h"
static NSString *formatIdentifier = @"com.shinobicontrols.filtster";

static NSString *formatVersion    = @"1.0";


@interface PhotoEditingViewController () <PHContentEditingController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    BOOL _isToolViewHidden;
    
    UIImage *_selectImage;
    
    CGPoint _iconPoint;
}
@property (strong) PHContentEditingInput *input;

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIView *toolView;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation PhotoEditingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 

  
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    
    CGRect imageRect = self.imageView.frame;
    
    imageRect.origin.y -= self.toolView.frame.size.height/2.5;
    
    self.imageView.frame = imageRect;
}

#pragma mark - PHContentEditingController

- (BOOL)canHandleAdjustmentData:(PHAdjustmentData *)adjustmentData {

    return NO;
}

- (void)startContentEditingWithInput:(PHContentEditingInput *)contentEditingInput placeholderImage:(UIImage *)placeholderImage {

    NSLog(@">>>>>>starContent");
    
    self.input = contentEditingInput;
    
    self.imageView.image = placeholderImage;
    
}

- (void)finishContentEditingWithCompletionHandler:(void (^)(PHContentEditingOutput *))completionHandler {
    // Update UI to reflect that editing has finished and output is being rendered.
    
    // Render and provide output on a background queue.
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0), ^{
        // Create editing output from the editing input.
        
        PHContentEditingOutput *output = [[PHContentEditingOutput alloc] initWithContentEditingInput:self.input];
        
        NSData *imageData = UIImageJPEGRepresentation([self addImageLogo:self.imageView.image text:_selectImage],1);
        
        PHAdjustmentData *adjustmentData = [[PHAdjustmentData alloc]initWithFormatIdentifier:formatIdentifier formatVersion:formatVersion data:imageData];
        
        // Provide new adjustments and render output to given location.
        output.adjustmentData = adjustmentData;
        
        NSData *renderedJPEGData = imageData;
        
        [renderedJPEGData writeToURL:output.renderedContentURL atomically:YES];
        
        // Call completion handler to commit edit to Photos.
        
        NSLog(@">>>>>>finishContent");
        
        completionHandler(output);
        
        // Clean up temporary files, etc.
    });
}

- (BOOL)shouldShowCancelConfirmation {
    // Returns whether a confirmation to discard changes should be shown to the user on cancel.
    // (Typically, you should return YES if there are any unsaved changes.)
    return YES;
}

- (void)cancelContentEditing {
    // Clean up temporary files, etc.
    // May be called after finishContentEditingWithCompletionHandler: while you prepare output.
}


- (IBAction)hideOrShowToolView:(id)sender {
    
    
//    self.toolView.hidden = !_isToolViewHidden;
    
    if (_isToolViewHidden) {
        
        [UIView animateWithDuration:0.3 animations:^{
           
        
            CGRect imageRect = self.imageView.frame;
            
            imageRect.origin.y -= self.toolView.frame.size.height/2.5;
            
            self.imageView.frame = imageRect;
            
            
            CGRect toolRect = self.toolView.frame;
            
            toolRect.origin.y -= toolRect.size.height;
            
            self.toolView.frame = toolRect;
            
        }];
        
    }else{
        
        [UIView animateWithDuration:0.3 animations:^{
            
            
            CGRect imageRect = self.imageView.frame;
            
            imageRect.origin.y = 0;
            
            self.imageView.frame = imageRect;
            
            
            CGRect toolRect = self.toolView.frame;
            
            toolRect.origin.y += toolRect.size.height;
            
            self.toolView.frame = toolRect;
            
            
        }];
    }
    
    _isToolViewHidden = !_isToolViewHidden;
}

#pragma mark - collection delegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCellId" forIndexPath:indexPath];
    
    
    
    cell.cell_imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_%d.png",indexPath.row+1]];
    
    
    return cell;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 12;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.view.bounds.size.width/3-5, self.collectionView.frame.size.height);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CustomCell *cell = (CustomCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    cell.coverView.hidden = !cell.coverView.isHidden;
    
 
    _selectImage = [UIImage imageNamed:[NSString stringWithFormat:@"icon_%d.png",indexPath.row+1]];
    
    __block PanGestureImageView *addImageView = [[PanGestureImageView alloc]initWithFrame:CGRectMake(10, self.imageView.center.y, 60, 60)];
    
    addImageView.image = _selectImage;
    
    __weak typeof(self) weakSelf = self;
    
    [addImageView panGestureLocation:^(CGPoint point) {
       
        CGPoint tmpPoint = addImageView.frame.origin;
        
        CGFloat imageViewH = self.imageView.frame.size.height;
        
        _iconPoint = CGPointMake(self.imageView.image.size.width * (tmpPoint.x/weakSelf.imageView.frame.size.width), self.imageView.image.size.height * ( tmpPoint.y/weakSelf.imageView.frame.size.height));
        
        NSLog(@">>>>>>>%@",NSStringFromCGPoint(addImageView.frame.origin));
    }];
    
    [self.imageView addSubview:addImageView];
    
    [cell coverDismiss:^{
        
        [addImageView removeFromSuperview];

        addImageView = nil;
    }];
}

-(UIImage *)addImageLogo:(UIImage *)img text:(UIImage *)logo
{
    CGFloat selectImageW = 60.0f;
    
    CGFloat orginImageW = self.imageView.frame.size.width;
    
    CGFloat persen = selectImageW/orginImageW;
    
    //get image width and height
    int w = img.size.width;
    int h = img.size.height;
    int logoWidth = logo.size.width;
    int logoHeight = logo.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    //create a graphic context with CGBitmapContextCreate
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 44 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
    CGContextDrawImage(context, CGRectMake(_iconPoint.x , _iconPoint.y, w*persen, w*persen), [logo CGImage]);
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return [UIImage imageWithCGImage:imageMasked];
    // CGContextDrawImage(contextRef, CGRectMake(100, 50, 200, 80), [smallImg CGImage]);
}
@end
