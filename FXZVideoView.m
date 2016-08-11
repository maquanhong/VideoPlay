//
//  FXZVideoView.m
//  FXZ
//
//  Created by maquanhong on 3/22/13.
//
//

#import "FXZVideoView.h"

@implementation FXZVideoView
@synthesize playerController;
@synthesize playerView;
@synthesize playerBtn;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        playerController = [[PlayerController alloc] init];
        playerController.delegate = self;
        
        playerView = [[PlayerView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        
        playerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        playerView.delegate = self;
        [(AVPlayerLayer *)[playerView layer] setVideoGravity:AVLayerVideoGravityResize];
        
        UIImage *playIcon = [UIImage imageNamed:@"play_icon.png"];
        playerBtn = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width / 2 - playIcon.size.width / 2, frame.size.height / 2 - playIcon.size.height / 2, playIcon.size.width, playIcon.size.height)];
        [playerBtn setBackgroundImage:playIcon forState:UIControlStateNormal];
        [playerBtn addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
        playerBtn.hidden = YES;
        
        //    videoNavBar = [[FXZVideoNavBar alloc] initWithFrame:CGRectMake(0, -44, 320, 44)];
        //    videoNavBar.delegate = self;
        
        playTotalTimeAndSizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 20)];
        playTotalTimeAndSizeLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:playTotalTimeAndSizeLabel];
        
        [self addSubview:playerView];
        
        currentPlayTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height - 20, frame.size.width, 20)];
        currentPlayTimeLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:currentPlayTimeLabel];
        
        //    [self.view addSubview:videoNavBar];
        [self addSubview:playerBtn];
        [self loadAssetFromFile:nil];
    }
    return self;
}

#pragma mark PlayerControllerDelegate
- (void)videoStatusLoaded
{
    [playerView setPlayer:playerController.player];
    [playerController play];
    //设置显示视频信息和长度的标签
    NSString * sizeStr = [NSString stringWithFormat:@"%lld",[playerController videoSize]];
    NSString * durationStr = [NSString stringWithFormat:@"00:%i",(NSInteger)[playerController videoDuration]];
    NSString *sizeAndDuration = [NSString stringWithFormat:@"%@",durationStr];
    playTotalTimeAndSizeLabel.text = sizeAndDuration;
}

- (void)updateLeftTime:(NSString *)timeStr
{
    currentPlayTimeLabel.text = timeStr;
}

- (void)synInterface
{
    [self syncUI];
}

- (void)videoInPhotoLibaryUrlFounded
{
    NSMutableArray *array = playerController.videoUrlInPhotoArray;
    [playerController playVideo:[array objectAtIndex:0]];
}

- (void)play:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    [playerController play];
    btn.hidden = !btn.hidden;
    //    //隐藏导航栏
    //    [self hideNavBar];
    //隐藏状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    
    
}

- (void)videoReachEnd
{
    playerBtn.hidden = !playerBtn.hidden;
}

- (void)loadAssetFromFile:(NSURL *)fileUrl
{
    if (fileUrl == nil) {
        [playerController  firstVideoFileInLibray];
        
    }
}




- (void)syncUI
{
    if ((playerController.player.currentItem != nil) && ([self.playerController.player.currentItem status] == AVPlayerItemStatusReadyToPlay)) {
        self.playerBtn.enabled = YES;
    }else
    {
        self.playerBtn.enabled = NO;
    }
}

- (void)clearWhenDispear
{
    [playerController stop];
    [playerController removeTimeObserver];
    [playerView setPlayer:nil];
}

- (void)stop
{
    [playerController stop];
}

- (void)play
{
    [playerController play];
}

- (void)setVideoPressgress:(CGFloat)videoPressgress
{
    double videoDuration = [playerController videoDuration];
    CMTime currentTime = CMTimeMake(videoDuration, [playerController videoScale]);
    [playerController seekVideoToTime:currentTime];
}


#pragma mark PlayerViewDelegate
- (void)touch:(PlayerView *)playerView
{
    //如果视频正在播放，则暂停视频
    BOOL play = (abs(playerController.player.rate - 1.0) < 0.001);
    if (play) {

    }else
    {
        [playerController play];
    }
    playerBtn.hidden = !playerBtn.hidden;
}

- (void)dealloc
{
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
