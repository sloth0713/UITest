//
//  MyLayout.m
//  UITest
//
//  Created by ByteDance on 2024/11/27.
//

#import "MyLayout.h"

@interface MyLayout ()

@property (nonatomic,strong) NSMutableArray * attributeArray;

@end

@implementation MyLayout

//数组的相关设置在这个方法中
//布局前的准备会调用这个方法
-(void)prepareLayout{
    [super prepareLayout];
    self.attributeArray = [[NSMutableArray alloc]init];
    
    //计算每一个item的宽度
    float WIDTH = (self.width - self.sectionInset.left - self.sectionInset.right - self.minimumInteritemSpacing)/2;

    //这个数组的主要作用是保存每一列的总高度，这样在布局时，我们可以始终将下一个Item放在最短的列下面
    //目前固定两列
    CGFloat colHight[2]={self.sectionInset.top,self.sectionInset.bottom};
    //itemCount是外界传进来的item的个数 遍历来设置每一个item的布局
    for (int i=0; i<self.itemCount; i++) {
        NSIndexPath *index = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:index];
        
        //随机一个高度 在40——190之间
        CGFloat hight = arc4random()%150+40;
        
        //哪一列高度小 则放到那一列下面
        int width=0;
        if (colHight[0]<colHight[1]) {
            //加到第一列
            colHight[0] = colHight[0]+hight+self.minimumLineSpacing;
            width=0;
        }else{
            //加到第一列
            colHight[1] = colHight[1]+hight+self.minimumLineSpacing;
            width=1;
        }
        
        attributes.frame = CGRectMake(self.sectionInset.left+(self.minimumInteritemSpacing+WIDTH)*width, colHight[width]-hight-self.minimumLineSpacing, WIDTH, hight);
        [self.attributeArray addObject:attributes];
    }
    
    //设置itemSize来确保滑动范围的正确 这里是通过将所有的item高度平均化，计算出来的(以最高的列位标准)
    if (colHight[0]>colHight[1]) {
        self.itemSize = CGSizeMake(WIDTH, (colHight[0]-self.sectionInset.top)*2/_itemCount-self.minimumLineSpacing);
    }else{
          self.itemSize = CGSizeMake(WIDTH, (colHight[1]-self.sectionInset.top)*2/_itemCount-self.minimumLineSpacing);
    }
    
}
//这个方法中返回我们的布局数组
-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    return self.attributeArray;
}
 

@end
