//
//  PlayerController.h
//  Video
//
//  Created by maquanhong on 12-11-1.
// 
//

#import <Foundation/Foundation.h>
#import "VideoData.h"
@protocol PlayerControllerDelegate<NSObject>
@optional
- (void)videoStatusLoaded;
- (void)videoStatusCanceled;
- (void)videoStatusFailed:(NSError *)error;
- (void)videoInPhotoLibaryUrlFounded;
- (void)synInterface;
- (void)updateLeftTime:(NSString *)timeStr;
- (void)videoReachEnd;
@end
@interface PlayerController : NSObject<VideoDataDelegate>
{
    VideoData   *videoData;
    AVPlayerItem  *playerItem;
    AVPlayer  *player;
    float   rate;
    id playerObserver; //实时观察播放的时间属性
    NSMutableArray  *videoUrlInPhotoArrray;
    long long videoSize;  //记录视频文件的大小
    CMTimeScale _videoScale;
    BOOL  reachEnd;
}
@property(nonatomic,retain) AVPlayerItem  *playerItem;
@property(nonatomic,retain) AVPlayer  *player;
@property(nonatomic,assign) float rate;
@property(nonatomic,retain) id playerObserver;
@property(nonatomic,assign) id<PlayerControllerDelegate> delegate;
@property(nonatomic,retain) NSMutableArray  *videoUrlInPhotoArray;
@property(assign) BOOL reachEnd;

//播放本地视频文件
- (void)playVideo:(NSURL *)videoUrl;

//播放网络视频文件，http live stream
-(void)playHttpLiveStream:(NSURL *)videoUrl;

//设置视频播放速度
- (void)setVideoRate:(float)videoRate;

//设置播放位置
- (void)seekVideoToTime:(CMTime)time;


- (void)play;

- (void)firstVideoFileInLibray;

- (void)stop;

//获取视频长度信息（秒）
- (double)videoDuration;

//获取视频大小信息 （KB）
- (long long )videoSize;

//移出观察者
- (void)removeTimeObserver;

//获取视频帧率
- (CMTimeScale)videoScale;


@end
