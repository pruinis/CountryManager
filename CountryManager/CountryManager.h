//
//  CountryManager.h
//
//  Created by Anton Morozov on 10.10.14.
//  Copyright (c) 2014 Anton Morozov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Country : NSObject

@property (nonatomic, retain) NSString *isoCode;
@property (nonatomic, retain) NSString *flagName;
@property (nonatomic, retain) NSString *countryName;
@property (nonatomic, retain) NSString *phoneCode;

@end
 

@interface CountryManager : NSObject

+ (id)sharedManager;

@property(nonatomic, readonly) NSArray *countries;   

- (NSString*)getDiallingCodeForCountryISOCode:(NSString *)code;
- (Country*)getCountryFromISOCode:(NSString*)code;
- (NSArray *)getCountriesPhoneCodes; 

@end
