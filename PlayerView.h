//
//  PlayerView.h
//  Video
//
//  Created by wei hua on 12-11-2.
//  
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@class PlayerView;
@protocol PlayerViewDelegate <NSObject>
@optional
- (void)touch:(PlayerView *)playerView;

@end

@interface PlayerView : UIView
{
    AVPlayer *player;
}

@property(nonatomic,assign) AVPlayer  *player;
@property(nonatomic,assign) id <PlayerViewDelegate> delegate;
@end
