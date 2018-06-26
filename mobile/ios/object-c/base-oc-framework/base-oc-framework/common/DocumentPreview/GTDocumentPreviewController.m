//
//  GTDocumentPreviewController.m
//  GTreatCH
//
//  Created by yangji on 2017/8/3.
//  Copyright © 2017年 Luyee. All rights reserved.
//

#import "GTDocumentPreviewController.h"

@interface GTDocumentPreviewController ()<QLPreviewControllerDataSource>

@property (nonatomic, strong) QLPreviewController *previewController;
@property (nonatomic, strong) NSURL *previewLocalFileUrl;

@end

@implementation GTDocumentPreviewController

-(instancetype)init:(NSString *)url fileName:(NSString *) filename{
    self = [super init];
    if(self) {
        _documentUrl = url;
        _fileName = filename;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = _fileName;
    
    _previewController = [[QLPreviewController alloc] init];
    [self addChildViewController:self.previewController];
    [self.view addSubview:self.previewController.view];
    [self.previewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(0);
    }];
    [self.previewController didMoveToParentViewController:self];
    self.previewController.view.hidden = YES;
    self.previewController.dataSource = self;
    [self showloading:@""];
}

- (void)viewWillLayoutSubviews{
    
}

- (void)viewDidAppear:(BOOL)animated{
    if (self.previewLocalFileUrl == nil) {
        [self downloadFile];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)dealloc{
    NSString * filePath = NSTemporaryDirectory();
    filePath = [NSString stringWithFormat:@"%@%@", filePath, _fileName];
    
    NSFileManager* fileManager=[NSFileManager defaultManager];
    [fileManager removeItemAtPath:filePath error:nil];
}

#pragma mark - Download File
- (void)downloadFile{
    NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:self.documentUrl]];
    NSString * filePath = NSTemporaryDirectory();
    filePath = [NSString stringWithFormat:@"%@%@", filePath, _fileName];
    if([data writeToFile:filePath atomically:NO]) {
        [self hideLoading];
        self.previewLocalFileUrl = [[NSURL alloc] initFileURLWithPath:filePath isDirectory:NO];
        self.previewController.view.hidden = NO;
        [self.previewController reloadData];
    }else{
        [self hideLoading];
        [self showToast:@"文件预览失败，请检查文件路径"];
    }
}

#pragma mark - QLPreviewController DataSource
-(NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller{
    return self.previewLocalFileUrl == nil ? 0 : 1;
}

-(id<QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index{
    return self.previewLocalFileUrl;
}

@end
