//
//  VideoPlayView.h


#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface VideoPlayView : UIView
/** 快速创建 */
+ (instancetype)videoPlayView;

/** 需要播放的视频资源 */
@property (nonatomic,copy) NSString *urlString;

/* 横屏包含在哪一个控制器中 */
@property (nonatomic, weak) UIViewController *contrainerViewController;

@end
