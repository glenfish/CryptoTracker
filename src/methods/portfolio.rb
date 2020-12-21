require_relative '../api/api'

def waiting(symbol=".")
    i = 0
    loop do
        print symbol
        sleep(0.006)
        i += 1
        if i == 90
            break
        end
    end
end

# create portfolio object
def create_portfolio_object(username)
    portfolio_object = Portfolio.new(username)
    return portfolio_object
end

# add a new crypto entry to portfolio, or changes an existing entry. Can set quantity = 0 to as a form of quasi delete.
def add_crypto_to_portfolio(active_user)
    path_to_portfolio_file = "./json/portfolios/#{active_user.username}.json"
    portfolio_json = read_json_file(path_to_portfolio_file)
    # p portfolio_json
    puts "Enter the crypto SYMBOL:\n"
    symbol = gets.strip.chomp.upcase
    puts "Enter the quantity:\n"
    quantity = gets.strip.chomp.to_f
    if quantity > 0.0
        puts "Please confirm: #{quantity} #{symbol} (y/n)" # verify user wants to add crypto to portfolio
    elsif quantity == 0.0
        puts "Please confirm you are deleting #{symbol} (y/n)" # does not delete, just sets quantity = 0
    else
        puts "You cannot enter a negative number for quantity. Must be positive or zero."
    return
    end
    confirm = gets.strip.chomp.downcase
    if (confirm == 'y' && quantity >= 0)
        json= {"username":active_user.username,"data":portfolio_json['data'].merge({symbol=>{"asset_name"=>"", "asset_quantity"=>quantity, "asset_buy_date"=>Time.now.strftime("%Y-%m-%d"), "asset_sell_date"=>"", "usd_price"=>"", "btc_price"=>"", "usd_profit"=>"", "btc_profit"=>""}})}
        write_json_file(json, path_to_portfolio_file)
        if quantity > 0 # only update portfolio.modified if a cypto was changed to a positive value. Setting to 0 will do nothing
            active_user.portfolio_modified = true
        end
        puts "Your portfolio was updated"
    else
        puts "Your portfolio was not changed"
    end
# rescue

end

