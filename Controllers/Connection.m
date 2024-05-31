//  Created by Joy Biswas on 2/2/23.
//  Copyright © 2023 Kolpolok Limited. All rights reserved.

#import "Connection.h"

//#import "SimplePingClient.h"

@implementation Connection

-(void)parseJSON:(NSDictionary *)dict{
    self.bundleName = [NSString stringWithFormat:@"%@",([dict valueForKey:@"bundleName"]==[NSNull null])?@"":[dict valueForKey:@"bundleName"]];
    self.ipName = [NSString stringWithFormat:@"%@",([dict valueForKey:@"ipName"]==[NSNull null])?@"":[dict valueForKey:@"ipName"]];
    self.ip = [NSString stringWithFormat:@"%@",([dict valueForKey:@"ip"]==[NSNull null])?@"":[dict valueForKey:@"ip"]];
    self.ip_id = [NSString stringWithFormat:@"%@",([dict valueForKey:@"ip_id"]==[NSNull null])?@"":[dict valueForKey:@"ip_id"]];
    self.note = [NSString stringWithFormat:@"%@",([dict valueForKey:@"note"]==[NSNull null])?@"":[dict valueForKey:@"note"]];
    self.typeTxt = [NSString stringWithFormat:@"%@",([dict valueForKey:@"typeTxt"]==[NSNull null])?@"":[dict valueForKey:@"typeTxt"]];
    self.type = [NSString stringWithFormat:@"%@",([dict valueForKey:@"type"]==[NSNull null])?@"":[dict valueForKey:@"type"]];
    self.priority = [NSString stringWithFormat:@"%@",([dict valueForKey:@"priority"]==[NSNull null])?@"":[dict valueForKey:@"priority"]];
    self.config = [NSString stringWithFormat:@"%@",([dict valueForKey:@"config"]==[NSNull null])?@"":[dict valueForKey:@"config"]];
    self.network = [NSString stringWithFormat:@"%@",([dict valueForKey:@"network"]==[NSNull null])?@"":[dict valueForKey:@"network"]];
    self.countryCode = [NSString stringWithFormat:@"%@",([dict valueForKey:@"countryCode"]==[NSNull null])?@"":[dict valueForKey:@"countryCode"]];
    self.vpn_server_id = [NSString stringWithFormat:@"%@",([dict valueForKey:@"vpn_server_id"]==[NSNull null])?@"":[dict valueForKey:@"vpn_server_id"]];
    self.connectionType = [NSString stringWithFormat:@"%@",([dict valueForKey:@"connection_type"]==[NSNull null])?@"":[dict valueForKey:@"connection_type"]];
    self.platform = [NSString stringWithFormat:@"%@",([dict valueForKey:@"platform"]==[NSNull null])?@"":[dict valueForKey:@"platform"]];
    self.countryName = [NSString stringWithFormat:@"%@",([dict valueForKey:@"countryName"]==[NSNull null])?@"":[dict valueForKey:@"countryName"]];
    self.lat = [NSString stringWithFormat:@"%@",([dict valueForKey:@"lat"]==[NSNull null])?@"":[dict valueForKey:@"lat"]];
    self.lng = [NSString stringWithFormat:@"%@",([dict valueForKey:@"lng"]==[NSNull null])?@"":[dict valueForKey:@"lng"]];
    
    Boolean isFree = NO;
    NSInteger freeValue = [[dict valueForKey:@"is_free"] intValue];
    if(freeValue == 1){
        isFree = YES;
    }
    self.isFree = isFree;
    
    Boolean isStreaming = NO;
    NSInteger streamingValue = [[dict valueForKey:@"is_online_stream"] intValue];
    if(streamingValue == 1){
        isStreaming = YES;
    }
    self.isStreaming = isStreaming;

    
    Boolean isGaming = NO;
    NSInteger gamingValue = [[dict valueForKey:@"is_gaming"] intValue];
    if(gamingValue == 1){
        isGaming = YES;
    }
    self.isGaming = isGaming;
    
    
    Boolean isFast = NO;
    NSInteger fastValue = [[dict valueForKey:@"is_fast_server"] intValue];
    if(fastValue == 1){
        isFast = YES;
    }
    self.isFast = isFast;


    Boolean isAdsBloker = NO;
    NSInteger adsblokerValue = [[dict valueForKey:@"is_adblocker"] intValue];
    if(adsblokerValue == 1){
        isAdsBloker = YES;
    }
    self.isAdsBloker = isAdsBloker;
        
    
    self.sortingType = @"";
    self.flag = [self getFlagImage:self.countryCode];
    }


