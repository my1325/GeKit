//
//  UIViewController+Ge.m
//  GXWToolKitDemo
//
//  Created by m y on 2018/1/15.
//  Copyright © 2018年 My. All rights reserved.
//

#import "UIViewController+Ge.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <objc/runtime.h>

@interface GeImagePickerDelegate: NSObject<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property(nonatomic, assign, readonly) BOOL editing;

@property(nonatomic, copy, readonly) void(^completion)(UIImage *);

@property(nonatomic, copy, readonly) void(^videoCompletion)(NSURL * url);

- (instancetype)initWithEditing: (BOOL)editing completion: (void(^)(UIImage *))completion;

- (instancetype)initWithVideoCompletion: (void(^)(NSURL *url))completion;

- (void)setPickerController: (UIImagePickerController *)pickerController;
@end

@implementation GeImagePickerDelegate
- (instancetype)initWithEditing:(BOOL)editing completion:(void (^)(UIImage *))completion {
    self = [super init];
    if (!self) return nil;
    
    _editing = editing;
    _completion = [completion copy];
    return self;
}

- (instancetype)initWithVideoCompletion:(void (^)(NSURL *))completion {
    self = [super init];
    if (!self) return nil;
    
    _videoCompletion = [completion copy];
    return self;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    if ([info[UIImagePickerControllerMediaType] isEqualToString:(NSString *)kUTTypeImage])
    {
        /// 图片
        UIImage *image = info[_editing ? UIImagePickerControllerEditedImage : UIImagePickerControllerOriginalImage];
        if (_completion) _completion(image);
        if (_videoCompletion) _videoCompletion(nil);
    }else {
        /// 视频
        NSURL * URL = info[UIImagePickerControllerMediaURL];
        if (_completion) _completion(nil);
        if (_videoCompletion) _videoCompletion(URL);
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)setPickerController:(UIImagePickerController *)pickerController {
    pickerController.delegate = self;
    objc_setAssociatedObject(pickerController, _cmd, self, OBJC_ASSOCIATION_RETAIN);
}
@end

@implementation UIViewController (Ge)

- (void)g_hideShadow {
    
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
}

- (void)g_showShadow {
    
    self.navigationController.navigationBar.shadowImage = nil;
}

- (void)g_enablePopGestureRecognizer {
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (void)g_disablePopGestureRecognizer {
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
}

- (void)g_presentCameraForImageEditable:(BOOL)editable completion:(void (^)(UIImage *))completion {
    
    UIImagePickerController * pickerController = [[UIImagePickerController alloc] init];
    pickerController.editing = editable;
    pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    pickerController.mediaTypes = @[(NSString *)kUTTypeImage];
    pickerController.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
    
    GeImagePickerDelegate * delegate = [[GeImagePickerDelegate alloc] initWithEditing:editable completion:completion];
    [delegate setPickerController:pickerController];

    [self presentViewController:pickerController animated:YES completion:nil];
}

- (void)g_presentPhotoLibraryEditable:(BOOL)editable completion:(void (^)(UIImage *))completion {
    
    UIImagePickerController * pickerController = [[UIImagePickerController alloc] init];
    pickerController.editing = editable;
    pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    GeImagePickerDelegate * delegate = [[GeImagePickerDelegate alloc] initWithEditing:editable completion:completion];
    [delegate setPickerController:pickerController];
    
    [self presentViewController:pickerController animated:YES completion:nil];
}

- (void)g_presentCameraForVideoWithCompletion:(void (^)(NSURL *))completion {
    
    UIImagePickerController * pickerController = [[UIImagePickerController alloc] init];
    pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    pickerController.mediaTypes = @[(NSString *)kUTTypeVideo];
    
    GeImagePickerDelegate * delegate = [[GeImagePickerDelegate alloc] initWithVideoCompletion:completion];
    [delegate setPickerController:pickerController];
    [self presentViewController:pickerController animated:YES completion:nil];
}
@end
