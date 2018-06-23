//
//  CutsConstants.swift
//  electricitywatercuts
//
//  Created by nils on 24.04.2018.
//  Copyright © 2018 nils. All rights reserved.
//

import Foundation

struct CutsConstants {
    static let water_cuts = "iski"
    static let europe_electricity_cuts = "bedas"
    static let anatolia_electricty_cuts = "ayedas"
    static let CUTS_LINK_LIST: [String] = ["http://www.iski.gov.tr/web/tr-TR/ariza-kesinti",
                                           "https://www.bedas.com.tr/kesinti.asp?ilce=%@&tip=%@&tarih=%@",
                                           "https://www.ayedas.com.tr/Pages/Bilgilendirme/PlanliBakim/Planli-Kesinti-Listesi-ve-Haritasi.aspx"]
    static let BEDAS_CUT_TYPE_PLANNED = "0"
    static let BEDAS_CUT_TYPE_INSTANTANEOUS = "1"
    
    static let CUT_TYPE_ELECTRICITY = "e"
    static let CUT_TYPE_WATER = "w"
    static let CUT_TYPE_ELECTRICITY_IMAGE = "electricity"
    static let CUT_TYPE_WATER_IMAGE = "water"
    
    /*
    static let PREF_RANGE = "pref_cuts_range_option"
    static let PREF_FREQ = "pref_cuts_freq_option"
    static let PREF_ORDER = "pref_cuts_order_option"
    
    static let PREF_ORDER_CRITERIA = "pref_cuts_order_criteria_option"
    static let PREF_SEARCH_STR_OPTION = "pref_cuts_search_str"
    static let PREF_LANG = "pref_cuts_lang_option"
    */
    
    static let SETTING_RANGE = "PREF_RANGE"
    static let SETTING_FREQ = "PREF_FREQ"
    static let SETTING_ORDER = "PREF_ORDER"
    static let SETTING_ORDER_CRITERIA = "PREF_ORDER_OPTION"
    static let SETTING_SEARCH_STR_OPTION = "PREF_SEARCH_STR_OPTION"
    static let SETTING_LANG = "PREF_LANG"
    static let SETTING_DELETION_FREQ = "SETTING_DELETION_FREQ"
    
    //  public static final Uri CONTENT_URI = Uri.parse("content://com.nils.electricitywatercuts/cuts");
    
    static let DATABASE_NAME = "electricitywatercuts.sqlite";
    static let DATABASE_VERSION = 1;
    static let CUTS_TABLE = "electricitywatercuts";
    
    // Column Names
    static let KEY_ID = "_id"
    static let KEY_OPERATOR_NAME = "operator_name"
    static let KEY_START_DATE = "start_date"
    static let KEY_END_DATE = "end_date"
    static let KEY_LOCATION = "location"
    static let KEY_REASON = "reason"
    static let KEY_DETAIL = "detail"
    
    static let KEY_TYPE = "type"
    static let KEY_SEARCH_TEXT = "search_text"
    static let KEY_ORDER_START_DATE = "order_start_date"
    static let KEY_ORDER_END_DATE = "order_end_date"
    static let KEY_INSERT_DATE = "insert_date"
    static let KEY_IS_CURRENT = "is_current"
    
    static let INTENT_CUTS_NOTIFICATION = "com.nils.electricitywatercuts.ACTION_REFRESH_CUTS_ALARM"
    static let INTENT_CUTS_ORGANIZE_DB = "com.nils.electricitywatercuts.ACTION_ORGANIZE_CUTS_DB_ALARM"
    static let INTENT_CUTS_BOOT_COMPLETED = "android.intent.action.BOOT_COMPLETED"
    static let INTENT_CUTS_NOTIFICATION_FLAG = "cutsNotificationFlag"
    static let INTENT_CUTS_BOOT_FLAG = "cutsBootFlag"
    static let INTENT_CUTS_FREQ = "cutsFreq"
    
    static let DEFAULT_TARGET_URI = "http://goo.gl/jgqzvz";
    //"http://play.google.com/store/apps/details?id=com.nils.electricitywatercuts"
    
    static let ddMMyyyyHHmm = "dd.MM.yyyy HH:mm"
    static let ddMMyyyyHHmmss = "dd.MM.yyyy HH:mm:ss"
    static let yyyyMMdd = "yyyy-MM-dd"
    static let ddMMyyyy = "dd.MM.yyyy"
    static let dMyyyy = "d.M.yyyy"
    static let yyyyMMddTHHmmssZ = "yyyy-MM-dd'T'HH:mm:ssZ"
    
    static let turkishChars: [UInt32] = [0x131, 0x130, 0xFC, 0xDC, 0xF6, 0xD6, 0x15F, 0x15E, 0xE7, 0xC7, 0x11F, 0x11E]
    static let englishChars: [Character] = ["i", "I", "u", "U", "o", "O", "s", "S", "c", "C", "g", "G"]

    // app rate
    /*
    public final static String RATE_DONT_SHOW = "rate_dontshowagain";
    public final static String RATE_REMIND = "rate_remindlater";
    public final static String RATE_CLICKED_RATE = "rate_clickedrated";
    public final static String COUNT_APP_LAUNCH = "app_launch_count";
    public final static String COUNT_REMIND_LAUNCH = "remind_launch_count";
    public final static String COUNT_RATED_LAUNCH = "rated_launch_count";
    public final static String DATE_FIRST_LAUNCH = "app_first_launch";
    public final static String DATE_REMIND_START = "remind_start_date";
    public final static String DATE_RATED_START = "rated_start_date";
    
    public final static int DAYS_FIRST_PROMPT = 7;
    public final static int DAYS_REMIND_PROMPT = 15;
    public final static int DAYS_RATED_PROMPT = 30;
    
    public final static int LAUNCHES_FIRST_PROMPT = 10;
    public final static int LAUNCHES_REMIND = 15;
    public final static int LAUNCHES_RATED = 25;
    
    public final static String INSTALL_SHORTCUT = "pref_install_shortcut";
 */
}