def show_portfolio(portfolio_assets_quantities_array, active_user = "")
    clear
    active_user_name = active_user.name
    api_key = active_user.api_key
    puts "#{active_user_name}, Select either cached or live crypto pricing:\n"
    # puts "big list... y or n ?\n"
    # if gets.chomp == "y"
    portfolio_array = ["BTC", "LTC", "NMC", "TRC", "PPC", "NVC", "FTC", "FRC", "IXC", "BTB", "DGC", "GLC", "PXC", "MEC", "IFC", "XPM", "ANC", "CSC", "EMD", "XRP", "QRK", "ZET", "SXC", "TAG", "FLO", "NXT", "UNO", "DTC", "DEM", "DOGE", "DMD", "HBN", "ORB", "OMNI", "TIPS", "MOON", "DIME", "42", "VTC", "DGB", "SMC", "RDD", "POT", "BLC", "MAX", "DASH", "XCP", "MINT", "DOPE", "AUR", "PTC", "PND", "UFO", "BLK", "PHO", "XMY", "NOTE", "EMC2", "ECC", "MONA", "RBY", "BELA", "SLR", "EFL", "NLG", "GRS", "XPD", "PLNC", "XWC", "POP", "BITS", "QBC", "BLU", "MAID", "XBC", "NYC", "PINK", "DRM", "ENRG", "VRC", "XMR", "LCP", "CURE", "SUPER", "BOST", "MOTO", "CLOAK", "BSD", "C2", "BCN", "NAV", "START", "XDN", "BBR", "THC", "XST", "CLAM", "BTS", "VIA", "IOC", "XCN", "CARBON", "CANN", "XLM", "TIT", "SYS", "DONU", "EMC", "RBBT", "BURST", "GAME", "N8V", "UBQ", "OPAL", "ACOIN", "BITCNY", "USNBT", "EXCL", "TROLL", "BSTY", "PXI", "XVG", "NSR", "SPR", "RBT", "MUE", "BLOCK", "VIP", "CRW", "GCN", "XQN", "OK", "XPY", "COVAL", "NXS", "SMLY", "KOBO", "BITB", "GEO", "USDT", "WBB", "GRC", "XCO", "LDOGE", "SONG", "XEM", "NTRN", "XAUR", "CF", "AIB", "SPHR", "MEDIC", "BUB", "UNIT", "PKB", "ARB", "BTA", "ADC", "SNRG", "FJC", "GXX", "XRA", "CREVA", "ZNY", "BSC", "HNC", "CPS", "MANNA", "AXIOM", "LC4", "AEON", "ETH", "TX", "GCC", "AMS", "AGRS", "EUC", "SC", "GCR", "SHIFT", "VEC2", "BOLI", "BCY", "PAK", "EXP", "SIB", "SWING", "FCT", "DUO", "SANDG", "REP", "SHND", "PAC", "DFT", "OBITS", "CLUB", "ADZ", "MOIN", "AV", "EGC", "RADS", "LTCR", "YOC", "SLS", "FRN", "EVIL", "DCR", "PIVX", "SFT", "RBIES", "TRUMP", "MEME", "IMS", "NEVA", "PEX", "CAB", "MOJO", "LSK", "EDRC", "POST", "BERN", "DGD", "STEEM", "ESP", "FUZZ", "XHI", "ARCO", "XBTC21", "EL", "ZUR", "2GIVE", "XPTX", "LANA", "PONZI", "MXT", "CTL", "WAVES", "PWR", "ION", "HVCO", "GB", "CMT", "RISE", "CHESS", "LBC", "PUT", "CJ", "HEAT", "SBD", "ARDR", "ETC", "BIT", "KRB", "STRAX", "ACES", "TAJ", "EDC", "VLT", "NEO", "BTDX", "NLC2", "VRM", "ZYD", "PLU", "DLC", "MST", "PROUD", "1ST", "SNGLS", "XZC", "ARC", "ZEC", "ASAFE", "ZCL", "LKK", "GNT", "IOP", "VRS", "HUSH", "KURT", "PASC", "ENT", "INCNT", "DCT", "VSL", "DOLLAR", "GBYTE", "POSW", "LUNA", "WINGS", "JUP", "IFLT", "ALIAS", "BENJI", "CCRB", "VIDZ", "ICOB", "IBANK", "MKR", "KMD", "FRST", "WCT", "ICON", "CNT", "MLN", "TIME", "ARGUS", "SWT", "NANO", "MILO", "ZER", "NETKO", "ARK", "DYN", "TKS", "MER", "EDG", "MAVRO", "UNI", "XLR", "XAS", "DBIX", "GUP", "USC", "SKY", "BLAZR", "ZENI", "CXT", "CONX", "XBY", "RLC", "TRST", "SCS", "BTX", "VOLT", "LUN", "GNO", "TKN", "HMQ", "ITI", "MNE", "CNNC", "CREA", "DICE", "INSN", "ANT", "PZM", "QTUM", "DMB", "NANOX", "MAY", "SUMO", "BAT", "ZEN", "AE", "ETP", "EBST", "ADK", "PTOY", "VERI", "ECA", "QRL", "ETT", "MGO", "PPY", "MIOTA", "MYST", "MORE", "SNM", "ADL", "ZRC", "BNT", "GLT", "NMR", "UNIFY", "XEL", "DCY", "ONX", "GXC", "ATCC", "BRO", "FLASH", "FUN", "PAY", "SNT", "ERG", "BRIA", "EOS", "ADX", "D", "BET", "STORJ", "SOCC", "ADT", "MCO", "PING", "WGR", "PLBT", "GAS", "SNC", "JET", "MTL", "PPT", "RUP", "PCN", "SAN", "OMG", "TER", "CVN", "MRX", "CVC", "VGX", "COAL", "LBTC", "PART", "SMART", "SKIN", "BCH", "HMC", "TOA", "PLR", "SIGT", "OCT", "BNB", "PBT", "EMB", "IXT", "GSR", "CRM", "KEK", "OAX", "DNT", "STX", "CDT", "BTM", "TIX", "DCN", "RUPX", "SHDW", "ONION", "CAT", "ADS", "DENT", "IFT", "TCC", "ZRX", "YOYOW", "MYB", "HC", "TFL", "NAS", "BBP", "ACT", "TNT", "WTC", "PST", "OPT", "SUR", "LRC", "LTCU", "POE", "MCC", "MTH", "AVT", "DLT", "HVN", "MDA", "NEBL", "TRX", "REX", "BUZZ", "CREDO", "MANA", "IND", "XPA", "SCL", "ATB", "PRO", "LINK", "BMC", "XBL", "KNC", "VIBE", "SUB", "DAY", "RVT", "KIN", "SALT", "ORMEUS", "COLX", "TZC", "COB", "MSD", "BIS", "ADA", "XTZ", "VOISE", "XIN", "KICK", "VIB", "REV", "INXT", "CNX", "REAL", "HBT", "EVX", "PPP", "BTCZ", "HGT", "CND", "ENG", "ZSC", "PIPL", "AST", "CAG", "BCPT", "AION", "ART", "XGOX", "EVR", "DRT", "REQ", "ETG", "BLUE", "LIFE", "AMB", "BTG", "KCS", "EXRN", "LA", "XUC", "NULS", "BOS", "RCN", "ICX", "JS", "ITT", "IETH", "PIRL", "LUX", "DOV", "PHX", "FUEL", "ELLA", "FYP", "EBTC", "ENJ", "IBTC", "POWR", "GRID", "ATL", "ETN", "SONO", "DATA", "XSH", "ELTCOIN", "DSR", "NIOX", "ARNX", "PHR", "RDN", "DPY", "ERC20", "EPY", "DBET", "UFR", "GVT", "PRIX", "LTHN", "PAYX", "XLQ", "GBX", "B2B", "PNX", "DNA", "INK", "QSP", "QASH", "TSL", "SPANK", "VOT", "BCD", "VEE", "MONK", "FLIXX", "TNB", "WISH", "EVC", "ONG", "CCO", "QBT", "DRGN", "PFR", "PRE", "BCDN", "CAPP", "ERO", "ITC", "SEND", "BON", "NUKO", "SNOV", "DAM", "WABI", "WAND", "UQC", "MDS", "PRA", "IGNIS", "SMT", "HWC", "PKT", "FIL", "BCX", "SBTC", "DAT", "AMM", "LOC", "WRC", "GTO", "YTN", "GNX", "UBTC", "STAR", "OST", "STMX", "DTR", "ELF", "WAXP", "MED", "NGC", "BRD", "BIX", "SPHTX", "BNTY", "ACE", "DIM", "SRN", "CPAY", "HTML", "DBC", "NEU", "QC", "UTK", "QLC", "PLAY", "ONE", "MTX", "HPY", "PYLNT", "STAK", "GTC", "TAU", "BLT", "SWFTC", "COV", "CAN", "APPC", "HPB", "WICC", "MDT", "CL", "GET", "CFUN", "AIDOC", "POLIS", "ZAP", "TCT", "FAIR", "AIX", "XNS", "GOD", "UTT", "CDX", "BDG", "QUN", "TOPC", "LEV", "KCASH", "ATN", "SXDT", "SXUT", "SWTC", "KZC", "BCA", "EKO", "BTO", "TEL", "IC", "WETH", "KEY", "INT", "RNT", "SENSE", "MOAC", "IOST", "IDT", "AIT", "QUBE", "SPC", "ORE", "RCT", "ARCT", "THETA", "MVC", "IPL", "IDXM", "AGI", "CHAT", "DDD", "MOBI", "HOT", "STC", "MAG", "REF", "YEE", "AAC", "SSC", "MOF", "TNC", "C20", "DTA", "CRPT", "SPK", "CV", "TBX", "EKT", "UIP", "PRS", "TRUE", "OCN", "IDH", "QBIC", "AID", "EVE", "BUX", "AXPR", "TRAC", "LET", "ZIL", "MEET", "SLT", "FOTA", "SOC", "MAN", "GRLC", "RUFF", "NKC", "COFI", "EQL", "HLC", "ZPT", "CPC", "OC", "VLC", "BTW", "CXO", "CXP", "ELA", "STK", "POLY", "MTN", "JNT", "CHSB", "ZLA", "ADB", "HT", "DMT", "BLZ", "SWM", "TKY", "ESZ", "DXT", "WPR", "MNTP", "MLM", "AVH", "LOCI", "UTNP", "ACAT", "DTH", "CAS", "FSN", "MWAT", "DADI", "NTK", "GEM", "NEC", "REN", "LCC", "STQ", "TDX", "NCASH", "ABT", "REM", "EXY", "POA", "XNK", "BEZ", "IHT", "RFR", "LYM", "CS", "BEE", "INSTAR", "AUTO", "TUBE", "LEDU", "TUSD", "HQX", "STAC", "ONT", "DATX", "J8T", "CHP", "TOMO", "GRFT", "BAX", "ELEC", "BTCP", "TEN", "RVN", "TONE", "SHIP", "LDC", "LALA", "DEB", "CENNZ", "SNX", "LOOM", "GETX", "DROP", "BANCA", "DRG", "NANJ", "CKUSD", "UP", "LGO", "1WO", "NPX", "NPXS", "BITG", "BFT", "WAN", "AMLT", "MITH", "LST", "PCL", "SIG", "XBP", "LNC", "SPD", "IPSX", "SCC", "BSTN", "SWTH", "SEN", "SENC", "FDZ", "TPAY", "BERRY", "XLA", "NCT", "ODE", "XSN", "XDC", "CTXC", "CPX", "CVT", "SENT", "EOSDAC", "UUU", "ADH", "BSM", "DEV", "CBT", "AUC", "BUBO", "XMC", "DAN", "MFG", "ADI", "TRIO", "XHV", "KST", "CRC", "DERO", "EFX", "FTX", "MRK", "SRCOIN", "CHX", "MSR", "DOCK", "PHI", "BBC", "DML", "ZEBI", "LND", "XES", "VIPS", "RBLX", "BTRN", "PNT", "NBAI", "NEXO", "VME", "DAX", "HYDRO", "SS", "CEL", "BCI", "BETR", "TNS", "AMN", "FLP", "CMCT", "MITX", "MTC", "MT", "NTY", "BOUTS", "PAL", "CRE", "GENE", "APR", "AC3", "FXT", "ZIPT", "SKM", "GEN", "BZNT", "LIF", "TEAM", "OOT", "ATX", "FREC", "EDU", "CNN", "GSC", "DGX", "IIC", "SKB", "JOINT", "GRN", "BMH", "LOKI", "SGN", "FND", "DTRC", "CLN", "HER", "RAISE", "CLO", "UBT", "PAT", "LBA", "OPEN", "MRPH", "SNTR", "XYO", "CPT", "RED", "DGTX", "GIN", "FACE", "AVA", "IOTX", "NKN", "NAVI", "ZIP", "SOUL", "REPO", "SEELE", "IVY", "EDR", "BBO", "0xBTC", "PI", "QKC", "BNK", "ETZ", "OMX", "FTO", "ABYSS", "TM2", "EGCC", "CBC", "CEEK", "SAL", "COU", "XMX", "GO", "SSP", "HOLD", "TRTT", "UPP", "BWT", "DAG", "MVP", "FGC", "UCT", "ETK", "MET", "AOA", "ALX", "TERN", "ORS", "RTE", "ZCN", "ZINC", "FSBT", "EGT", "BOB", "KNDC", "CARD", "WWB", "ONL", "OTB", "CONI", "MFT", "GOT", "THRT", "PAI", "FTI", "PCH", "SEER", "ESS", "KBC", "HSC", "LIKE", "YUP", "TENT", "DTX", "BKBT", "MOC", "NIM", "BZ", "DWS", "ZXC", "OLT", "ATMI", "XMCT", "FNKOS", "PSM", "SUSD", "TGAME", "IQ", "NOBS", "BMX", "KAN", "VITE", "GARD", "CET", "RPL", "ELY", "BOX", "PTT", "SOP", "KRL", "LEMO", "BWX", "WYS", "COSM", "NRVE", "OLE", "TRTL", "TOTO", "RLX", "VIEW", "VIKKY", "FOXT", "BRDG", "GVE", "LCS", "ZPR", "RYO", "ACED", "LFC", "WAB", "CSM", "MVL", "NCP", "DACC", "TOS", "PGN", "EURS", "EXMR", "NIX", "APL", "HORUS", "BIFI", "VEX", "HDAC", "KWH", "MCT", "ACDC", "NBR", "VIVID", "CEN", "BITX", "VTHO", "PRIV", "RMESH", "BBK", "NCC", "KLKS", "BHP", "ZMN", "SEM", "ARO", "IOV", "WEB", "ZEL", "CZR", "XUN", "DTEM", "GOC", "YOU", "DACS", "EBC", "TCH", "YCC", "PC", "VITAE", "ROCK2", "BCV", "XTRD", "BTCN", "LXT", "EUNO", "EST", "EXT", "EDS", "VET", "KIND", "X8X", "CMM", "ECOM", "VIN", "LINA", "INO", "KNT", "CROAT", "WIKI", "SPN", "NUG", "BBS", "SCR", "NBC", "NPXSXEM", "XOV", "LYNX", "OPTI", "GIC", "NEWOS", "XPAT", "MXM", "INB", "GIO", "SDS", "OWN", "IG", "GSE", "XDNA", "XPX", "NYEX", "TIC", "EGEM", "AREPA", "CEDEX", "MEETONE", "KARMA", "NOKU", "DX", "UBEX", "PASS", "BAAS", "THR", "CYFM", "HYC", "METM", "AKA", "OBTC", "TKT", "DAC", "QNT", "ABL", "ZCR", "XAP", "SVD", "YLC", "PMA", "ARION", "XBI", "FTT", "HYB", "HB", "MARO", "SEAL", "ABX", "COMP", "HAND", "HIT", "GPKR", "ZP", "ECT", "MFTU", "RATING", "CTC", "KNOW", "KXC", "NSD", "LOBS", "VDG", "YUKI", "KWATT", "MIB", "GTM", "DELTA", "NRG", "FTXT", "DAV", "BNC", "DOW", "QBIT", "BTN", "TAC", "VULC", "BQT", "STR", "UT", "AT", "FKX", "BEET", "IMT", "FLOT", "ALI", "USE", "SHE", "BLACK", "MRI", "CYMT", "BTR", "GZE", "BUT", "UC", "AMO", "EVN", "DIN", "DIT", "HAVY", "CARE", "IMP", "SNO", "VSC", "PENG", "RTH", "RET", "TV", "BIR", "MEX", "AAA", "BEN", "BTAD", "BU", "MIN", "IHF", "UCN", "MOLK", "EDN", "GUSD", "SPND", "CSTL", "CFL", "IOG", "AOG", "CTRT", "TCN", "PYN", "PLURA", "ROX", "SIX", "CMIT", "DFS", "PAX", "WIZ", "GOSS", "XCASH", "SHARD", "IQN", "QCH", "PAXEX", "MLC", "ANON", "ECOREAL", "DAPS", "CARAT", "MNP", "GPYX", "ZB", "MAS", "TRXC", "TMTG", "DAGT", "HSN", "ERT", "MINTME", "AUX", "WXC", "PLC", "VSF", "SINS", "CRD", "KUE", "MIR", "BETHER", "RAGNA", "XGS", "WBL", "CIV", "BENZ", "ACM", "BLAST", "FREE", "TOL", "QUAN", "MASH", "STEEP", "NRP", "SCRIV", "X12", "IFOOD", "EGX", "WIX", "BC", "RSTR", "USDC", "SIM", "NDX", "ZEUS", "BCZERO", "WAGE", "F1C", "META", "QAC", "KKC", "SHPING", "S", "QNO", "AGLT", "ICNQ", "RPD", "ENTS", "SNET", "ABBC", "DEAL", "WIRE", "DIVI", "XIND", "KUN", "ZNT", "ATH", "CDC", "MMO", "BLOC", "ETHO", "DATP", "DEEX", "PLUS1", "IRD", "ZT", "HELP", "RPI", "CHEESE", "ALT", "ISR", "SQR", "FBN", "TDP", "DT", "JSE", "YEED", "ITL", "ASA", "MODX", "SHMN", "PNY", "TELOS", "WTN", "GZRO", "ESCE", "VLU", "EZW", "VLD", "BZX", "LQD", "CGEN", "HNDC", "TYPE", "IONC", "MBC", "VOCO", "APC", "FTM", "SIN", "DEX", "D4RK", "BRZE", "SND", "CYL", "PNK", "MEDIBIT", "POSS", "TTV", "WET", "BGG", "ETHM", "PTN", "XNV", "INVE", "OSA", "ETI", "HUM", "BSV", "SHB", "VITES", "VEST", "UDOO", "CWV", "MICRO", "NOR", "BCAC", "DASHG", "HQT", "BCDT", "ILC", "BEAT", "ATP", "BTNT", "BIND", "NZL", "EQUAD", "RBTC", "BLTG", "MXC", "FOAM", "OPCT", "PLAT", "KAT", "CRO", "LML", "AERGO", "SKCH", "PXG", "LPT", "TIOX", "TENA", "TVNT", "SHVR", "HERB", "CNUS", "NPLC", "COVA", "ZUM", "BRC", "FIII", "BECN", "LAMB", "FTN", "QUIN", "SHX", "HEDG", "XFC", "AGVC", "IMPL", "ULT", "AWC", "PRX", "WCO", "ROM", "DOGEC", "BTMX", "ROCO", "RNO", "CENT", "XTA", "AENS", "B2G", "BTCL", "CVNT", "MOX", "BUL", "KT", "TOK", "INX", "HYN", "XSM", "OBSR", "RIF", "BEAM", "ADM", "VSYS", "TOSC", "EXO", "GRIN", "PLA", "CLB", "LTO", "CAJ", "VEO", "WBTC", "BTT", "USDS", "HPT", "TEMCO", "SOLVE", "FLC", "HALO", "WLO", "TCAT", "CCX", "S4F", "ELAMA", "VGW", "BTU", "DCTO", "CONST", "ECTE", "BNANA", "QUSD", "WEBN", "ELD", "AUNIT", "HXRO", "XPC", "LABX", "UPX", "PLTC", "EVY", "MNC", "MHC", "GMB", "MPG", "JNB", "SWC", "1SG", "OWC", "SET", "FAT", "1X2", "PIB", "HBX", "CCN", "ETX", "FET", "GFUN", "SPT", "EVOS", "COT", "SPRKL", "ONOT", "ANKR", "OVC", "AIDUS", "LUNES", "INNBCL", "NET", "BOLTT", "RC20", "JWL", "ARAW", "GALI", "ATOM", "ZEON", "MESG", "XBX", "XUEZ", "SAFE", "FEX", "BORA", "NAVY", "LTK", "DOS", "ETGP", "INE", "FXC", "PTON", "CELR", "XBASE", "VRA", "GPT", "BHIG", "XQR", "TFUEL", "OLXA", "VANTA", "PUB", "TOP", "JCT", "NEX", "VEIL", "SHA", "BBGC", "HYPX", "DXG", "ORBS", "MFC", "HLT", "XRC", "FST", "CSP", "BOLT", "XTX", "VIDT", "VBK", "OBX", "WHEN", "OTO", "HUDDL", "MTV", "FUND", "SFCP", "FNB", "PTI", "INF", "UGAS", "UTS", "BZKY", "CON", "NASH", "SIGN", "A", "LIT", "NEW", "BIA", "BOTX", "IRIS", "VALOR", "ENTRC", "WEBD", "XWP", "ESBC", "OCE", "STASH", "ARQ", "QCX", "FX", "WPP", "ICT", "BCEO", "NAT", "MATIC", "VOLLAR", "NOW", "CSPN", "MAC", "HYT", "OKB", "AXE", "KUBO", "XMV", "REEC", "BITC", "PEOS", "OCEAN", "WGP", "TTN", "MERI", "THX", "SNTVT", "DOGET", "DPT", "VJC", "DREP", "TRAT", "XLMG", "ATLS", "IDEX", "BQTX", "TT", "ELET", "XCON", "SWIFT", "CNNS", "SRK", "GNY", "NNB", "MZK", "TRP", "P2PX", "FAB", "QWC", "HNB", "TERA", "AFIN", "NTR", "ARRR", "EVED", "ODEX", "BOMB", "LEO", "NEAL", "BZE", "VDX", "DREAM", "RSR", "TOC", "BHD", "EUM", "TRY", "AYA", "BTC2", "SNL", "CHR", "TCASH", "LBN", "OGO", "BDX", "VNT", "WFX", "COTI", "EMT", "SMARTUP", "BST", "GIG", "CCC", "MPAY", "ZNN", "STPT", "B91", "BCZ", "SPRK", "BQQQ", "MINX", "XSPC", "MCPC", "EOSDT", "KTS", "USDQ", "BTCB", "RAVEN", "DAPP", "DVT", "MOTA", "ALGO", "NUT", "JAR", "HNST", "COS", "MBL", "ARPA", "MX", "CATT", "NBOT", "MGC", "BXK", "PAR", "QDAO", "IGG", "AMPL", "ADN", "FO", "TRV", "7E", "USDK", "CHZ", "CIX100", "BURN", "GEX", "UBN", "SPIN", "SCP", "XCHF", "ETHPLO", "MAPR", "SERO", "SLV", "THAR", "PDATA", "BLINK", "WXT", "PXL", "DUSK", "URAC", "SPIKE", "ESH", "X42", "QBX", "TMN", "FLETA", "FUZE", "XCM", "ETM", "NPC", "GOLD", "PVT", "TKP", "FOR", "VD", "PROM", "SAPP", "CCA", "EOST", "NOIZ", "EXOR", "BOOM", "YTA", "AKRO", "VLS", "WNL", "BRZ", "BTCF", "CBIX", "TFB", "CVCC", "AD", "IMG", "RUNE", "BTCT", "YEC", "STO", "CREDIT", "RIO", "LEVL", "BTRL", "SKYM", "DAPPT", "CPU", "DDK", "GMAT", "SFX", "BGBP", "VOL", "CCH", "UOS", "MTCN", "NOIA", "DYNMT", "LNX", "PLG", "SHR", "SWACE", "PCX", "OPNN", "XENO", "WIN", "BIRD", "MB8", "XEQ", "1UP", "AGRO", "EM", "BOA", "XAC", "1MT", "MCASH", "CREX", "FRM", "YO", "LHT", "MBN", "EVT", "BPRO", "CUST", "CTT", "UVU", "ENQ", "BLN", "SON", "ZUC", "DEEP", "XLMX", "CBM", "HINT", "CRAD", "KLAY", "BTRS", "SPICE", "ACU", "UAT", "BCNA", "RITO", "NYE", "GT", "TAN", "KICKS", "COCOS", "DEFI", "DTEP", "SXP", "TSHP", "BHT", "BF", "DAB", "LOT", "ZNZ", "JOB", "IOEX", "LOL", "KGC", "NBXC", "PERL", "LAD", "NBX", "RPZX", "TOKO", "VID", "TUDA", "BSOV", "CRON", "VDL", "JMC", "BTCX", "IMGC", "AER", "BEST", "STREAM", "MIX", "YCE", "CLC", "DIC", "PEPS", "KBOT", "TUP", "XDAG", "BDCC", "XSC", "VNXLU", "VIDY", "VXV", "ETNX", "MTXLT", "BDP", "PIRATE", "ECO", "EGG", "MB", "XNB", "CRN", "SCSX", "KSH", "EMRX", "FLS", "AMIO", "NSS", "VENA", "XCT", "ABET", "MIDAS", "VOLTZ", "MAR", "LN", "ABST", "DVP", "DVS", "BLUR", "BITTO", "SBE", "NEEO", "LYRA", "CITY", "ZOC", "USDX", "XDB", "OATH", "LMY", "PROB", "SWYFTT", "CPR", "SVR", "NINJA", "AKN", "CYBR", "GOM", "SIERRA", "HBAR", "QQQ", "BXY", "NEWS", "TLOS", "WEC", "NODE", "MEXC", "TEP", "GDC", "BAND", "FYD", "CLR", "RALLY", "BUSD", "SOVE", "ZANO", "GXT", "GAP", "EC", "ACC", "RVX", "CHT", "IDRT", "BXC", "BAN", "PAXG", "NEXXO", "CIPX", "XLAB", "AMON", "BCS", "TKX", "IUT", "QTCON", "VLX", "EON", "BIUT", "VERS", "CUT", "ILK", "XRT", "DF", "XPN", "NU", "KAASO", "EOSC", "QPY", "1GOLD", "BNY", "AZ", "EBK", "HUSD", "TN", "DRAGON", "BFX", "MDTK", "BTCV", "VOTE", "DILI", "SPAZ", "MOGX", "ROOBEE", "VNDC", "TSR", "CTK", "BCNT", "WIKEN", "FN", "XSR", "DMME", "ALP", "KAPP", "SYM", "VERA", "EtLyteT", "GLS", "NOVA", "DSC", "SUTER", "FLG", "MCH", "KAVA", "LINKA", "BXT", "ES", "DAD", "SCH", "GRIMM", "BTZC", "LKU", "MES", "SOZ", "BNP", "KYDC", "GDR", "IRA", "RAE", "NWC", "MLGC", "RINGX", "HX", "YAP", "ANCT", "INFS", "CDL", "SBT", "BITN", "MODEX", "DEXA", "BNKR", "AET", "GRG", "MDM", "JDC", "XBG", "MZG", "KUV", "BPX", "DAI", "TRB", "VINCI", "CKB", "999", "LCX", "ZYN", "CXC", "MAP", "BIP", "PCM", "ERK", "JUL", "OURO", "NIRX", "EXM", "NST", "WOW", "PEG", "SEED", "DMTC", "MACH", "ARDX", "HGH", "PHT", "TDPS", "HCA", "ULG", "XIO", "DAVP", "GC", "SCAP", "ARX", "TROY", "ARTIS", "SGR", "ALY", "HSS", "CDB", "HEX", "INNBC", "CALL", "ALLBI", "JADE", "OXT", "ROAD", "MWC", "KSM", "CASH", "STS", "QURA", "STM", "LTB", "VRSC", "BAZT", "BFC", "ANK", "CCT", "BULL", "HLX", "USDA", "XNC", "BEPRO", "AXL", "USDN", "FLT", "XTP", "RKN", "UBU", "EGR", "GLOB", "BYND", "THE", "APM", "CUR", "PLF", "BCB", "UPI", "CBUCKS", "GUAP", "GGC", "VMR", "LVX", "onLEXpa", "HANA", "NZO", "IPX", "1AI", "KAM", "FRED", "SURE", "CNB", "KRT", "OGN", "EUSD", "MCM", "HTDF", "TUSC", "AfroX", "RES", "DMS", "PMEER", "BKK", "NYZO", "HP", "BEAR", "WEST", "DUN", "WRX", "EDI", "PYRO", "IFX24", "KYF", "XAUT", "DFN", "WDC", "CLX", "BFF", "EMS", "KOK", "XT", "JRT", "AK12", "FLEX", "UNOC", "MTT", "GLEEC", "PMGT", "R2R", "WPX", "MALW", "ETHBEAR", "ETHBULL", "XQC", "HNS", "JUV", "BAR", "PSG", "ATM", "GAL", "ASR", "WLF", "WCC", "KEMA", "KTC", "LFEC", "GRT", "VX", "ZFL", "HEBE", "LAR", "HUSL", "LBK", "APIX", "EMRALS", "HUB", "CDAI", "CSAI", "CUSDC", "MLK", "QBZ", "EWT", "FCH", "OKS", "PCI", "ASAC", "SNB", "JOYS", "SOLO", "BLCT", "KMW", "KIM", "BDK", "LUCY", "imBTC", "BNBBEAR", "BNBBULL", "SSN", "HDAO", "INEX", "MOR", "BTSE", "OG", "TILY", "SPOK", "CTCN", "ZCH", "SIMPLE", "BONO", "GCX", "EER", "BIKI", "ORC", "WOM", "LRG", "ZLS", "RAKU", "HMR", "iOWN", "RAS", "FSC", "BOO", "WADS", "XPR", "PEAK", "IBS", "XLPG", "XPT", "XMD", "HTA", "GTX", "HIVE", "IZER", "HBD", "CNRG", "TRXBULL", "TRXBEAR", "HUNT", "PGO", "B1P", "ALA", "CELC", "ISLA", "WLB", "HETM", "SCOP", "TST", "WFC", "TLW", "CHG", "CLT", "MYTV", "BTCR", "CICX", "KDG", "FOUR", "PRQ", "XRPBULL", "XRPBEAR", "EOSBULL", "EOSBEAR", "INRT", "LMCH", "WOK", "PGOLD", "HNT", "DSLA", "SWZL", "SEFA", "SOL", "CHND", "VI", "DEP", "SATX", "SNG", "MLR", "PBTC", "EPIC", "BIZZ", "ETF", "CTSI", "USDJ", "HLIX", "METP", "BEER", "WBX", "KAI", "TREX", "FF1", "BSVBEAR", "BSVBULL", "LTCBEAR", "LTCBULL", "XTZBEAR", "XTZBULL", "BCHBEAR", "BCHBULL", "ISIKC", "AMA", "GHOST", "CRDT", "XXA", "ECOC", "ECU", "UCA", "BALI", "BASIC", "CCXX", "BKRW", "JACK", "JST", "SGC", "LBXC", "GBPX", "NZDX", "AUDX", "EURX", "AAB", "AC", "BID", "CHFT", "TTT", "LOA", "TOR", "MARTK", "EZY", "SENSO", "ANJ", "XEN", "ASY", "KEYT", "SKC", "IBVOL", "BCR", "AG8", "GLDY", "VRO", "CHI", "BVOL", "NFXC", "MASS", "TGIC", "HTR", "VANY", "UPT", "ICH", "MRL", "TARM", "KEEP", "CELO", "HOMI", "BOC", "LSV", "LEVELG", "IDK", "HAI", "EGAS", "2KEY", "DXD", "PYRK", "ZCRT", "BKY", "XTRM", "ATT", "STAKE", "SCRT", "SSS", "BTCUP", "BTCDOWN", "ZASH", "AZBI", "SSX", "ZLW", "MNT", "MATH", "UMA", "DAWN", "VAIP", "EXE", "DMCH", "SKI", "LYXe", "KDAG", "SAC1", "VARC", "NDN", "WGRT", "ORN", "AR", "UCM", "PAZZI", "PXP", "BPC", "T69", "MERCI", "KDA", "BNOX", "CBET", "DCH", "HEDGE", "ETHHEDGE", "XANK", "POWER", "SYLO", "ZPAE", "CODEO", "BGL", "ETNXP", "BLOOD", "EYES", "PHNX", "IZE", "PLAAS", "BKS", "GHT", "RNDR", "SKL", "UNIUSD", "QTV", "DDRT", "GM", "MNS", "NMP", "BUIDL", "AWG", "FNX", "RVC", "BTC++", "CGT", "SORA", "HOMT", "BAL", "ROS", "BTCHG", "IOOX", "MoCo", "BTC3L", "BTC3S", "ETH3S", "ETH3L", "DMG", "CBAT", "CZRX", "CWBTC", "CUSDT", "CREP", "MUSD", "MTA", "SETH", "SBCH", "SADA", "IADA", "TBTC", "RENBTC", "ETHP", "YSR", "PAMP", "CBP", "BSY", "STP", "LYFE", "MHLX", "SAVE", "DXTS", "BNA", "KUB", "DRS", "HDI", "RING", "TRCL", "NOKN", "XOR", "BCHC", "DFI", "AVAX", "REL", "DESH", "CAP", "BZRX", "ENTONE", "RM", "BPS", "REW", "OMC", "GST", "ALEPH", "SUM", "SLP", "ETHBN", "VN", "SWAP", "NXM", "PIZZA", "CHL", "ASKO", "PLT", "DEC", "IDNA", "GOM2", "NEST", "PUML", "STONK", "CIPHC", "XGM", "BPT", "CSO", "LVN", "BLVR", "FMA", "QARK", "IDEFI", "SCEX", "SDEFI", "SXAG", "YFI", "FIO", "DEXT", "KVNT", "STA", "STAMP", "FNT", "NAX", "FLUX", "RARI", "VBZRX", "PROPS", "BLX", "FIS", "ECOS", "RWN", "NBTC", "SGT", "COL", "ANY", "FRONT", "DYT", "PSK", "IDX", "DDR", "UFC", "DVC", "CLOUT", "NVT", "3Cs", "DKA", "FESS", "4ART", "INTX", "BONE", "SVC", "AIM", "MTRG", "AICO", "CBR", "SWINGBY", "CUB", "PAN", "ZOOM", "BMT", "KTON", "FIRE", "HYBN", "RWS", "ZOM", "TEM", "TPT", "UNC", "UHP", "DSD", "DMST", "FME", "MCB", "YFII", "MOV", "PUSD", "CNS", "TWT", "PWRB", "TRND", "TEND", "TRUST", "VSN", "LIMEX", "LID", "SST", "BNS", "L2P", "SHIB", "KASH", "LIBERTAS", "XAMP", "FOCV", "BWB", "CVA", "AOS", "BRR", "PUX", "DGMT", "ME", "TOPB", "MDU", "KVI", "NILU", "LINKBULL", "CNTM", "ADABEAR", "YDAI+YUSDC+YUSDT+YTUSD", "888", "MNR", "HUP", "ASM", "EIDOS", "ALGOBULL", "GIV", "ALTBULL", "BTMXBULL", "ADABULL", "ATOMBULL", "DOGEBULL", "DRGNBULL", "ETCBULL", "HTBULL", "MATICBULL", "MIDBULL", "OKBBULL", "BULLSHIT", "TOMOBULL", "ALGOBEAR", "LINKBEAR", "ATOMBEAR", "DOGEBEAR", "ETCBEAR", "MATICBEAR", "TOMOBEAR", "DVX", "HAPY", "AIC", "EHRT", "ETO", "KYSC", "ECOIN", "LPS", "BPLC", "BONK", "BITO", "ANW", "BYTE", "CHADLINK", "ETH20SMACO", "ETHMACOAPY", "ZYX", "GOLDX", "ETHEMAAPY", "ELL", "DIA", "ETHBTCRSI", "LINKETHPA", "ETHPA", "FSXA", "ETHRSI6040", "ETHRSIAPY", "YFFI", "FLEXETHBTC", "INTRATIO", "DONUT", "LINKETHRSI", "LINKPT", "JUI", "KFX", "MSV", "MODIC", "SNN", "SUKU", "ABTC", "SRM", "sTRX", "sLINK", "SXAU", "SXTZ", "CREAM", "GEEQ", "TRADE", "ROZ", "ILINK", "SXRP", "SBNB", "SAND", "DION", "HZT", "MACPO", "AXEL", "BAK", "ARCONA", "BG", "BTY", "BXA", "XFT", "TMED", "XAUTBULL", "XAUTBEAR", "PIE", "SG", "YAS", "YFT", "ZIK", "WSC", "AKM", "TORM", "SHENG", "HL", "HY", "JT", "EVO", "BLY", "POL", "EVAN", "DDAM", "GARK", "LKN", "IX", "TUNE", "BOT", "SDT", "ASTA", "AVC", "BPOP", "BRZX", "BSYS", "BTSC", "BYTS", "YT", "CNZ", "AGA", "MINI", "sBTC", "YFL", "ETHV", "FLL", "CSPC", "DTOP", "DZAR", "DWC", "DOGZ", "DRGB", "ESWA", "DSYS", "EA", "EVZ", "ESK", "FBT", "FX1", "FSHN", "FFF", "FNK", "GTF", "HMB", "HTN", "SRC", "HEM", "Lburst", "PERX", "HIBS", "USDH", "IT", "RICK", "INXC", "FXP", "GPO", "IQC", "JUS", "KAL", "KIP", "ITAM", "LVH", "PORTAL", "TFT", "BREE", "RMPL", "HALV", "KLP", "TERC", "STRONG", "ALD", "MCX", "NDAU", "UENC", "MGP", "LUD", "NAN", "RNX", "MANDI", "NEAR", "OM", "RFUEL", "CRV", "YAM", "HBDC", "BRTR", "TW", "FRENS", "WAIF", "PARTY", "XAG", "ORBYT", "VIG", "SPORTS", "TBT", "LOCK", "OWL", "$BASED", "EQMT", "TACO", "TRUMPLOSE", "TRUMPWIN", "ZZZ", "MXX", "WING", "CGC", "BNTX", "DIP", "SVB", "BART", "GEAR", "MYX", "ANG", "ALG", "XFUEL", "UCX", "TOB", "SCHA", "COM", "DCNTR", "DDIM", "FERA", "FTB", "LOVE", "GRAPH", "KEN", "HAKKA", "DOGEFI", "GOLDR", "IBP", "SPIZ", "MTR", "eMTRG", "CHOP", "DOT", "LAYER", "CAMO", "COIL", "REB2", "USDF", "CPI", "KSS", "YAMV2", "DACC2", "LOOP", "TIDE", "DZI", "LGCY", "YMPL", "XIOT", "CVP", "AXIS", "DFIO", "FYZ", "MIKS", "ORBI", "BICAS", "WHALE", "DIGEX", "POX", "GTHR", "DEXG", "NEWTON", "DGVC", "LTCP", "OCP", "SLINK", "THS", "TIIM", "YBREE", "LIB", "BUY", "CATX", "JBX", "LIEN", "YFIE", "VIDYA", "MAZ", "LIBFX", "SPA", "GRO", "DETS", "BLZN", "KLV", "YUSRA", "RSV", "WENB", "TON", "DON", "SYBC", "XLT", "PDF", "LORI", "STEEL", "FSW", "CHAIN", "CEDS", "CRU", "SUSHI", "ESTI", "EFK", "NTON", "ESRC", "STOP", "CVR", "MPT", "YEP", "MIXS", "AXS", "DOTX", "SWFL", "TRIX", "ATTN", "VESTA", "YFIS", "HOUSE", "MCI", "FACT", "YFIVE", "CORN", "BAST", "DISTX", "SEMI", "EPS", "SOFI", "PEARL", "KIMCHI", "PHA", "WTF", "GSMT", "ADEL", "BIDR", "NOODLE", "FARM", "CHART", "BOOST", "YFFS", "CRP", "TAI", "SHARE", "OCB", "OIN", "CRT", "YFIB", "DUSD", "EXNT", "KIF", "OBEE", "YFBETA", "UCO", "OPM", "LIVE", "SHROOM", "EGLD", "ASTRO", "JFI", "SWRV", "YIELD", "UNT", "EURU", "USDU", "YFA", "BNSD", "YI12", "YFUEL", "JCC", "YFP", "FRMS", "FORS", "DFX", "COIN", "FSP", "BEL", "HEGIC", "KEX", "TCP", "NCDT", "FFYI", "YF-DAI", "gKIMCHI", "LEAD", "HBTC", "JGN", "BGTT", "MM", "AMP", "VBIT", "HGET", "PERP", "ENCX", "BUILD", "ALBT", "ACH", "YFIKING", "HBC", "I9C", "MAFI", "MAKI", "OAP", "PRDX", "YFI2", "YELD", "YFFII", "FDR", "CLA", "FHSE", "NYB", "OBIC", "DOOS", "FIT", "NUTS", "YKZ", "ZDEX", "SUN", "SASHIMI", "SPARTA", "REVV", "EOSDOWN", "XRPUP", "XRPDOWN", "DOTUP", "TRXDOWN", "TRXUP", "DOTDOWN", "XTZUP", "XTZDOWN", "BNBUP", "BNBDOWN", "LINKUP", "LINKDOWN", "ADAUP", "ADADOWN", "ETHDOWN", "ETHUP", "CREED", "NYAN", "ON", "PICKLE", "TXL", "VYBE", "YFFC", "BEC", "CHADS", "ESD", "GOF", "JIAOZI", "LNT", "XFI", "YMEN", "UBXT", "GTH", "XMM", "PFID", "ZYRO", "YFKA", "GHST", "TRBT", "ETHPY", "ATIS", "BXIOT", "DPI", "MELE", "TONS", "YFARMER", "BAKE", "FAME", "P2P", "VNS", "YFARM", "GALA", "MYFI", "SUSHIBULL", "SUSHIBEAR", "DEGO", "PRINT", "XSTAR", "WALT", "XETH", "YFMS", "DHT", "SOCKS", "BRG", "DGN", "TFD", "HTRE", "ASK", "RSP", "HATCH", "NBS", "XSP", "PoSH", "MKCY", "ACPT", "LNOT", "PVG", "RI", "SAM", "UNIFI", "YMAX", "GHD", "VELO", "UST", "DUCATO", "FNSP", "KSEED", "ONES", "SODA", "yTSLA", "AXI", "YFIII", "YFF", "DSS", "IYF", "ISDT", "FLM", "TOAST", "ITEN", "BASID", "BURGER", "DCD", "GMC", "JUICE", "ROT", "UTY", "YFIX", "xBTC", "KFC", "TRIB", "DFF", "MANY", "$ROPE", "TCFX", "BWF", "COMB", "CYF", "HIPPO", "BHC", "CAKE", "SFG", "OUSD", "PTF", "SWSH", "WBNB", "YFIIG", "SPKL", "UCR", "OCTO", "PURE", "SFR", "TITAN", "UNII", "POLS", "EMN", "BUCC", "ECELL", "CACXT", "C2O", "CXN", "LUA", "MPH", "RBC", "VAMP", "WLEO", "YAX", "DODO", "FIN", "INJ", "APY", "NSURE", "ALPHA", "YLAND", "TMC", "CUSD", "YFBT", "TKNT", "AHF", "CORE", "QHC", "SATT", "STBU", "TMT", "IPM", "YFPI", "YFE", "WAR", "YNK", "METRIC", "AITRA", "MTLX", "APE", "KOMP", "PJM", "SFD", "YFIEC", "BDCASH", "AAVE", "DOUGH", "YFOX", "XVS", "YFMB", "YFET", "YF4", "KCAL", "RAUX", "AWX", "ZAC", "SMOL", "CYTR", "BLV", "NOVO", "DEFI+S", "PGT", "YEA", "ZUT", "YFOS", "NSBT", "YOUC", "STPL", "XFYI", "DARK", "DEXE", "LYNC", "YFPRO", "EASY", "DFIP", "CFX", "FUD", "INDEX", "DEFI+L", "WOA", "YFSI", "ALMX", "HAUT", "KAU", "QOOB", "CNTR", "FRIES", "JVZ", "THIRM", "YLAB", "YFED", "EFAR", "STBZ", "PIPT", "NMT", "HOLY", "BTTR", "SUP", "DOKI", "LIMIT", "DRC", "BRI", "DANDY", "CRAFT", "MILK2", "NFY", "SHAKE", "ATRI", "TAVITT", "GMNG", "YEFIM", "LOAD", "VALUE", "AFU", "MOONS", "PSHP", "SSL", "THUGS", "YFDOT", "UFT", "AZZR", "EYE", "BNZ", "BTCDOM", "PLOT", "RUC", "HEZ", "PAYT", "SWAG", "ZEFU", "AKT", "BNF", "MBX", "ZEE", "GLF", "BOND", "YRISE", "YFIA", "DXIOT", "UNICORE", "GNC", "LCG", "DDRST", "ETGF", "AUDIO", "PAYOU", "AQT", "UTED", "RAMP", "VOX", "PRIA", "SWG", "AFC", "CHARGED", "WVG0", "WG0", "AXIA", "CAMP", "YFN", "BOOB", "TENS", "MOONDAY", "MCN", "DFGL", "FWB", "RGT", "CHONK", "XAT", "yBAN", "WINR", "SPORE", "WOO", "STAX", "BHAO", "WON", "NVA", "BOR", "QRX", "DOGDEFI", "UNISTAKE", "BTNYX", "IDALL", "UBIN", "NAZ", "YFICG", "NBT", "SYN", "BCHUP", "BCHDOWN", "UNIUP", "UNIDOWN", "LTCUP", "LTCDOWN", "SXPUP", "SXPDOWN", "YFRM", "LMS", "PXUSD_MAR2021", "ORAI", "NAMI", "KP3R", "ASP", "TAT", "CLBR", "MEGA", "HD", "BLOODY", "HOO", "TLB", "JNTR", "WLT", "SURF", "WEMIX", "PFARM", "YYFI", "HYVE", "ERSDL", "HIZ", "GBCR", "TAD", "FMTA", "xDOT", "PTERIA", "YEET", "stFIRO", "YODA", "SMPL", "$KING", "BLURT", "ROCKS", "YSEC", "STACY", "N0031", "HARD", "LEX", "MARS", "FROG", "GBK", "KP4R", "AUSCM", "FWT", "EARN", "UTU", "GSWAP", "CHM", "DVI", "MSB", "DFD", "SERGS", "SMARTCREDIT", "NEBO", "TSLA", "WCCX", "ZHEGIC", "ZLOT", "OLCF", "FLA", "ZLP", "YFB2", "YFIM", "TEAT", "MTI", "LTX", "SFI", "ALPA", "TWI", "VRGX", "UBX", "GIX", "GASP", "7UP", "PICA", "CORAL", "ETLT", "FRMX", "RAK", "WHOLE", "LOV", "UNW", "TH", "TRA", "CAI", "FCD", "MVEDA", "BFI", "NYAN-2", "VKF", "$NOOB", "AZUKI", "XFII", "RUGZ", "LIQUID", "DRUGS", "ROSE", "RFOX", "CCE", "MEE", "BAEPAY", "GGT", "PTE", "GYSR", "SVN", "UNCX", "LONG", "UNCL", "BST1", "SEEN", "UNFI", "AGOV", "VOLTS", "ibETH", "AXN", "REAP", "ROOK", "SAV3", "ORO", "BCHA", "FOL", "YFD", "EXRD", "GDAO", "KNV", "PBS", "WIS", "CORX", "CFi", "SUP8EME", "CP3R", "YUI", "FR", "OBR", "SWISS", "ENB", "TCR", "DEFO", "JEM", "XIF", "TRU", "UWL", "COVER", "BMP", "LCT", "API3", "KIT", "UNOS", "ETHY", "FLX", "RFI", "EPAN", "ARCH", "KP2R", "LIBREF", "BKKG", "HANDY", "EAURIC", "LK3R", "KOMET", "BUP", "LYR", "BDT", "MARK", "DEVE", "WZEC", "OVOA", "SANC", "7ADD", "L2", "PROPHET", "AAVEUP", "AAVEDOWN", "VNLA", "TBP", "MTS", "LELE", "ENOL", "BUND", "CORD", "JSB", "YLFI", "OSB", "LTP", "YFI3", "$COIN", "DG", "ALLWIN", "HRD", "ETHYS", "MUSE", "UMEX", "CRBN", "STV", "BVL", "SYNC", "BAC", "CLIQ", "BAS", "wCRES", "UCAP", "VAI", "ZORA", "KODX", "RAP", "PIS", "DJV", "MTTCOIN", "BASE", "DEGOV", "IDLE", "ACS", "ITS", "ACXT", "PUNT", "BADGER", "CTI", "YFIAG", "DGP", "WDP", "PPAY", "EFG", "RLR", "DEFI++", "VAL", "DEBASE", "MOB", "YFID", "SKLAY", "WOZX", "WELL", "KTLYO", "NIO", "BABA", "AMZN", "PFE", "TSM", "AAPL", "BILI", "ARKK", "FB", "MSTR", "NFLX", "MRNA", "PYPL", "SQ", "AMD", "WAV3", "GVY", "ELYX", "VVT", "NVDA", "GOOGL", "SPY", "TWTR", "UBER", "BONDLY", "ABNB", "A5T", "SUGAR", "FOMP", "YETI", "GRAIN", "BFR", "XCUR", "RBASE", "RANK", "IFEX", "ARVO", "vSXP", "Z502", "vUSDT", "vUSDC", "vBUSD", "vXVS", "vBNB", "vBTC", "vETH", "vLTC", "vXRP", "ACX", "PLUT", "XVIX", "VLO", "YPLT", "DEFLCT", "vBCH", "vLINK", "vDOT", "DUCK", "PLEX", "DEBA", "YFW", "BNFI", "SZC", "YETH", "RLE", "YLD", "LDN", "NDR", "300", "TRI", "BSE", "RENFIL", "PRDZ", "RZN", "mAAPL", "SPDR", "mGOOGL", "mTSLA", "mNFLX", "mBABA", "NFUP", "DJ15", "MEDI", "$PIR", "mAMZN", "mMSFT", "mTWTR", "N3RDz", "DFO", "HLAND", "TTR", "mIAU", "mQQQ", "mSLV", "mUSO", "mVIXY", "LOOT", "GZIL", "GR", "YVS", "TVK", "WSF", "RFCTR", "R34P", "MAHA", "ADP", "EOC", "FILUP", "FILDOWN", "SUSHIUP", "XLMDOWN", "XLMUP", "UNN", "$ANRX"]
    # else
        # portfolio_array = %w[BTC ETH XRP USDT BCH LTC LINK ADA]
    # end
    # p portfolio_assets_quantities_array
    output = []
    portfolio_assets_quantities_array.each do |element|
        symbol = element[0]
        portfolio_array.map do |crypto|
        output << crypto if (crypto == symbol && element[1] > 0.0)
        end
    end
    portfolio_array = output

    portfolio = portfolio_array.join(',')
    api_link = 'https://pro-api.coinmarketcap.com/v1/cryptocurrency/quotes/latest?symbol='
    live_api_link = api_link + portfolio

    # show the portfolio based on the whether the portfolio has been modified. It crypto added since last API call, run API. If not, read cached file.
    if active_user.portfolio_modified
        if !api_key.match(/(...\X-)/) 
            puts "Error: api key does not match"
            return
        end
        print "... loading live data "
        waiting
        response = call_api(live_api_link, api_key) # live call
        clear
        get_crypto(response, portfolio_array, portfolio_assets_quantities_array, active_user)
        active_user.portfolio_modified = false
    else
        api_test_file = './json/api_cached/latest.json'
        clear
        dummy_response = read_json_file(api_test_file) # cached local call
        get_crypto(dummy_response, portfolio_array, portfolio_assets_quantities_array,active_user)
    end



    # handles the I/O of selecting the portfolio file source
    # puts "1. Last Saved Prices\n2. Get Live Prices\n"
    # puts "Portfolio has changed: #{active_user.portfolio_modified}"
    # api_file_selection = gets.strip.chomp.to_i
    # clear
    # case api_file_selection
    # when 1
        # begin
        # instructions = "Please select a cached API test file 1/2/3/4\n\n"
        # # instructions += "NOTE: If portfolio has changed since last cached, run a new live api call.\n".colorize(:green)
        # puts instructions
        # choice = gets.chomp.to_i
        # case choice
        #     when 1
        #     api_test_file = './json/api_cached/temp-1.json'
        #     when 2
        #     api_test_file = './json/api_cached/temp-2.json'
        #     when 3
        #     api_test_file = './json/api_cached/temp-3.json'
        #     when 4
        #     api_test_file = './json/api_cached/temp-4.json'
        #     when 5
            # api_test_file = './json/api_cached/latest.json'
        # else
        #     api_test_file = './json/api_cached/schema.json'
        # end
        # rescue
        #  puts "Please enter a number between 1 and 4"
        # retry
        # end
        # begin
        # clear
        # dummy_response = read_json_file(api_test_file) # cached local call
        # get_crypto(dummy_response, portfolio_array, portfolio_assets_quantities_array,active_user)
        # rescue
        # puts "Your portfolio has changed. Run a fresh API call to get the latest data"
    # end
        
    # when 2
        # begin
        # puts "Enter API key:\n"
        # api_key = gets.strip.chomp
        # puts api_key
    #     if !api_key.match(/(...\X-)/) 
    #         puts "Error: api key does not match"
    #         return
    #     end
    #     print "... loading live data "
    #     waiting
    #     response = call_api(live_api_link, api_key) # live call
    #     clear
    #     get_crypto(response, portfolio_array, portfolio_assets_quantities_array, active_user)
    #     active_user.portfolio_modified = false
    # end

