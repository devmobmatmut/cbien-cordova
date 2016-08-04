/********* CBienKit.m Cordova Plugin Implementation *******/

#import <Cordova/CDV.h>
#import <CBienKit/CBienKit.h>

@interface CBienKit : CDVPlugin {
    // Member variables go here.
}

- (void)initialize:(CDVInvokedUrlCommand*)command;
- (void)configure:(CDVInvokedUrlCommand*)command;
- (void)show:(CDVInvokedUrlCommand*)command;

@end

@implementation CBienKit


- (UIColor *)colorFromHexString:(NSString *)hexString
{
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1];
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

- (void)initialize:(CDVInvokedUrlCommand*)command
{
    NSString* clientId = self.commandDelegate.settings[@"cbien-ios-clientid"];
    NSString* clientSecret = self.commandDelegate.settings[@"cbien-ios-clientsecret"];
    
    NSDictionary *options = command.arguments[0];
    NSString *uniqueIdentifier = options[@"uniqueIdentifier"];
    
    [CBienCore configureWithClientId:clientId andSecret:clientSecret andUniqueIdentifier:uniqueIdentifier];
    
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)configure:(CDVInvokedUrlCommand*)command
{
    NSDictionary *options = command.arguments[0];
    NSString *logoBase64 = options[@"logo"];
    NSString *primaryColorHex = options[@"primaryColor"];
    NSString *colorOnPrimaryColorHex = options[@"colorOnPrimaryColorHex"];
    NSString *secondaryColorHex = options[@"secondaryColor"];
    NSString *colorOnSecondaryColorHex = options[@"colorOnSecondaryColorHex"];
    
    if(logoBase64){
        NSData *data = [[NSData alloc] initWithBase64EncodedString:logoBase64 options:0];
        [CBienCore setLogo:[UIImage imageWithData:data]];
    }
    
    if(primaryColorHex){
        [CBienCore setPrimaryColor:[self colorFromHexString:primaryColorHex]];
    }
    
    if(colorOnPrimaryColorHex){
        [CBienCore setColorOnPrimaryColor:[self colorFromHexString:colorOnPrimaryColorHex]];
    }
    
    if(secondaryColorHex){
        [CBienCore setSecondaryColor:[self colorFromHexString:secondaryColorHex]];
    }
    
    if(colorOnSecondaryColorHex){
        [CBienCore setColorOnSecondaryColor:[self colorFromHexString:colorOnSecondaryColorHex]];
    }
    
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)show:(CDVInvokedUrlCommand*)command
{
    [CBienCore show:self.viewController];
    
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

@end