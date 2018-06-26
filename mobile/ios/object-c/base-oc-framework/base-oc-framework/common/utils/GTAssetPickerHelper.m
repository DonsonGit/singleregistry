//
//  GTAssetPickerHelper.m
//  GTreatCH
//
//  Created by yangji on 2017/8/18.
//  Copyright © 2017年 Luyee. All rights reserved.
//

#import "GTAssetPickerHelper.h"
#import <TZImagePickerController/TZImagePickerController.h>
#import <TZImageManager.h>
#import "UIViewController+HUD.h"
#import "DateUtil.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface GTAsset() <NSMutableCopying>

@end

@implementation GTAsset

-(id)mutableCopyWithZone:(NSZone *)zone{
    GTAsset *asset = [[GTAsset alloc] init];
    asset.asset = self.asset;
    asset.thumbnail = self.thumbnail;
    asset.originImage = self.originImage;
    asset.videoPath = self.videoPath;
    return asset;
}

@end

@interface GTAssetPickerHelper()<TZImagePickerControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property(nonatomic, strong) NSString *albumName;
@end

@implementation GTAssetPickerHelper

+ (instancetype)shared {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

-(NSString *)albumName{
    if (!_albumName) {
        _albumName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
        if (!_albumName) {
            _albumName = @"Smart City";
        }
    }
    return _albumName;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        _maxVideoCount = 1; //默认可选的视频数为1
        _selectedArray = [[NSMutableArray alloc] init];
        _selectedVideo = [[NSMutableArray alloc] init];
    }
    return self;
}

-(TZImagePickerController *)picker{
    if (nil == _picker) {
        _picker = [[TZImagePickerController alloc] initWithMaxImagesCount:9 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
        _picker.processHintStr = @"处理";
        _picker.doneBtnTitleStr = @"完成";
        _picker.cancelBtnTitleStr = @"取消";
        _picker.settingBtnTitleStr = @"设置";
        _picker.previewBtnTitleStr = @"预览";
        _picker.fullImageBtnTitleStr = @"原图";
        _picker.allowPreview = YES;
        _picker.alwaysEnableDoneBtn = YES;
        _picker.sortAscendingByModificationDate = YES;
        _picker.naviBgColor = COM_TINT_COLOR;
    }
    return _picker;
}

-(UIViewController *)viewController{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    UIViewController *vc = window.rootViewController;

    while (1) {
        if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = ((UITabBarController*)vc).selectedViewController;
        }
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = ((UINavigationController*)vc).visibleViewController;
        }
        if (vc.presentedViewController) {
            vc = vc.presentedViewController;
        }else{
            break;
        }
    }
    return vc;
}

-(void)upadtePickerSelectedAsset{
    [self.picker.selectedAssets removeAllObjects];
    [self.picker.selectedModels removeAllObjects];
    if (self.selectedArray) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        [self.selectedArray enumerateObjectsUsingBlock:^(GTAsset *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (!(obj.videoPath && [obj.videoPath.absoluteString length] > 0)) { //非视频
                [array addObject:obj.asset];
            }else{
                [self.selectedVideo addObject:obj];
            }
        }];
        self.picker.selectedAssets = array;
    }
}

-(void)show{
    if (nil == _viewController) {
        _viewController = [self viewController];
    }
    NSString *title = (self.picker.allowPickingVideo && self.picker.allowPickingImage) ? @"选择照片和视频" : self.picker.allowPickingVideo ? @"选择视频" : @"选择照片";
    UIAlertController *mAlert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *mCameraPhotoAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *controller = [UIImagePickerController new];
        controller.sourceType = UIImagePickerControllerSourceTypeCamera;
        controller.mediaTypes = @[(NSString *)kUTTypeImage];
        controller.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        controller.delegate = self;
        [_viewController presentViewController:controller animated:YES completion:nil];
    }];
    
    UIAlertAction *mCameraVideoAction = [UIAlertAction actionWithTitle:@"拍视频" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *controller = [UIImagePickerController new];
        controller.sourceType = UIImagePickerControllerSourceTypeCamera;
        controller.mediaTypes = @[(NSString *)kUTTypeMovie];
        controller.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
        controller.delegate = self;
        [_viewController presentViewController:controller animated:YES completion:nil];
    }];
    
    UIAlertAction *mPhotoLibraryAction = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [_viewController presentViewController:self.picker animated:YES completion:nil];
    }];
    UIAlertAction *mCancelAction = [UIAlertAction actionWithTitle:GT_LANGUAGE_CONST(@"cancel_text", @"取消") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
    
    int index = 0;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        [mAlert addAction:mPhotoLibraryAction];
    }else{
        [_viewController showToast:@"您的设备无法使用相册"];
        index++;
    }
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        __block int count = 0;
        [self.selectedArray enumerateObjectsUsingBlock:^(GTAsset *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.videoPath && [obj.videoPath.absoluteString length] > 0) {
                count++;
            }
        }];
        if (self.picker.allowPickingImage) {
            //如果全部照片中包含视频，并且除去视频，选中的照片已达到限定的照片数，则不可拍照
            if ([self.selectedArray count] > 0) {
                if ([self.selectedArray count] < self.picker.maxImagesCount+count) {
                    [mAlert addAction:mCameraPhotoAction];
                }
            }else{
                [mAlert addAction:mCameraPhotoAction];
            }
        }
        if (self.picker.allowPickingVideo) {
            //如果可选择的视频数大于0，并且当前选中的视频数已达到限定值，则不可拍视频
            if (self.maxVideoCount > 0) {
                if (count < self.maxVideoCount) {
                    [mAlert addAction:mCameraVideoAction];
                }else{
                    self.picker.allowPickingVideo = NO; //禁止选择视频
                }
            }else{
                [mAlert addAction:mCameraVideoAction];
            }
        }
    }else{
        self.picker.allowTakePicture = NO;
        [_viewController showToast:@"您的设备不支持相机"];
        index++;
    }
    [mAlert addAction:mCancelAction];
    
    if (index >= 2) {
        [_viewController showToast:@"您的设备不支持拍照和选择照片"];
    }else{
        [self upadtePickerSelectedAsset];
        [_viewController presentViewController:mAlert animated:YES completion:nil];
    }
}