-(NSString*)getFlagImage:(NSString *)countryCode{

    NSString *flagName;
    
    if ([countryCode isEqualToString:@"8"]) {
        return flagName = @"flag_albania";
    }else if([countryCode isEqualToString:@"012"]){
        return flagName = @"flag_algeria";
    }else if([countryCode isEqualToString:@"020"]){
        return flagName = @"flag_andorra";
    }else if([countryCode isEqualToString:@"024"]){
        return flagName = @"flag_angola";
    }else if([countryCode isEqualToString:@"032"]){
        return flagName = @"flag_argentina";
    }else if([countryCode isEqualToString:@"051"]){
        return flagName = @"flag_armenia";
    }else if([countryCode isEqualToString:@"533"]){
        return flagName = @"flag_aruba";
    }else if([countryCode isEqualToString:@"040"]){
        return flagName = @"flag_austria";
    }else if([countryCode isEqualToString:@"036"]){
        return flagName = @"flag_australia";
    }else if([countryCode isEqualToString:@"031"]){
        return flagName = @"flag_azerbaijan";
    }else if([countryCode isEqualToString:@"48"]){
        return flagName = @"flag_bahrain";
    }else if([countryCode isEqualToString:@"050"]){
        return flagName = @"flag_bangladesh";
    }else if([countryCode isEqualToString:@"112"]){
        return flagName = @"flag_belarus";
    }else if([countryCode isEqualToString:@"056"]){
        return flagName = @"flag_belgium";
    }else if([countryCode isEqualToString:@"84"]){
        return flagName = @"flag_belize";
    }else if([countryCode isEqualToString:@"204"]){
        return flagName = @"flag_benin";
    }else if([countryCode isEqualToString:@"064"]){
        return flagName = @"flag_bhutan";
    }else if([countryCode isEqualToString:@"68"]){
        return flagName = @"flag_bolivia";
    }else if([countryCode isEqualToString:@"070"]){
        return flagName = @"flag_bosnia";
    }else if([countryCode isEqualToString:@"072"]){
        return flagName = @"flag_botswana";
    }else if([countryCode isEqualToString:@"076"]){
        return flagName = @"flag_brazil";
    }else if([countryCode isEqualToString:@"96"]){
        return flagName = @"flag_brunei";
    }else if([countryCode isEqualToString:@"100"]){
        return flagName = @"flag_bulgaria";
    }else if([countryCode isEqualToString:@"854"]){
        return flagName = @"flag_burkina_faso";
    }else if([countryCode isEqualToString:@"104"]){
        return flagName = @"flag_myanmar";
    }else if([countryCode isEqualToString:@"108"]){
        return flagName = @"flag_burundi";
    }else if([countryCode isEqualToString:@"116"]){
        return flagName = @"flag_cambodia";
    }else if([countryCode isEqualToString:@"120"]){
        return flagName = @"flag_cameroon";
    }else if([countryCode isEqualToString:@"124"]){
        return flagName = @"flag_canada";
    }else if([countryCode isEqualToString:@"132"]){
        return flagName = @"flag_cape_verde";
    }else if([countryCode isEqualToString:@"140"]){
        return flagName = @"flag_central_african_republic";
    }else if([countryCode isEqualToString:@"148"]){
        return flagName = @"flag_chad";
    }else if([countryCode isEqualToString:@"152"]){
        return flagName = @"flag_chile";
    }else if([countryCode isEqualToString:@"156"]){
        return flagName = @"flag_china";
    }else if([countryCode isEqualToString:@"170"]){
        return flagName = @"flag_colombia";
    }else if([countryCode isEqualToString:@"174"]){
        return flagName = @"flag_comoros";
    }else if([countryCode isEqualToString:@"178"]){
        return flagName = @"flag_republic_of_the_congo";
    }else if([countryCode isEqualToString:@"180"]){
        return flagName = @"flag_democratic_republic_of_the_congo";
    }else if([countryCode isEqualToString:@"184"]){
        return flagName = @"flag_cook_islands";
    }else if([countryCode isEqualToString:@"188"]){
        return flagName = @"flag_costa_rica";
    }else if([countryCode isEqualToString:@"191"]){
        return flagName = @"flag_croatia";
    }else if([countryCode isEqualToString:@"192"]){
        return flagName = @"flag_cuba";
    }else if([countryCode isEqualToString:@"196"]){
        return flagName = @"flag_cyprus";
    }else if([countryCode isEqualToString:@"203"]){
        return flagName = @"flag_czech_republic";
    }else if([countryCode isEqualToString:@"208"]){
        return flagName = @"flag_denmark";
    }else if([countryCode isEqualToString:@"262"]){
        return flagName = @"flag_djibouti";
    }else if([countryCode isEqualToString:@"626"]){
        return flagName = @"flag_timor_leste";
    }else if([countryCode isEqualToString:@"218"]){
        return flagName = @"flag_ecuador";
    }else if([countryCode isEqualToString:@"818"]){
        return flagName = @"flag_egypt";
    }else if([countryCode isEqualToString:@"222"]){
        return flagName = @"flag_el_salvador";
    }else if([countryCode isEqualToString:@"226"]){
        return flagName = @"flag_equatorial_guinea";
    }else if([countryCode isEqualToString:@"232"]){
        return flagName = @"flag_eritrea";
    }else if([countryCode isEqualToString:@"233"]){
        return flagName = @"flag_estonia";
    }else if([countryCode isEqualToString:@"231"]){
        return flagName = @"flag_ethiopia";
    }else if([countryCode isEqualToString:@"238"]){
        return flagName = @"flag_falkland_islands";
    }else if([countryCode isEqualToString:@"234"]){
        return flagName = @"flag_faroe_islands";
    }else if([countryCode isEqualToString:@"242"]){
        return flagName = @"flag_fiji";
    }else if([countryCode isEqualToString:@"246"]){
        return flagName = @"flag_finland";
    }else if([countryCode isEqualToString:@"250"]){
        return flagName = @"flag_france";
    }else if([countryCode isEqualToString:@"258"]){
        return flagName = @"flag_french_polynesia";
    }else if([countryCode isEqualToString:@"266"]){
        return flagName = @"flag_gabon";
    }else if([countryCode isEqualToString:@"270"]){
        return flagName = @"flag_gambia";
    }else if([countryCode isEqualToString:@"268"]){
        return flagName = @"flag_georgia";
    }else if([countryCode isEqualToString:@"276"]){
        return flagName = @"flag_germany";
    }else if([countryCode isEqualToString:@"288"]){
        return flagName = @"flag_ghana";
    }else if([countryCode isEqualToString:@"292"]){
        return flagName = @"flag_gibraltar";
    }else if([countryCode isEqualToString:@"300"]){
        return flagName = @"flag_greece";
    }else if([countryCode isEqualToString:@"304"]){
        return flagName = @"flag_greenland";
    }else if([countryCode isEqualToString:@"320"]){
        return flagName = @"flag_guatemala";
    }else if([countryCode isEqualToString:@"324"]){
        return flagName = @"flag_guinea";
    }else if([countryCode isEqualToString:@"624"]){
        return flagName = @"flag_guinea_bissau";
    }else if([countryCode isEqualToString:@"328"]){
        return flagName = @"flag_guyana";
    }else if([countryCode isEqualToString:@"332"]){
        return flagName = @"flag_haiti";
    }else if([countryCode isEqualToString:@"340"]){
        return flagName = @"flag_honduras";
    }else if([countryCode isEqualToString:@"344"]){
        return flagName = @"flag_hong_kong";
    }else if([countryCode isEqualToString:@"348"]){
        return flagName = @"flag_hungary";
    }else if([countryCode isEqualToString:@"356"]){
        return flagName = @"flag_india";
    }else if([countryCode isEqualToString:@"360"]){
        return flagName = @"flag_indonesia";
    }else if([countryCode isEqualToString:@"364"]){
        return flagName = @"flag_iran";
    }else if([countryCode isEqualToString:@"368"]){
        return flagName = @"flag_iraq";
    }else if([countryCode isEqualToString:@"372"]){
        return flagName = @"flag_ireland";
    }else if([countryCode isEqualToString:@"833"]){
        return flagName = @"flag_isleof_man";
    }else if([countryCode isEqualToString:@"376"]){
        return flagName = @"flag_israel";
    }else if([countryCode isEqualToString:@"380"]){
        return flagName = @"flag_italy";
    }else if([countryCode isEqualToString:@"384"]){
        return flagName = @"flag_cote_divoire";
    }else if([countryCode isEqualToString:@"392"]){
        return flagName = @"flag_japan";
    }else if([countryCode isEqualToString:@"400"]){
        return flagName = @"flag_jordan";
    }else if([countryCode isEqualToString:@"398"]){
        return flagName = @"flag_kenya";
    }else if([countryCode isEqualToString:@"414"]){
        return flagName = @"flag_kiribati";
    }else if([countryCode isEqualToString:@"296"]){
        return flagName = @"flag_kuwait";
    }else if([countryCode isEqualToString:@"417"]){
        return flagName = @"flag_kyrgyzstan";
    }else if([countryCode isEqualToString:@"136"]){
        return flagName = @"flag_cayman_islands";
    }else if([countryCode isEqualToString:@"418"]){
        return flagName = @"flag_laos";
    }else if([countryCode isEqualToString:@"428"]){
        return flagName = @"flag_latvia";
    }else if([countryCode isEqualToString:@"422"]){
        return flagName = @"flag_lebanon";
    }else if([countryCode isEqualToString:@"426"]){
        return flagName = @"flag_lesotho";
    }else if([countryCode isEqualToString:@"430"]){
        return flagName = @"flag_liberia";
    }else if([countryCode isEqualToString:@"434"]){
        return flagName = @"flag_libya";
    }else if([countryCode isEqualToString:@"438"]){
        return flagName = @"flag_liechtenstein";
    }else if([countryCode isEqualToString:@"440"]){
        return flagName = @"flag_lithuania";
    }else if([countryCode isEqualToString:@"442"]){
        return flagName = @"flag_luxembourg";
    }else if([countryCode isEqualToString:@"450"]){
        return flagName = @"flag_madagascar";
    }else if([countryCode isEqualToString:@"454"]){
        return flagName = @"flag_malawi";
    }else if([countryCode isEqualToString:@"458"]){
        return flagName = @"flag_malaysia";
    }else if([countryCode isEqualToString:@"462"]){
        return flagName = @"flag_maldives";
    }else if([countryCode isEqualToString:@"466"]){
        return flagName = @"flag_mali";
    }else if([countryCode isEqualToString:@"470"]){
        return flagName = @"flag_malta";
    }else if([countryCode isEqualToString:@"584"]){
        return flagName = @"flag_marshall_islands";
    }else if([countryCode isEqualToString:@"478"]){
        return flagName = @"flag_mauritania";
    }else if([countryCode isEqualToString:@"480"]){
        return flagName = @"flag_mauritius";
    }else if([countryCode isEqualToString:@"175"]){
        return flagName = @"flag_martinique";
    }else if([countryCode isEqualToString:@"474"]){
        return flagName = @"flag_martinique";
    }else if([countryCode isEqualToString:@"484"]){
        return flagName = @"flag_mexico";
    }else if([countryCode isEqualToString:@"583"]){
        return flagName = @"flag_micronesia";
    }else if([countryCode isEqualToString:@"498"]){
        return flagName = @"flag_moldova";
    }else if([countryCode isEqualToString:@"492"]){
        return flagName = @"flag_monaco";
    }else if([countryCode isEqualToString:@"496"]){
        return flagName = @"flag_mongolia";
    }else if([countryCode isEqualToString:@"499"]){
        return flagName = @"flag_of_montenegro";
    }else if([countryCode isEqualToString:@"504"]){
        return flagName = @"flag_morocco";
    }else if([countryCode isEqualToString:@"508"]){
        return flagName = @"flag_mozambique";
    }else if([countryCode isEqualToString:@"516"]){
        return flagName = @"flag_namibia";
    }else if([countryCode isEqualToString:@"520"]){
        return flagName = @"flag_nauru";
    }else if([countryCode isEqualToString:@"524"]){
        return flagName = @"flag_nepal";
    }else if([countryCode isEqualToString:@"528"]){
        return flagName = @"flag_netherlands";
    }else if([countryCode isEqualToString:@"540"]){
        return flagName = @"flag_new_caledonia";
    }else if([countryCode isEqualToString:@"554"]){
        return flagName = @"flag_new_zealand";
    }else if([countryCode isEqualToString:@"558"]){
        return flagName = @"flag_nicaragua";
    }else if([countryCode isEqualToString:@"562"]){
        return flagName = @"flag_niger";
    }else if([countryCode isEqualToString:@"566"]){
        return flagName = @"flag_nigeria";
    }else if([countryCode isEqualToString:@"570"]){
        return flagName = @"flag_niue";
    }else if([countryCode isEqualToString:@"410"]){
        return flagName = @"flag_north_korea";
    }else if([countryCode isEqualToString:@"578"]){
        return flagName = @"flag_norway";
    }else if([countryCode isEqualToString:@"512"]){
        return flagName = @"flag_oman";
    }else if([countryCode isEqualToString:@"586"]){
        return flagName = @"flag_pakistan";
    }else if([countryCode isEqualToString:@"585"]){
        return flagName = @"flag_palau";
    }else if([countryCode isEqualToString:@"591"]){
        return flagName = @"flag_panama";
    }else if([countryCode isEqualToString:@"598"]){
        return flagName = @"flag_papua_new_guinea";
    }else if([countryCode isEqualToString:@"600"]){
        return flagName = @"flag_paraguay";
    }else if([countryCode isEqualToString:@"604"]){
        return flagName = @"flag_peru";
    }else if([countryCode isEqualToString:@"608"]){
        return flagName = @"flag_philippines";
    }else if([countryCode isEqualToString:@"612"]){
        return flagName = @"flag_pitcairn_islands";
    }else if([countryCode isEqualToString:@"616"]){
        return flagName = @"flag_poland";
    }else if([countryCode isEqualToString:@"620"]){
        return flagName = @"flag_portugal";
    }else if([countryCode isEqualToString:@"630"]){
        return flagName = @"flag_puerto_rico";
    }else if([countryCode isEqualToString:@"634"]){
        return flagName = @"flag_qatar";
    }else if([countryCode isEqualToString:@"642"]){
        return flagName = @"flag_romania";
    }else if([countryCode isEqualToString:@"643"]){
        return flagName = @"flag_russian_federation";
    }else if([countryCode isEqualToString:@"646"]){
        return flagName = @"flag_rwanda";
    }else if([countryCode isEqualToString:@"652"]){
        return flagName = @"flag_saint_barthelemy";
    }else if([countryCode isEqualToString:@"882"]){
        return flagName = @"flag_samoa";
    }else if([countryCode isEqualToString:@"674"]){
        return flagName = @"flag_san_marino";
    }else if([countryCode isEqualToString:@"678"]){
        return flagName = @"flag_sao_tome_and_principe";
    }else if([countryCode isEqualToString:@"682"]){
        return flagName = @"flag_saudi_arabia";
    }else if([countryCode isEqualToString:@"686"]){
        return flagName = @"flag_senegal";
    }else if([countryCode isEqualToString:@"688"]){
        return flagName = @"flag_serbia";
    }else if([countryCode isEqualToString:@"690"]){
        return flagName = @"flag_seychelles";
    }else if([countryCode isEqualToString:@"694"]){
        return flagName = @"flag_sierra_leone";
    }else if([countryCode isEqualToString:@"702"]){
        return flagName = @"flag_singapore";
    }else if([countryCode isEqualToString:@"703"]){
        return flagName = @"flag_slovakia";
    }else if([countryCode isEqualToString:@"705"]){
        return flagName = @"flag_slovenia";
    }else if([countryCode isEqualToString:@"90"]){
        return flagName = @"flag_soloman_islands";
    }else if([countryCode isEqualToString:@"706"]){
        return flagName = @"flag_somalia";
    }else if([countryCode isEqualToString:@"710"]){
        return flagName = @"flag_south_africa";
    }else if([countryCode isEqualToString:@"408"]){
        return flagName = @"flag_south_korea";
    }else if([countryCode isEqualToString:@"724"]){
        return flagName = @"flag_spain";
    }else if([countryCode isEqualToString:@"144"]){
        return flagName = @"flag_sri_lanka";
    }else if([countryCode isEqualToString:@"654"]){
        return flagName = @"flag_saint_helena";
    }else if([countryCode isEqualToString:@"666"]){
        return flagName = @"flag_saint_pierre";
    }else if([countryCode isEqualToString:@"729"]){
        return flagName = @"flag_sudan";
    }else if([countryCode isEqualToString:@"740"]){
        return flagName = @"flag_suriname";
    }else if([countryCode isEqualToString:@"752"]){
        return flagName = @"flag_sweden";
    }else if([countryCode isEqualToString:@"756"]){
        return flagName = @"flag_switzerland";
    }else if([countryCode isEqualToString:@"760"]){
        return flagName = @"flag_syria";
    }else if([countryCode isEqualToString:@"158"]){
        return flagName = @"flag_taiwan";
    }else if([countryCode isEqualToString:@"762"]){
        return flagName = @"flag_tajikistan";
    }else if([countryCode isEqualToString:@"834"]){
        return flagName = @"flag_tanzania";
    }else if([countryCode isEqualToString:@"764"]){
        return flagName = @"flag_thailand";
    }else if([countryCode isEqualToString:@"768"]){
        return flagName = @"flag_togo";
    }else if([countryCode isEqualToString:@"772"]){
        return flagName = @"flag_tokelau";
    }else if([countryCode isEqualToString:@"776"]){
        return flagName = @"flag_tonga";
    }else if([countryCode isEqualToString:@"788"]){
        return flagName = @"flag_tunisia";
    }else if([countryCode isEqualToString:@"792"]){
        return flagName = @"flag_turkey";
    }else if([countryCode isEqualToString:@"795"]){
        return flagName = @"flag_turkmenistan";
    }else if([countryCode isEqualToString:@"798"]){
        return flagName = @"flag_tuvalu";
    }else if([countryCode isEqualToString:@"784"]){
        return flagName = @"flag_uae";
    }else if([countryCode isEqualToString:@"800"]){
        return flagName = @"flag_uganda";
    }else if([countryCode isEqualToString:@"826"]){
        return flagName = @"flag_united_kingdom";
    }else if([countryCode isEqualToString:@"804"]){
        return flagName = @"flag_ukraine";
    }else if([countryCode isEqualToString:@"858"]){
        return flagName = @"flag_uruguay";
    }else if([countryCode isEqualToString:@"840"]){
        return flagName = @"flag_united_states_of_america";
    }else if([countryCode isEqualToString:@"860"]){
        return flagName = @"flag_uzbekistan";
    }else if([countryCode isEqualToString:@"548"]){
        return flagName = @"flag_vanuatu";
    }else if([countryCode isEqualToString:@"862"]){
        return flagName = @"flag_venezuela";
    }else if([countryCode isEqualToString:@"704"]){
        return flagName = @"flag_vietnam";
    }else if([countryCode isEqualToString:@"876"]){
        return flagName = @"flag_wallis_and_futuna";
    }else if([countryCode isEqualToString:@"887"]){
        return flagName = @"flag_yemen";
    }else if([countryCode isEqualToString:@"894"]){
        return flagName = @"flag_zambia";
    }else if([countryCode isEqualToString:@"716"]){
        return flagName = @"flag_zimbabuwe";
    }else if([countryCode isEqualToString:@"660"]){
        return flagName = @"flag_anguilla";
    }else if([countryCode isEqualToString:@"28"]){
        return flagName = @"flag_antigua_and_barbuda";
    }else if([countryCode isEqualToString:@"044"]){
        return flagName = @"flag_bahamas";
    }else if([countryCode isEqualToString:@"052"]){
        return flagName = @"flag_barbados";
    }else if([countryCode isEqualToString:@"92"]){
        return flagName = @"flag_british_virgin_islands";
    }else if([countryCode isEqualToString:@"212"]){
        return flagName = @"flag_dominica";
    }else if([countryCode isEqualToString:@"214"]){
        return flagName = @"flag_dominican_republic";
    }else if([countryCode isEqualToString:@"308"]){
        return flagName = @"flag_grenada";
    }else if([countryCode isEqualToString:@"388"]){
        return flagName = @"flag_jamaica";
    }else if([countryCode isEqualToString:@"500"]){
        return flagName = @"flag_montserrat";
    }else if([countryCode isEqualToString:@"659"]){
        return flagName = @"flag_saint_kitts_and_nevis";
    }else if([countryCode isEqualToString:@"662"]){
        return flagName = @"flag_saint_lucia";
    }else if([countryCode isEqualToString:@"670"]){
        return flagName = @"flag_saint_vicent_and_the_grenadines";
    }else if([countryCode isEqualToString:@"780"]){
        return flagName = @"flag_trinidad_and_tobago";
    }else if([countryCode isEqualToString:@"796"]){
        return flagName = @"flag_turks_and_caicos_islands";
    }else if([countryCode isEqualToString:@"850"]){
        return flagName = @"flag_us_virgin_islands";
    }else if([countryCode isEqualToString:@"728"]){
        return flagName = @"flag_south_sudan";
    }else if([countryCode isEqualToString:@"9999"]){
        return flagName = @"flag_south_sudan";
    }else if([countryCode isEqualToString:@"1111"]){
        return flagName = @"flag_south_sudan";
    }else{
        return flagName = @"flag_united_kingdom";
    }
}
@end
