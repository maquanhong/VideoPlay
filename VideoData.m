//
//  VideoData.m
//  Video
//
//  Created by maquanhong on 12-11-1.
//  
//

#import "VideoData.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreMedia/CoreMedia.h>

@implementation VideoData
@synthesize videoUrl;
@synthesize avURLSet;
@synthesize delegate;

- (id)init
{
    self = [super init];
    if (self) {
        avURLSet = nil;
        imageGenerator = nil;
        videoUrl = nil;
        exportSession = nil;
    }
    return self;
}

- (void)videoInPhotoLibary
{
    ALAssetsLibrary *libary = [[ALAssetsLibrary alloc] init];
    [libary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        [group setAssetsFilter:[ALAssetsFilter allVideos]];
        [group enumerateAssetsAtIndexes:[NSIndexSet indexSetWithIndex:0] options:0 usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if (result) {
                ALAssetRepresentation *representation = [result defaultRepresentation];
                self.videoUrl = representation.url;
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (delegate && [delegate respondsToSelector:@selector(videoInPhotoLibaryUrlFounded)]) {
                        [delegate videoInPhotoLibaryUrlFounded];
                    }
                });
            }
        }];
    } failureBlock:^(NSError *error) {
        
    }];
}

- (void)operationOnVideo:(NSURL *)url
{
    avURLSet = [[AVURLAsset alloc] initWithURL:url options:nil];
    NSArray *keys = [NSArray arrayWithObject:@"duration"];
    [avURLSet loadValuesAsynchronouslyForKeys:keys completionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSError *error = nil;
            AVKeyValueStatus tracksStatus = [avURLSet statusOfValueForKey:@"duration" error:&error];
            switch (tracksStatus) {
                case AVKeyValueStatusLoaded:
                    //更新播放器界面，加载好了视频时长
                    if (delegate && [delegate respondsToSelector:@selector(videoStatusLoaded)]) {
                        [delegate videoStatusLoaded];
                    }
                    
                    break;
                case AVKeyValueStatusFailed:
                    if (delegate && [delegate respondsToSelector:@selector(videoStatusFailed:)]) {
                        [delegate videoStatusFailed:error];
                    }
                    //加载失败，提示用户错误原因
                    break;
                case AVKeyValueStatusCancelled:
                    if (delegate && [delegate respondsToSelector:@selector(videoStatusCanceled)]) {
                        [delegate videoStatusCanceled];
                    }
                    //取消了加载
                    break;
                default:
                    break;
            }
        });
        
    }];
    
}


- (void)exportVideoToFormat:(NSString *)format
{
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avURLSet];
    if ([compatiblePresets containsObject:format]) {
        if (exportSession == nil) {
            exportSession = [[AVAssetExportSession alloc] initWithAsset:avURLSet presetName:format];
        }
        
        exportSession.outputFileType = AVFileTypeQuickTimeMovie; //输出视频类型
        exportSession.outputURL = nil; //输出文件路径
        //在此对输出视频文件进行设置
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            switch ([exportSession status]) {
                case AVAssetExportSessionStatusFailed:
                    //输出失败
                    break;
                    case AVAssetExportSessionStatusCancelled:
                    //输出取消
                    break;
                    case AVAssetExportSessionStatusCompleted:
                    break;
                default:
                    break;
            }
        }];
    }
}

- (void)cancelExport
{
    if (exportSession != nil) {
        [exportSession cancelExport];
    }
}


@end
