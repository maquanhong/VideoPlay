//
//  PlayerController.m
//  Video
//
//  Created by maquanhong on 12-11-1.
//  
//

#import "PlayerController.h"
static const NSString *ItemStatusContext;

@interface PlayerController()
- (long long )videoSize:(NSURL *)videoUrl;

@end

@implementation PlayerController
@synthesize playerItem;
@synthesize player;
@synthesize rate;
@synthesize playerObserver;
@synthesize delegate;
@synthesize videoUrlInPhotoArray;
@synthesize reachEnd;

-(id)init
{
    self = [super init];
    if (self) {
        videoData = [[VideoData alloc] init];
        videoData.delegate = self;
        player = nil;
        playerItem = nil;
        playerObserver = nil;
        videoUrlInPhotoArray = [[NSMutableArray alloc] initWithCapacity:0];
        reachEnd = NO;
    }
    return self;
}

- (void)play
{
    //在此处可以进行速率和位置的设置，也可以添加player的状态
    if (rate >= 0) {
        player.rate = rate;
    }
    
    [player play];
    reachEnd = NO;
    player.actionAtItemEnd = AVPlayerActionAtItemEndPause;

}

- (void)stop
{
    [player pause];
}


- (double)videoDuration
{
    return CMTimeGetSeconds(player.currentItem.asset.duration);
}

- (long long )videoSize
{
    return videoSize / 1000;
}

- (void)setVideoRate:(float)videoRate
{
    player.rate = videoRate;
}

- (void)seekVideoToTime:(CMTime)time
{
    [player seekToTime:time];
}

- (void)removeTimeObserver
{
   
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
    [playerItem removeObserver:self forKeyPath:@"status" context:&ItemStatusContext];
     [self.player removeTimeObserver:playerObserver];
    playerObserver = nil;
}

#pragma mark local file

- (void)firstVideoFileInLibray
{
     [videoData videoInPhotoLibary];
}

- (void)playVideo:(NSURL *)videoUrl
{
    [videoData operationOnVideo:videoUrl];
    //获取文件大小
    videoSize = [self videoSize:videoUrl];
}

- (long long)videoSize:(NSURL *)videoUrl
{
    long long size = 0;
   NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:videoUrl.absoluteString]) {
        NSDictionary * properties = [[NSFileManager defaultManager] attributesOfItemAtPath:videoUrl.absoluteString error:nil];
        NSNumber * fileSizeNmu = [properties objectForKey: NSFileSize];
        size = [fileSizeNmu longLongValue];
    }
    
    return size;
}

- (void)loadVideo
{
    self.playerItem = [AVPlayerItem playerItemWithAsset:videoData.avURLSet];
    [playerItem addObserver:self forKeyPath:@"status" options:0 context:&ItemStatusContext];
    //    //监视视频是否到达了末尾
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidReachEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
    self.player = [AVPlayer playerWithPlayerItem:playerItem];
    self->playerObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, NSEC_PER_SEC) queue:NULL usingBlock:^(CMTime time) {
        //显示剩余时间
        NSInteger leftDuration = (NSInteger)CMTimeGetSeconds(time);
        NSString *leftDurationStr = nil;
        if (leftDuration >= 10) {
            leftDurationStr = [NSString stringWithFormat:@"00:%i", leftDuration];
        }else
        {
            leftDurationStr = [NSString stringWithFormat:@"00:0%i",leftDuration];
        }
        if (delegate && [delegate respondsToSelector:@selector(updateLeftTime:)]) {
            [delegate updateLeftTime:leftDurationStr];
        }
    }];
    if (delegate && [delegate respondsToSelector:@selector(videoStatusLoaded)]) {
        //记录视频帧率
        _videoScale = player.currentTime.timescale;
        [delegate videoStatusLoaded];
    }
}

- (CMTimeScale)videoScale
{
    return _videoScale;
}

- (void)videoStatusLoaded
{
    [self loadVideo];
}

- (void)videoStatusFailed:(NSError *)error
{}

- (void)videoStatusCanceled
{}

- (void)playerItemDidReachEnd:(NSNotification *)notification
{
    reachEnd = YES;
    [player seekToTime:kCMTimeZero];
    if (delegate && [delegate respondsToSelector:@selector(videoReachEnd)]) {
        //把视频重置到开始位置
      
        [delegate videoReachEnd];
    }

}

- (void)videoInPhotoLibaryUrlFounded
{
    [videoUrlInPhotoArray addObject:videoData.videoUrl];
    if (delegate && [delegate respondsToSelector:@selector(videoInPhotoLibaryUrlFounded)]) {
        [delegate videoInPhotoLibaryUrlFounded];
    }
}

#pragma mark http live stream
- (void)playHttpLiveStream:(NSURL *)videoUrl
{
    self.playerItem = [AVPlayerItem playerItemWithURL:videoUrl];
    [playerItem addObserver:self forKeyPath:@"status" options:0 context:nil];
    self.player = [AVPlayer playerWithPlayerItem:playerItem];
    self->playerObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, NSEC_PER_SEC) queue:NULL usingBlock:^(CMTime time) {
        //显示剩余时间
        double leftDuration = CMTimeGetSeconds(time);
    }];
}


- (void)observeValueForKeyPath:(NSString *)keyPath 
                      ofObject:(id)object 
                        change:(NSDictionary *)change 
                       context:(void *)context
{
    if (context == &ItemStatusContext) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (delegate && [delegate respondsToSelector:@selector(synInterface)]) {
                [delegate synInterface];
            }
        });
        return;
    }    
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

@end
