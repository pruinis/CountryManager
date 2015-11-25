//
//  CountryManager.m
//
//  Created by Anton Morozov on 10.10.14.
//  Copyright (c) 2014 Anton Morozov. All rights reserved.
//

#import "CountryManager.h"

@implementation Country

@synthesize isoCode;
@synthesize flagName;
@synthesize countryName;
 
@end

#pragma mark - CountryManager

@interface CountryManager ()

@property (nonatomic, strong) NSDictionary *countriesDict;
@property (nonatomic, strong) NSMutableArray *countriesArr;
@property (nonatomic, strong) NSMutableArray *countriesPhoneCodesArr;

@end

@implementation CountryManager 

@synthesize countriesDict, countriesArr, countriesPhoneCodesArr;

+ (id)sharedManager {
    static CountryManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.countriesArr = [NSMutableArray array];
        self.countriesPhoneCodesArr = [NSMutableArray array];

        NSString * plistPath = [[NSBundle mainBundle] pathForResource:@"DiallingCountriesCodes" ofType:@"plist"];
        self.countriesDict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
  
        // get countries
        for (NSString *key in self.countriesDict.allKeys) {
            Country *country = [self getCountryFromISOCode:key];
            if (country) {
                [countriesArr addObject:country];
                [countriesPhoneCodesArr addObject:country.phoneCode];
            }
        }
        
        [countriesArr sortUsingDescriptors: [NSArray arrayWithObjects:
                                             [NSSortDescriptor sortDescriptorWithKey:@"countryName" ascending:YES], nil]];           
    }
    return self;
}

-(NSArray *)countries
{
    return countriesArr;
}

- (NSString*)getDiallingCodeForCountryISOCode:(NSString *)code
{
    NSString *diallingCode = [self codeFromDictionaryForCountry:code];
    if (diallingCode && diallingCode.length > 0) {
        NSMutableString *phoneCode = [[NSMutableString alloc] initWithString:diallingCode];
        if (![phoneCode hasPrefix:@"+"]) {
            [phoneCode insertString:@"+" atIndex:0];
        }
        return phoneCode;
    } else {
        return nil;
    }
}

-(Country*)getCountryFromISOCode:(NSString*)code
{
    NSString *diallingCode = [self codeFromDictionaryForCountry:code];
    if ([diallingCode length]) {
        
        Country *country = [[Country alloc] init];
        
        // phone code
        NSMutableString *codeStr = [[NSMutableString alloc] initWithString:diallingCode];
        [codeStr insertString:@"+" atIndex:0];
        country.phoneCode = codeStr;
        
        // iso coutry code
        if ([[NSLocale ISOCountryCodes] containsObject:[code uppercaseString]]) {
            country.isoCode = [code uppercaseString];
        } else {
            return nil;
        }
        
        // flag
        if ([UIImage imageNamed:[code lowercaseString]]) {
            country.flagName = [code lowercaseString];
        } else {
            return nil;
        }
        
        // nsme
        NSString *identifier = [NSLocale localeIdentifierFromComponents: [NSDictionary dictionaryWithObject: [code uppercaseString] forKey: NSLocaleCountryCode]];
//        NSString *country = [[NSLocale currentLocale] displayNameForKey: NSLocaleIdentifier value: identifier];
        country.countryName = [[NSLocale currentLocale] displayNameForKey: NSLocaleIdentifier value: identifier];
        
        return country;
    }

    return nil;
}

-(NSArray *)getCountriesPhoneCodes
{
    return countriesPhoneCodesArr;
}  

#pragma mark -

- (NSString *)codeFromDictionaryForCountry:(NSString *)country {     
    return [self.countriesDict objectForKey:[country lowercaseString]];
}

@end
