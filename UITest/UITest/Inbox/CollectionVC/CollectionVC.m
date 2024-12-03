//
//  CollectionVC.m
//  UITest
//
//  Created by ByteDance on 2024/11/27.
//

#import "CollectionVC.h"
#import "MyLayout.h"
#import "OnlineImageView.h"
#import "CollectionViewCell.h"
#import "Cell/CollectionViewCell1.h"
#import "Cell/CollectionViewCell2.h"
#import "Cell/CollectionViewCell3.h"

#define collectionViewCount 100;
@interface CollectionVC ()

//@property (nonatomic, strong)OnlineImageView *onlineImageView;

@end

@implementation CollectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    MyLayout * layout = [[MyLayout alloc]init];
    layout.width = self.view.bounds.size.width;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.itemCount=collectionViewCount;
//    [[OnlineImageView shareManager] loadImages:collectionViewCount];
    UICollectionView * collect  = [[UICollectionView alloc]initWithFrame:self.view.frame collectionViewLayout:layout];
    collect.delegate=self;
    collect.dataSource=self;
    
    [collect registerClass:[CollectionViewCell1 class] forCellWithReuseIdentifier:[NSString stringWithFormat:@"%lu", CollectionViewCellType1]];
    [collect registerClass:[CollectionViewCell2 class] forCellWithReuseIdentifier:[NSString stringWithFormat:@"%lu", CollectionViewCellType2]];
    [collect registerClass:[CollectionViewCell3 class] forCellWithReuseIdentifier:[NSString stringWithFormat:@"%lu", CollectionViewCellType3]];
//
    [self.view addSubview:collect];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"viewWillAppear");
}

- (void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"viewWillDisappear");
}

- (void)viewDidLayoutSubviews
{
    NSLog(@"viewDidLayoutSubviews");
}

- (void)viewWillLayoutSubviews
{
    NSLog(@"viewWillLayoutSubviews");
}
 
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return collectionViewCount;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //cell大小不一致，没办法复用
    //cell复用后只能对其中的内容赋值，不能addView，否则有奇怪的错误
    CollectionViewCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:[NSString stringWithFormat:@"%lu", CollectionViewCellType1] forIndexPath:indexPath];
    
    UIImage *image = [[OnlineImageView shareManager] getImageArray][indexPath.row];
    CGFloat height = image.size.height;
    if (height==40) {
        cell  = [collectionView dequeueReusableCellWithReuseIdentifier:[NSString stringWithFormat:@"%lu", CollectionViewCellType1] forIndexPath:indexPath];
    }else if (height==100){
        cell  = [collectionView dequeueReusableCellWithReuseIdentifier:[NSString stringWithFormat:@"%lu", CollectionViewCellType2] forIndexPath:indexPath];
    }else if (height==190){
        cell  = [collectionView dequeueReusableCellWithReuseIdentifier:[NSString stringWithFormat:@"%lu", CollectionViewCellType3] forIndexPath:indexPath];
    }
    
    cell.backgroundColor = [UIColor blueColor];

    
    cell.imageView.image = image;
    
    return cell;
}

@end
