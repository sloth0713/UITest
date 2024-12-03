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

@interface OnlineImageView ()

@property(nonatomic,strong)NSMutableArray <NSData *> * dataArray;

@end


@implementation OnlineImageView

- (void)loadImage
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
        [strongSelf.dataArray addObject:data];
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



@end
