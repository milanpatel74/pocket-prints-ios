// JSON Consumer version 0.1 beta 
// Written by Quan Do// Local distribution only!!!//
//
//




#import "JSONObject.h"

@interface     Product : JSONObject

@property (nonatomic,strong) NSNumber    *height;
@property (nonatomic,strong) NSString    *uid;
@property (nonatomic,strong) NSArray    *images;
@property (nonatomic,strong) NSNumber    *price;
@property (nonatomic,strong) NSNumber    *requires_photo;
@property (nonatomic,strong) NSString    *size;
@property (nonatomic,strong) NSNumber    *width;
@property (nonatomic,strong) NSString    *type;
@property (nonatomic,strong) NSString    *description;
@property (nonatomic,strong) NSString    *main_image;
@property (nonatomic,strong) NSNumber    *shipping;
@property (nonatomic,strong) NSNumber    *quantity_set;
@property   (nonatomic,strong) UIImage  *img;
@end