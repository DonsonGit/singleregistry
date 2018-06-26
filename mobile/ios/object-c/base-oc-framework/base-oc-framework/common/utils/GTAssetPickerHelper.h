//
//  GTAssetPickerHelper.h
//  GTreatCH
//
//  Created by yangji on 2017/8/18.
//  Copyright © 2017年 Luyee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import <TZImagePickerController/TZImagePickerController.h>

@interface GTAsset : NSObject

@property(nonatomic, strong) PHAsset *asset;
@property(nonatomic, strong) UIImage *thumbnail;
@property(nonatomic, strong) UIImage *originImage;
@property(nonatomic, strong) NSURL *videoPath;

@end

typedef void (^GTAssetSelectedHandler) (NSArray<GTAsset *> *assetArray, NSError *error);

@interface GTAssetPickerHelper : NSObject
@property(nonatomic, copy) GTAssetSelectedHandler completionHandler;
@property(nonatomic, strong) TZImagePickerController *picker;
@property(nonatomic, strong) NSMutableArray *selectedArray;
@property(nonatomic, strong) NSMutableArray *selectedVideo;
@property(nonatomic, strong) UIViewController *viewController;
@property(nonatomic, assign) NSInteger maxVideoCount;

+(instancetype)shared;

+(void)show:(UIViewController *)controller completionHandler:(GTAssetSelectedHandler)selectedHandler;

+(void)show:(UIViewController *)controller assets: (NSArray<GTAsset *> *)assets completion:(GTAssetSelectedHandler)selectedHandler;

+(void)show:(UIViewController *)controller assets:(NSArray<GTAsset *> *)assets maxSelectCount:(NSInteger)count completion:(GTAssetSelectedHandler)selectedHandler;

///可以选择照片和视频，但不能同时选择。必须单独选择视频或照片，如果在选择了照片之后再选择视频，会提示用户将视频当做图片发送
+(void)show:(UIViewController *)controller assets:(NSArray<GTAsset *> *)assets maxSelectCount:(NSInteger)count allowPickingVideo:(BOOL)allowPickingVideo maxVideoCount:(NSInteger)maxVideoCount completion:(GTAssetSelectedHandler)selectedHandler;

+(void)showVideoPicker:(UIViewController *)controller complationHandler: (GTAssetSelectedHandler)selectedHandler;

+(void)preview:(NSArray<GTAsset *> *)assets startIndex:(NSInteger)index;

+(void)getVideoUrl:(GTAsset *)asset completionHandler: (void (^)(NSURL *url))completionHandler;
+ (UIImage *)getScreenShotImageFromVideoPath:(NSURL *)filePath;

@end


