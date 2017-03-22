//
//  JLIdentityViewController.m
//  Agriculturalstation
//
//  Created by chw on 16/12/16.
//  Copyright © 2016年 chw. All rights reserved.
//

// 身份认证

#import "JLIdentityViewController.h"
#import "ServerResult.h"

#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "UIButton+WebCache.h"
#import "TZImagePickerController.h"
#import "TZImageManager.h"
#import "MJExtension.h"

@interface JLIdentityViewController ()<UIActionSheetDelegate,TZImagePickerControllerDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate> {
    NSString *uid;
    NSString *imgKey; // 图片key
}

// 身份证正面照
- (IBAction)certificatePositive:(id)sender;
// 身份证反面照
- (IBAction)certificateReverse:(id)sender;
// 提交
- (IBAction)commitBtn;


@property (nonatomic, strong) UIImagePickerController *imagePickerVc;

// 真实姓名
@property (strong, nonatomic) IBOutlet UITextField *_realName;
// 证件号码
@property (strong, nonatomic) IBOutlet UITextField *_certificateID;
// 正面照
@property (strong, nonatomic) IBOutlet UIButton *imgBtn1;
// 反面照
@property (strong, nonatomic) IBOutlet UIButton *imgBtn2;


@end

@implementation JLIdentityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    uid = [userDefaults objectForKey:@"uid"];
    
    [self getIdentityInfo];
}

// 获取证件信息
- (void)getIdentityInfo{
    // 显示MBProgressHUD
    [MBProgressHUD showMessage:nil];
    // 请求地址
    NSString *url = [REQUEST_URL stringByAppendingString:@"app-personalinfo-op-idcard.html"];
    // 请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    // 拼接请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"uid"] = uid;
    // 发起请求
    [manager POST:url parameters:parameters progress:^(NSProgress *_Nonnull uploadProgress){
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        // 隐藏MBProgressHUD
        [MBProgressHUD hideHUD];
        
        self._realName.text = responseObject[@"realname"]; // 真实姓名
        self._certificateID.text = responseObject[@"idcard"]; // 证件号
        [self.imgBtn1 sd_setImageWithURL:[NSURL URLWithString:[IMAGE_URL stringByAppendingString:responseObject[@"idcardpositive"]]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"no_pictures.png"]]; // 正面照
        [self.imgBtn2 sd_setImageWithURL:[NSURL URLWithString:[IMAGE_URL stringByAppendingString:responseObject[@"idcardnegative"]]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"no_pictures.png"]]; // 反面照
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
        // 隐藏MBProgressHUD
        [MBProgressHUD hideHUD];
        //同时弹出“加载失败”的提示；
        [MBProgressHUD showError:@"加载失败"];
    }];
}

// 身份证正面照
- (IBAction)certificatePositive:(id)sender {
    imgKey = @"positive";
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"去相册选择", nil];
    [sheet showInView:self.view];
}

// 身份证反面照
-(IBAction)certificateReverse:(id)sender{
    imgKey = @"negative";
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"去相册选择", nil];
    [sheet showInView:self.view];
}

// 提交
- (IBAction)commitBtn {
    if(NULLString(self._realName.text) || NULLString(self._certificateID.text)){
        // 创建弹出窗
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"请填写完整信息" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
        // 显示
        [alert show];
    }else{
        // 提交修改信息到服务端
        [self submitInfo];
    }
}

- (void)submitInfo{
    // 显示MBProgressHUD
    [MBProgressHUD showMessage:nil];
    // 请求地址
    NSString *url = [REQUEST_URL stringByAppendingString:@"app-personalinfo-op-idcarddata.html"];
    // 请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    // 拼接请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"uid"] = uid;
    parameters[@"realname"] = self._realName.text;
    parameters[@"idcard"] = self._certificateID.text;
    // 发起请求
    [manager POST:url parameters:parameters progress:^(NSProgress *_Nonnull uploadProgress){
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        // 隐藏MBProgressHUD
        [MBProgressHUD hideHUD];
        ServerResult *result = [ServerResult mj_objectWithKeyValues:responseObject];
        if(result.code == 200){
            [MBProgressHUD showSuccess:result.msg];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
        // 隐藏MBProgressHUD
        [MBProgressHUD hideHUD];
        //同时弹出“加载失败”的提示；
        [MBProgressHUD showError:@"提交失败"];
    }];
}


#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){ // take photo / 去拍照
        [self takePhoto];
    }else if (buttonIndex == 1){ // 去相册选择
        [self pushImagePickerController];
    }
}

#pragma mark - UIImagePickerController

- (void)takePhoto{
    // 相机权限
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if((authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) && iOS7Later){
        // 无相机权限，做一个友好的提示
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        [alert show];
        // 拍照之前还需要检查相册权限
    }else if ([[TZImageManager manager] authorizationStatus] == 2){ // 已被拒绝，没有相册权限，将无法保存拍的照片
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        alert.tag = 1;
        [alert show];
    }else if ([[TZImageManager manager] authorizationStatus] == 0){ // 正在弹框询问用户是否允许访问相册，监听权限状态
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            return [self takePhoto];
        });
    }else{ // 调用相机
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            self.imagePickerVc.sourceType = sourceType;
            if(iOS8Later){
                _imagePickerVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            }
            [self presentViewController:_imagePickerVc animated:YES completion:nil];
        }else{
            JLLog(@"模拟器中无法打开照相机，请在真机中使用");
        }
    }
}

#pragma mark - TZImagePickerController

- (void)pushImagePickerController{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    // 可以通过block或者代理，来得到用户选择的照片
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto){
        [self uploadImg:photos[0]];
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

// 上传图片
- (void)uploadImg:(UIImage *)image{
    // 显示MBProgressHUD
    [MBProgressHUD showMessage:@"正在上传..."];
    NSString *url = [REQUEST_URL stringByAppendingString:@"app-personalinfo-op-idcardpic.html"];
    // 拼接请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"uid"] = uid;
    parameters[@"flag"] = imgKey;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 接收类型不一致请替换一致text/html或别的
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
    
    [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData){
        
        NSData *imageData = UIImageJPEGRepresentation(image, 1);
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
        
        // 上传的参数（上传图片，以文件流的格式）
        [formData appendPartWithFileData:imageData name:@"uploadfile" fileName:fileName mimeType:@"image/jpeg"];
        
    } progress:^(NSProgress *_Nonnull uploadProgress){
        // 上传进度
    } success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject){
        // 上传成功
        
        // 隐藏MBProgressHUD
        [MBProgressHUD hideHUD];
        ServerResult *result = [ServerResult mj_objectWithKeyValues:responseObject];
        if(result.code == 200){
            [MBProgressHUD showSuccess:result.msg];
            if([imgKey isEqualToString:@"positive"]){ // 相关证件一
                [self.imgBtn1 setImage:image forState:UIControlStateNormal];
            }else if ([imgKey isEqualToString:@"negative"]){ // 相关证件二
                [self.imgBtn2 setImage:image forState:UIControlStateNormal];
            }
        }
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error){
        // 上传失败
        
        // 隐藏MBProgressHUD
        [MBProgressHUD hideHUD];
        //同时弹出“上传失败”的提示；
        [MBProgressHUD showError:@"上传失败"];
    }];
}
@end











