#pragma mark - Delegate

#pragma mark - image & video picker delegate
-(void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset{
    GTAsset *videoAsset = [[GTAsset alloc] init];
    videoAsset.thumbnail = coverImage;
    videoAsset.asset = (PHAsset *)asset;
    
    [[self class] getVideoUrl:videoAsset completionHandler:^(NSURL *url) {
        videoAsset.videoPath = url;
        
        self.selectedArray = [[NSMutableArray alloc] initWithObjects:videoAsset, nil];
        if (self.completionHandler) {
            self.completionHandler(self.selectedArray, nil);
        }
    }];
}

-(void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos{
    NSLog(@"选择照片回调");
    
    [self.selectedArray removeAllObjects];
    if (self.selectedVideo) {
        [self.selectedArray addObjectsFromArray:self.selectedVideo];
    }
    [assets enumerateObjectsUsingBlock:^(PHAsset *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        GTAsset *asset = [[GTAsset alloc] init];
        asset.thumbnail = photos[idx];
        asset.asset = obj;
        if (isSelectOriginalPhoto) {
            [[TZImageManager manager] getOriginalPhotoWithAsset:obj completion:^(UIImage *photo, NSDictionary *info) {
                NSLog(@"获取原图%@", info);
                BOOL isOrigin = info[PHImageResultIsDegradedKey];
                if (isOrigin  == YES) {
                    asset.originImage = photo;
                }
            }];
        }else{
            asset.originImage = photos[idx];
        }
        [self.selectedArray addObject:asset];
    }];
    if (self.completionHandler) {
        self.completionHandler(self.selectedArray, nil);
    }
}

#pragma mark - UIImagePickerViewController Delegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        [self photoLibarayAuthorized:^{
            [self savePhoto:image];
        }];
    }else if([mediaType isEqualToString:(NSString *)kUTTypeMovie]){
        NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
        [self photoLibarayAuthorized:^{
            [self saveVideo:videoURL];
        }];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)saveImage: (UIImage *)image{
    [_viewController showloading:@"正在保存图片"];
    NSError *error = nil;
    __block PHObjectPlaceholder *placeholder = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        placeholder = [PHAssetCreationRequest creationRequestForAssetFromImage:image].placeholderForCreatedAsset;
    } error:&error];
    
    [_viewController hideLoading];
    if (error) {
        if (self.completionHandler) {
            self.completionHandler(nil, error);
        }
    }else if (placeholder) {
        PHAsset *asset = [PHAsset fetchAssetsWithLocalIdentifiers:@[placeholder.localIdentifier] options:nil].firstObject;
        GTAsset *imgAsset = [[GTAsset alloc] init];
        imgAsset.asset = asset;
        imgAsset.thumbnail = image;
        imgAsset.originImage = image;
        if (self.selectedArray) {
            [self.selectedArray addObject:imgAsset];
        }else{
            self.selectedArray = [[NSMutableArray alloc] initWithArray:@[imgAsset]];
        }
        if (self.completionHandler) {
            self.completionHandler(self.selectedArray, nil);
        }
    }else{
        if (self.completionHandler) {
            self.completionHandler(nil, [[NSError alloc] initWithDomain:@"未能获取保存的照片." code:0 userInfo:nil]);
        }
    }
}

