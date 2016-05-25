//
//  VideoPlayView.m


#import "VideoPlayView.h"
#import "FullViewController.h"

@interface VideoPlayView()

/** 背景图片 */
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
/** 工具栏     */
@property (strong, nonatomic) IBOutlet UIView *toolView;
/** 开始暂停按钮 */
@property (strong, nonatomic) IBOutlet UIButton *playOrPauseBtn;
/** 滑动条 */
@property (strong, nonatomic) IBOutlet UISlider *progressSlider;
/** 时间Label*/
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

/** 播放器 */
@property (nonatomic,strong) AVPlayer *player;

/** 播放器的Layer */
@property (nonatomic,strong) AVPlayerLayer *playerLayer;

/** playItem */
@property (nonatomic,strong) AVPlayerItem *playerItem;

/** 记录当前是否显示了工具栏 */
@property (nonatomic,assign) BOOL isShowToolView;

/* 定时器 */
@property (nonatomic, strong) NSTimer *progressTimer;

/* 工具栏的显示和隐藏 */
@property (nonatomic, strong) NSTimer *showTimer;

/* 工具栏展示的时间 */
@property (assign, nonatomic) NSTimeInterval showTime;

/* 全屏控制器 */
@property (nonatomic, strong) FullViewController *fullVc;

/** 播放按钮 */
@property (weak, nonatomic) IBOutlet UIButton *playerBtn;

#pragma mark - 监听事件的处理
- (IBAction)playOrPause:(UIButton *)sender;
- (IBAction)switchOrientation:(UIButton *)sender;
- (IBAction)slider;
- (IBAction)startSlider;
- (IBAction)sliderValueChange;

- (IBAction)tapAction:(UITapGestureRecognizer *)sender;
- (IBAction)swipeAction:(UISwipeGestureRecognizer *)sender;
- (IBAction)swipeRight:(UISwipeGestureRecognizer *)sender;

@end

@implementation VideoPlayView


+ (instancetype)videoPlayView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"VideoPlayView" owner:nil options:nil] firstObject];
}

#pragma mark - 加载xib的时候调用
- (void)awakeFromNib
{
    // 1.初始化Player
    self.player = [[AVPlayer alloc] init];
    
    // 2.初始化PlayerLayer
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    
    // 3.将PlayerLayer添加到图片的layer层
    [self.imageView.layer addSublayer:self.playerLayer];
    
    // 4.设置工具类默认不显示
    self.toolView.alpha = 0;
    
    // 5.记录工具栏的显示状态为NO
    self.isShowToolView = NO;
    
    // 6.设置进度条的内容
    [self.progressSlider setThumbImage:[UIImage imageNamed:@"thumbImage"] forState:UIControlStateNormal];
    [self.progressSlider setMaximumTrackImage:[UIImage imageNamed:@"MaximumTrackImage"] forState:UIControlStateNormal];
    [self.progressSlider setMinimumTrackImage:[UIImage imageNamed:@"MinimumTrackImage"] forState:UIControlStateNormal];
    
    // 7.设置按钮的状态(设置为非播放状态)
    self.playOrPauseBtn.selected = NO;
}

#pragma mark - 重新布局
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 设置playerLayer的frame
    self.playerLayer.frame = self.bounds;
}


#pragma mark - 设置播放的视频
- (void)setUrlString:(NSString *)urlString
{
    // 0.移除上次监听
    if (self.playerItem) { // 存在item就
        [self.playerItem removeObserver:self forKeyPath:@"status"];
    }
    
    // 1.保存视频资源字符串
    _urlString = urlString;
    
    // 2.创建PlayerItem
    NSURL *url = [NSURL URLWithString:urlString];
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:url];
    self.playerItem = item;
    
    // 3.切换到当前的playerItem
    [self.player replaceCurrentItemWithPlayerItem:self.playerItem];
    
    // 4.KVO监听playerItem的状态的改变
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    
 
}

#pragma mark - 观察者对应的方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerItemStatus status = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
        if (AVPlayerItemStatusReadyToPlay == status) {
            [self removeProgressTimer];
            [self addProgressTimer];
        } else {
            [self removeProgressTimer];
        }
    }
}


// 是否显示工具的View
- (IBAction)tapAction:(UITapGestureRecognizer *)sender {
    [self showToolView:!self.isShowToolView];
    
    if (self.isShowToolView) {
        [self addShowTimer];
    }
}

- (void)showToolView:(BOOL)isShow
{
    [UIView animateWithDuration:0.5 animations:^{
        self.toolView.alpha = !self.isShowToolView;
        self.isShowToolView = !self.isShowToolView;
    }];
}

#pragma mark - 快进与快退
- (IBAction)swipeAction:(UISwipeGestureRecognizer *)sender {
    [self swipeToRight:YES];
}

- (IBAction)swipeRight:(UISwipeGestureRecognizer *)sender {
    [self swipeToRight:NO];
}

