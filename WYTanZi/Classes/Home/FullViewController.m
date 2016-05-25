//
//  FullViewController.m


#import "FullViewController.h"

@interface FullViewController ()

@end

@implementation FullViewController

#pragma mark - 仅允许竖屏
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

#pragma mark - 是否支持指定的屏幕方向
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

@end
