//
//  FXZVideoView.h
//  FXZ
//
//  Created by maquanhong on 3/22/13.
//
//

#import <UIKit/UIKit.h>
#import "PlayerController.h"
#import "PlayerView.h"

@interface FXZVideoView : UIView<PlayerControllerDelegate,PlayerViewDelegate>
{
    PlayerController  *playerController;
    UILabel    *currentPlayTimeLabel;  //显示正在播放的时间点
    PlayerView   *playerView;
    UIButton    *playerBtn;
    UILabel   *playTotalTimeAndSizeLabel; //显示总时间和视频大小
}

@property(nonatomic,retain) PlayerController  *playerController;
@property(nonatomic,retain) PlayerView  *playerView;
@property(nonatomic,retain) UIButton  *playerBtn;

- (void)loadAssetFromFile:(NSURL *)fileUrl;
- (void)syncUI;
- (void)clearWhenDispear;
- (void)play;
- (void)stop;
- (void)setVideoPressgress:(CGFloat)videoProgress; //设置视频播放进度,videoProgress值为0-1

@end