- (void)swipeToRight:(BOOL)isRight
{
    // 1.获取当前播放的时间
    NSTimeInterval currentTime = CMTimeGetSeconds(self.player.currentItem.currentTime);
    
    // 2.如果是往右滑动则+10秒.反之减10秒
    if (isRight) {
        currentTime += 10;
    } else {
        currentTime -= 10;
    }
    
    // 3.保证时间不低于0,以及不超过总时间
    if (currentTime >= CMTimeGetSeconds(self.player.currentItem.duration)) {
        currentTime = CMTimeGetSeconds(self.player.currentItem.duration) - 1;
    } else if (currentTime <= 0) {
        currentTime = 0;
    }
    
    // 4.更新时间
    [self.player seekToTime:CMTimeMakeWithSeconds(currentTime, NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    
    // 5.更新显示时间以及滑块
    [self updateProgressInfo];
}

- (IBAction)playBtnClick:(id)sender {
    [self playOrPause:self.playOrPauseBtn];
}


#pragma mark -  暂停按钮的监听
- (IBAction)playOrPause:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.player play];
        self.playerBtn.hidden = YES;
        [self addProgressTimer];
    } else {
        [self.player pause];
        self.playerBtn.hidden = NO;
        [self removeProgressTimer];
    }
}

#pragma mark - 定时器操作
- (void)addProgressTimer
{
    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateProgressInfo) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.progressTimer forMode:NSRunLoopCommonModes];
}

- (void)removeProgressTimer
{
    [self.progressTimer invalidate];
    self.progressTimer = nil;
}

- (void)updateProgressInfo
{
    // 1.更新时间
    self.timeLabel.text = [self timeString];
    
    // 2.更新滑块
    self.progressSlider.value = CMTimeGetSeconds(self.player.currentTime) / CMTimeGetSeconds(self.player.currentItem.duration);
}

#pragma mark - 时间的处理
- (NSString *)timeString
{
    NSTimeInterval duration = CMTimeGetSeconds(self.player.currentItem.duration);
    NSTimeInterval currentTime = CMTimeGetSeconds(self.player.currentTime);
    
    return [self stringWithCurrentTime:currentTime duration:duration];
}

#pragma mark - 工具栏的定时器
- (void)addShowTimer
{
    self.showTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(updateShowTime) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.showTimer forMode:NSRunLoopCommonModes];
}

- (void)removeShowTimer
{
    [self.showTimer invalidate];
    self.showTimer = nil;
}

- (void)updateShowTime
{
    self.showTime += 1;
    
    if (self.showTime > 2.0) {
        [self tapAction:nil];
        [self removeShowTimer];
        
        self.showTime = 0;
    }
}

#pragma mark - 切换屏幕的方向
- (IBAction)switchOrientation:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    [self videoplayViewSwitchOrientation:sender.selected];
}

- (void)videoplayViewSwitchOrientation:(BOOL)isFull
{
    if (isFull) { // 从非全屏切换到全屏
        [self.contrainerViewController presentViewController:self.fullVc animated:NO completion:^{
            [self.fullVc.view addSubview:self];
            self.center = self.fullVc.view.center;
            
            [UIView animateWithDuration:0.15 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
                self.frame = self.fullVc.view.bounds;
            } completion:nil];
        }];
    } else { // 从全屏切换到非全屏
        [self.fullVc dismissViewControllerAnimated:NO completion:^{
            [self.contrainerViewController.view addSubview:self];
            
            [UIView animateWithDuration:0.15 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
                self.frame = CGRectMake(0, 0, self.contrainerViewController.view.bounds.size.width, self.contrainerViewController.view.bounds.size.width * 9 / 16);
            } completion:nil];
        }];
    }
}

#pragma mark - 对滑块的处理
- (IBAction)slider {
    [self addProgressTimer];
    NSTimeInterval currentTime = CMTimeGetSeconds(self.player.currentItem.duration) * self.progressSlider.value;
    [self.player seekToTime:CMTimeMakeWithSeconds(currentTime, NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
}

- (IBAction)startSlider {
    [self removeProgressTimer];
}

- (IBAction)sliderValueChange {
    NSTimeInterval currentTime = CMTimeGetSeconds(self.player.currentItem.duration) * self.progressSlider.value;
    NSTimeInterval duration = CMTimeGetSeconds(self.player.currentItem.duration);
    self.timeLabel.text = [self stringWithCurrentTime:currentTime duration:duration];
}

- (NSString *)stringWithCurrentTime:(NSTimeInterval)currentTime duration:(NSTimeInterval)duration
{
    NSInteger dMin = duration / 60;
    NSInteger dSec = (NSInteger)duration % 60;
    
    NSInteger cMin = currentTime / 60;
    NSInteger cSec = (NSInteger)currentTime % 60;
    
    NSString *durationString = [NSString stringWithFormat:@"%02ld:%02ld", dMin, dSec];
    NSString *currentString = [NSString stringWithFormat:@"%02ld:%02ld", cMin, cSec];
    
    return [NSString stringWithFormat:@"%@/%@", currentString, durationString];
}

#pragma mark - 懒加载代码
- (FullViewController *)fullVc
{
    if (_fullVc == nil) {
        _fullVc = [[FullViewController alloc] init];
    }
    return _fullVc;
}

- (void)dealloc {
    // 移除监听
    if (self.playerItem) {
        [self.playerItem removeObserver:self forKeyPath:@"status"];
    }
}

@end
