//
//  OnlineImageView.m
//  UITest
//
//  Created by ByteDance on 2024/11/27.
//

#import "OnlineImageView.h"

static NSArray *urlArray = @[
    @"https://picsum.photos/200/200?random=2",
//
//    @"https://picsum.photos/200/200?random=1",
//
//    @"https://picsum.photos/300/200?random=2",
//
//    @"https://picsum.photos/300/200?random=1"
];

//static NSArray *typeArray = @[
//    ,
//];

@interface OnlineImageView ()

@property(nonatomic,strong) NSLock *lock;
@property(nonatomic,strong) NSMutableArray <UIImage *> * dataArray;

@end


@implementation OnlineImageView

+ (instancetype)shareManager
{
    static OnlineImageView *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[OnlineImageView alloc] init];
        manager.lock = [[NSLock alloc] init];
        [manager.lock lock];
        manager.dataArray = [[NSMutableArray alloc] init];
    });
    return manager;
}

- (NSArray<UIImage *> *)getImageArray
{
//    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
//    if ()
    [self.lock lock];
    self.lock = nil;
    return self.dataArray;
}

- (void)loadImages:(int)count width:(float)width
{
    for (int i=0; i<count; i++) {
        [self loadImageWidth:width];
    }
}

- (void)loadImageWidth:(float)width
{
    // 网络图片 URL
    NSString *imageUrlString = urlArray[arc4random() % urlArray.count];
//    NSString *imageUrlString = @"https://fastly.picsum.photos/id/390/200/200.jpg?hmac=jO0I_KIqGlM283KrH_KN8THBmylOIRyiWbKAx8412Ss";
    NSURL *imageUrl = [NSURL URLWithString:imageUrlString];

    // 创建 NSURLSession 对象
    NSURLSession *session = [NSURLSession sharedSession];

    // 创建一个数据任务来下载图片数据
    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:imageUrl completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        __strong typeof(self) strongSelf = weakSelf;
        if (error) {
            NSLog(@"Error fetching image: %@", error.localizedDescription);
            return;
        }
        UIImage *im = [strongSelf clipeimage:[UIImage imageWithData:data] targetWidth:width];
        [strongSelf.dataArray addObject:im];
        if (strongSelf.dataArray.count==100){
//            dispatch_semaphore_signal(self.semaphore);
            [strongSelf.lock unlock];
        }
        NSLog(@"load image view success! thread name");
        // 在主线程更新 UI，显示图片
//        dispatch_async(dispatch_get_main_queue(), ^{
//            UIImage *image = [UIImage imageWithData:data];
//            
//            // 将图片设置到 UIImageView 中
//            UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.frame];
//            imageView.image = image;
//            
//            // 添加 ImageView 到视图中
//            [self addSubview:imageView];
//            NSLog(@"load image view success!");
//        });
    }];

    // 开始数据任务
    [dataTask resume];

}

- (UIImage *)clipeimage:(UIImage *)originalImage targetWidth:(CGFloat)targetWidth
{

    int type = arc4random()%3 + 1;
    
    CGFloat targetHeight = 40;
    if (type==1){
        targetHeight = 40;
    }else if (type==2){
        targetHeight = 100;
    }else if (type==3){
        targetHeight = 190;
    }
    

    // 开始一个基于位图的图形上下文
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(targetWidth, targetHeight), NO, 0.0);

    // 将原始图片绘制到指定大小的矩形（裁剪图片）
    [originalImage drawInRect:CGRectMake(0, 0, targetWidth, targetHeight)];
    UIImage *croppedImage = UIGraphicsGetImageFromCurrentImageContext();

    // 结束上下文
    UIGraphicsEndImageContext();

    // 返回裁剪后的图片
    return croppedImage;
}



@end