-(void)saveVideo:(NSURL *)videoPath{
    [_viewController showloading:@"正在保存视频"];
    __block NSError *error = nil;
    __block PHObjectPlaceholder *placeholder = nil;

    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        PHAssetCollectionChangeRequest *request;
        PHAssetCollection *album = [self album];
        if (album) {
            request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:album];
        }else{
            request = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:self.albumName];
        }
        PHAssetChangeRequest *assetRequest = [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:videoPath];
        placeholder = [assetRequest placeholderForCreatedAsset];
        [request addAssets:@[placeholder]];
    } error:&error];
    
    [_viewController hideLoading];
    if (error) {
        if (self.completionHandler) {
            self.completionHandler(nil, error);
        }
    }else if (placeholder) {
        PHAsset *asset = [PHAsset fetchAssetsWithLocalIdentifiers:@[placeholder.localIdentifier] options:nil].firstObject;
        GTAsset *videoAsset = [[GTAsset alloc] init];
        videoAsset.asset = asset;
        videoAsset.thumbnail = [[self class] getScreenShotImageFromVideoPath:videoPath];
        
        dispatch_group_t _group = dispatch_group_create();
        dispatch_queue_t _queue = dispatch_queue_create("com.gtreat.savevideo", nil);
        
        dispatch_group_async(_group, _queue, ^{
            dispatch_group_enter(_group);
            [[self class] getVideoUrl:videoAsset completionHandler:^(NSURL *url) {
                videoAsset.videoPath = url;
                dispatch_group_leave(_group);
            }];
        });
        
        dispatch_group_notify(_group, dispatch_get_main_queue(), ^{
            if (self.selectedArray) {
                [self.selectedArray addObject:videoAsset];
            }else{
                self.selectedArray = [[NSMutableArray alloc] initWithArray:@[videoAsset]];
            }
            if (self.completionHandler) {
                self.completionHandler(self.selectedArray, nil);
            }
        });
    }else{
        if (self.completionHandler) {
            self.completionHandler(nil, [[NSError alloc] initWithDomain:@"未能获取保存的视频." code:0 userInfo:nil]);
        }
    }
}

+ (UIImage *)getScreenShotImageFromVideoPath:(NSURL *)filePath{
    UIImage *shotImage;
    //视频路径URL
    NSURL *fileURL = filePath;
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:fileURL options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    shotImage = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return shotImage;
}

-(void)photoLibarayAuthorized:(void (^)())authorizedHandler{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusAuthorized) {
        authorizedHandler();
    }else if (status == PHAuthorizationStatusNotDetermined){
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus stat) {
            if (stat == PHAuthorizationStatusAuthorized) {
                authorizedHandler();
            }
        }];
    }else{
        [_viewController showToast:@"无法访问您的相册，请到设置中授权"];
    }
}

-(PHAssetCollection *)album{
    PHFetchResult *result = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for (PHAssetCollection *assetCollection in result) {
        if ([assetCollection.localizedTitle containsString:self.albumName]) {
            return assetCollection;
        }
    }
    return nil;
}

-(void)savePhoto:(UIImage *)image{
    [_viewController showloading:@"正在保存图片"];
    NSError *error = nil;
    __block PHObjectPlaceholder *placeholder = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        PHAssetCollectionChangeRequest *request;
        PHAssetCollection *album = [self album];
        if (album) {
            request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:album];
        }else{
            request = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:self.albumName];
        }
        PHAssetChangeRequest *assetRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        placeholder = [assetRequest placeholderForCreatedAsset];
        [request addAssets:@[placeholder]];
    } error:&error];
    [_viewController hideLoading];
    if (error) {
        if (self.completionHandler) {
            self.completionHandler(nil, error);
        }
    }else if (placeholder) {
        PHAsset *asset = [PHAsset fetchAssetsWithLocalIdentifiers:@[placeholder.localIdentifier] options:nil].firstObject;
        GTAsset *imgAsset = [[GTAsset alloc] init];
        imgAsset.asset = asset;
        imgAsset.thumbnail = image;
        imgAsset.originImage = image;
        if (self.selectedArray) {
            [self.selectedArray addObject:imgAsset];
        }else{
            self.selectedArray = [[NSMutableArray alloc] initWithArray:@[imgAsset]];
        }
        if (self.completionHandler) {
            self.completionHandler(self.selectedArray, nil);
        }
    }else{
        if (self.completionHandler) {
            self.completionHandler(nil, [[NSError alloc] initWithDomain:@"未能获取保存的照片." code:0 userInfo:nil]);
        }
    }
}


#pragma mark - class func

+(void)show:(UIViewController *)controller completionHandler:(GTAssetSelectedHandler)selectedHandler{
    [self show:controller assets:nil completion:selectedHandler];
}

