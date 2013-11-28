//
//  ProductsWithCategory.h
//  SuperMarket
//
//  Created by phoenix on 11/21/13.
//  Copyright (c) 2013 phoenix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProductObject.h"
@interface ProductsWithCategory : NSObject
@property (nonatomic, strong) ProductObject *obj;
@property (nonatomic, assign) BOOL isCategory;
@property (nonatomic, assign) NSString* mainID;
@property (nonatomic, assign) NSString* subID;
@end