end # end show_portfolio method

# method to read portfolio json
def read_portfolio_json(path_to_portfolio_file,active_user)
    path_to_portfolio_file = "./json/portfolios/#{active_user.username}.json"
    portfolio_json = read_json_file(path_to_portfolio_file)
    # p portfolio_json
    # puts "\n"
    portfolio_array = []
    # portfolio_array << portfolio_json['username']
    # portfolio_json.each do |key, value|
    portfolio_json['data'].each do |key, value|
            symbol = key
            quantity = value['asset_quantity']
            portfolio_array << [symbol, quantity]
    end
        # portfolio_array << portfolio_json['data'][key]['asset_quantity']
    # end
    # p portfolio_array
    # puts "\n"
    return portfolio_array
rescue
end

def get_crypto(response, portfolio_array, portfolio_assets_quantities_array, active_user)
    rows =[]
    grand_total = 0.0
    portfolio_array.each do |crypto|
        name = response['data'][crypto]['name']
        symbol = response['data'][crypto]['symbol']
        price = format('%0.2f', response['data'][crypto]['quote']['USD']['price']).gsub(/(\d)(?=\d{3}+\.)/, '\1,')
        quantity = 0
        portfolio_assets_quantities_array.each do |element|
            if symbol == element[0]
                quantity = element[1]
            end
        end
        grand_total += quantity * response['data'][crypto]['quote']['USD']['price']
        total = format('%0.2f', quantity * response['data'][crypto]['quote']['USD']['price']).gsub(/(\d)(?=\d{3}+\.)/, '\1,')
        rows << [name, symbol, quantity, "$" + price, "$" + total]
    end
    rows << :separator
    grand_total = format('%0.2f', grand_total).gsub(/(\d)(?=\d{3}+\.)/, '\1,')
    rows << ["Grand Total",'','','','$' + grand_total]
    # table = Terminal::Table.new :title => "#{active_user_name}", :headings => ['Name'.colorize(:cyan), 'Symbol'.colorize(:cyan), 'Quantity'.colorize(:cyan), 'Price USD'.colorize(:cyan), 'Total USD'.colorize(:cyan)], :rows => rows

    table = Terminal::Table.new
    table.title = "#{active_user.name}'s Crypto Portfolio".colorize(:blue)
    table.headings = ['Name'.colorize(:blue), 'Symbol'.colorize(:blue), 'Quantity'.colorize(:blue), 'Price USD'.colorize(:blue), 'Total USD'.colorize(:blue)]
    table.rows = rows
    table.style = {:width => 100}
    puts table
    puts "Data supplied by CoinMarketCap.com"
    puts "\nUsername: #{active_user.username}\n" + Time.now.strftime("%Y-%m-%d %H:%M") + "\nYour portfolio has a total of #{portfolio_array.length} digital assets.\n\n"
rescue
    
end