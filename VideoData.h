//
//  VideoData.h
//  Video
//
//  Created by maquanhong on 12-11-1.
//  
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@protocol  VideoDataDelegate<NSObject>
@optional
- (void)videoStatusLoaded;
- (void)videoStatusCanceled;
- (void)videoStatusFailed:(NSError *)error;
- (void)videoInPhotoLibaryUrlFounded;
@end
@interface VideoData : NSObject
{
    NSURL   *videoUrl;
    AVURLAsset  *avURLSet;
    AVAssetImageGenerator *imageGenerator;
    AVAssetExportSession *exportSession;
}

@property(nonatomic,retain) NSURL   *videoUrl;
@property(nonatomic,retain) AVURLAsset  *avURLSet;
@property(assign) id<VideoDataDelegate> delegate;

- (void)videoInPhotoLibary;

- (void)operationOnVideo:(NSURL *)url;

//产生从一个时间点到另一个时间点的所有图片
- (void)generateImagesAtTimes:(NSArray *)array;

//把视频转换成另一种格式
- (void)exportVideoToFormat:(NSString *)format;

//取消转换
- (void)cancelExport;



@end