+(void)show:(UIViewController *)controller assets: (NSArray<GTAsset *> *)assets completion:(GTAssetSelectedHandler)selectedHandler{
    [self show:controller assets:assets maxSelectCount:9 completion:selectedHandler];
}

+(void)show:(UIViewController *)controller assets:(NSArray<GTAsset *> *)assets maxSelectCount:(NSInteger)count completion:(GTAssetSelectedHandler)selectedHandler{
    [self show:controller assets:assets maxSelectCount:count allowPickingVideo:NO maxVideoCount:0 completion:selectedHandler];
}

+(void)show:(UIViewController *)controller assets:(NSArray<GTAsset *> *)assets maxSelectCount:(NSInteger)count allowPickingVideo:(BOOL)allowPickingVideo maxVideoCount:(NSInteger)maxVideoCount completion:(GTAssetSelectedHandler)selectedHandler{
    GTAssetPickerHelper *helper = [GTAssetPickerHelper shared];
    helper.picker = nil;
    helper.viewController = controller;
    helper.picker.maxImagesCount = count;
    helper.picker.allowPickingVideo = allowPickingVideo;
    [helper.selectedVideo removeAllObjects];
    helper.selectedArray = [[NSMutableArray alloc] initWithArray:assets];
    helper.completionHandler = selectedHandler;
    helper.maxVideoCount = maxVideoCount;
    [helper show];
}

+(void)showVideoPicker:(UIViewController *)controller complationHandler: (GTAssetSelectedHandler)selectedHandler{
    GTAssetPickerHelper *helper = [GTAssetPickerHelper shared];
    helper.picker = nil;
    [helper.selectedArray removeAllObjects];
    [helper.picker.selectedAssets removeAllObjects];
    helper.picker.maxImagesCount = 1;
    helper.viewController = controller;
    helper.picker.allowPickingVideo = YES;
    helper.picker.allowPickingImage = NO;
    helper.picker.allowTakePicture = NO;
    helper.completionHandler = selectedHandler;
    [helper show];
}

+(void)preview:(NSArray<GTAsset *> *)assets startIndex:(NSInteger)index{
    GTAssetPickerHelper *helper = [GTAssetPickerHelper shared];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [assets enumerateObjectsUsingBlock:^(GTAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [array addObject:obj.asset];
    }];
    TZImagePickerController *picker = [[TZImagePickerController alloc] initWithSelectedAssets:array selectedPhotos:array index:index];
    [helper.viewController presentViewController:picker animated:YES completion:nil];
}

+(void)getVideoUrl:(GTAsset *)asset completionHandler: (void (^)(NSURL *url))completionHandler{
    PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
    options.version = PHVideoRequestOptionsVersionCurrent;
    options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
    NSString *filename = [asset.asset valueForKey:@"filename"];
    if ([filename length] <= 0) {
        filename = [NSString stringWithFormat:@"/%@.MP4",[DateUtil date2String:[NSDate new] dateFormat:@"yyyyMMddHHmmssSSS"]];
    }
    NSString *videoPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]; //NSTemporaryDirectory();
    NSLog(@"%@", videoPath);
    videoPath = [videoPath stringByAppendingString:[NSString stringWithFormat:@"/%@",filename]];
    NSURL *videoUrl = [NSURL fileURLWithPath:videoPath];
    NSLog(@"%@", videoUrl);
    if ([[NSFileManager defaultManager] fileExistsAtPath: videoPath]) {
        ///如果文件存在，则直接返回url
        completionHandler(videoUrl);
        return;
    }
    
    [[PHImageManager defaultManager] requestExportSessionForVideo:asset.asset options:options exportPreset:AVAssetExportPresetMediumQuality resultHandler:^(AVAssetExportSession * _Nullable exportSession, NSDictionary * _Nullable info) {
        exportSession.outputURL = videoUrl;
        exportSession.shouldOptimizeForNetworkUse = NO;
        exportSession.outputFileType = AVFileTypeMPEG4;
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            if (exportSession.status == AVAssetExportSessionStatusCompleted) {
                NSData *data = [NSData dataWithContentsOfURL:videoUrl];
                if (data) {
                    if ([[NSThread currentThread] isMainThread]) {
                        completionHandler(videoUrl);
                    }else{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completionHandler(videoUrl);
                        });
                    }
                }else{
                    NSLog(@"获取视频地址出错");
                }
            }else if (exportSession.status == AVAssetExportSessionStatusFailed){
                NSLog(@"获取视频地址出错：%@", exportSession.error);
                [[PHImageManager defaultManager] requestAVAssetForVideo:asset.asset options:nil resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        AVURLAsset *urlAsset = (AVURLAsset *)asset;
                        completionHandler(urlAsset.URL);
                    });
                }];
            }
        }];
    }];
}

@end



