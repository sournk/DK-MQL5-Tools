//+------------------------------------------------------------------+
//|                                                  CASUNInputs.mqh |
//|                                                  Denis Kislitsyn |
//|                                             https://kislitsyn.me |
//+------------------------------------------------------------------+

#include  "Include\DKStdLib\Common\DKStdLib.mqh"

enum ENUM_LOT_TYPE {
  LOT_TYPE_FIXED_LOT       = 0, // Fixed Lot
  LOT_TYPE_DEPOSIT_PERCENT = 1  // % of Deposit
};

enum ENUM_LOT_CORRECTION_MODE {
  LOT_CORRECTION_MODE_NONE             = 0, // None
  LOT_CORRECTION_MODE_VOLATILITY_RATIO = 1  // Volatility Ratio
};

enum ENUM_TRADE_DIR{
  TRADE_DIR_BOTH             = 0,       // Both
  TRADE_DIR_LONG             = +1,      // Long
  TRADE_DIR_SHORT            = -1,      // Short
};

enum ENUM_SIGNAL_MODE{
  SIGNAL_MODE_PRICE          = 0,      // Price comparison
  SIGNAL_MODE_SMA            = 1,      // SMA comparison
};


enum ENUM_EXIT_MODE {
  EXIT_MODE_FIXED_TIME              = 0, // Fixed Time
  EXIT_MODE_KEEP_POS_ON_SAME_SIGNAL = 1  // Keep Position On Same Signal
};


// PARSING AREA OF INPUT STRUCTURE == START == DO NOT REMOVE THIS COMMENT
struct CASUNBotInputs {
  ENUM_LOT_TYPE ENT_LTP;                               // ENT_LTP: Lot Type // LOT_TYPE_DEPOSIT_PERCENT 
  double                   ENT_LTV;                    // ENT_LTV: Lot Type Value // 200.0(x>0)
  ENUM_LOT_CORRECTION_MODE ENT_LC_MOD;                 // ENT_LC_MOD: Lot Correction by Volatility Enabled // LOT_CORRECTION_MODE_VOLATILITY_RATIO
  double ENT_LC_VR_DPT;                                // ENT_LC_VR_DPT: Daily price movement threshold, %    //   (ENT_LC_MOD == LOT_CORRECTION_MODE_VOLATILITY_RATIO && x>0)
  double                   ENT_LC_VR_LTR;              // ENT_LC_VR_LTR: Lot Ratio applied after ever 'ENT_LC_VR_DPT' reached

  string                   EXT_MOD;                    // EXT_MOD: Exit Mode
  string                   EXT_TIM;                    // EXT_TIM: Exit fixed Time

  string                   SIG_TIM;                    // SIG_TIM: Signal Time Interval (or strict time, e.g. "14:30") //(x!=)
  ENUM_TRADE_DIR           SIG_DIR;                    // SIG_DIR: Signal Direction Allowed
  ENUM_SIGNAL_MODE         SIG_MOD;                    // SIG_MOD: Signal Mode
  double                   SIG_TRH_LNG;                // SIG_TRH_LNG: Long direction price Threshold, %
  double                   SIG_TRH_SHT;                // SIG_TRH_SHT: Short direction price Threshold, %

  string                   FIL_DWA_LNG;                // FIL_DWA_LNG: Days of Week allowed for Long
  string                   FIL_DWA_SHT;                // FIL_DWA_SHT: Days of Week allowed for Short
// PARSING AREA OF INPUT STRUCTURE == END == DO NOT REMOVE THIS COMMENT

  string                   LastErrorMessage;               
  bool                     CASUNBotInputs::InitAndCheck();
  bool                     CASUNBotInputs::Init();
  bool                     CASUNBotInputs::CheckBeforeInit();
  bool                     CASUNBotInputs::CheckAfterInit();
};

//+------------------------------------------------------------------+
//| Init struc and Check values
//+------------------------------------------------------------------+
bool CASUNBotInputs::InitAndCheck() {
  LastErrorMessage = "";
  
  if(!CheckBeforeInit()) 
    return false;
  
  if(!Init()) {
    LastErrorMessage = "Input.Init() failed";
    return false;
  }
  
  return CheckAfterInit();  
}

//+------------------------------------------------------------------+
//| Init struc 
//+------------------------------------------------------------------+
bool CASUNBotInputs::Init() {
  IndADRHndl = iCustom(Symbol(), Period(), "AverageDayRange", SIG_ADR_LEN);
  IndVolumeHndl = iVolumes(Symbol(), Period(), Inp_SIG_VOL_APL);
  
  return true;
}

//+------------------------------------------------------------------+
//| Check struc before Init
//+------------------------------------------------------------------+
bool CASUNBotInputs::CheckBeforeInit() {
  LastErrorMessage = "";
  if(SIG_SGM <= 0.0) LastErrorMessage = "'SIG_SGM' must be possitive";
  if(SIG_RBC <= 0)  LastErrorMessage = "'SIG_RBC' must be possitive";
  if(SIG_SDC <= 0)  LastErrorMessage = "'SIG_SDC' must be possitive";    
  if(SIG_SDC <= SIG_RBC)  LastErrorMessage = "'SIG_SDC' must be greater 'SIG_RBC'";    
  if(SIG_ADR_LEN <= 0) LastErrorMessage = "'SIG_ADR_LEN' must be possitive";

  return LastErrorMessage == "";
}

//+------------------------------------------------------------------+
//| Check struc after Init
//+------------------------------------------------------------------+
bool CASUNBotInputs::CheckAfterInit() {
  LastErrorMessage = "";
  if(IndADRHndl <= 0) LastErrorMessage = "Indicators\\ADR custom indicator load error";
  if(IndVolumeHndl <= 0) LastErrorMessage = "Volumes standart indicator load error";

  return LastErrorMessage == "";
}

// GENERATED CODE == START == DO NOT REMOVE THIS COMMENT
// input  ENUM_LOT_TYPE             Inp_ENT_LTP                        = LOT_TYPE_DEPOSIT_PERCENT;             // ENT_LTP: Lot Type
// input  double                    Inp_ENT_LTV                        = 200.0;                                // ENT_LTV: Lot Type Value
// input  ENUM_LOT_CORRECTION_MODE  Inp_ENT_LC_MOD                     = LOT_CORRECTION_MODE_VOLATILITY_RATIO; // ENT_LC_MOD: Lot Correction by Volatility Enabled
// input  double                    Inp_ENT_LC_VR_DPT                  = 0;                                    // ENT_LC_VR_DPT: Daily price movement threshold, %
// input  double                    Inp_ENT_LC_VR_LTR                  = 0;                                    // ENT_LC_VR_LTR: Lot Ratio applied after ever 'ENT_LC_VR_DPT' reached
// input  string                    Inp_EXT_MOD                        = 0;                                    // EXT_MOD: Exit Mode
// input  string                    Inp_EXT_TIM                        = 0;                                    // EXT_TIM: Exit fixed Time
// input  string                    Inp_SIG_TIM                        = 0;                                    // SIG_TIM: Signal Time Interval (or strict time, e.g. "14:30")
// input  ENUM_TRADE_DIR            Inp_SIG_DIR                        = 0;                                    // SIG_DIR: Signal Direction Allowed
// input  ENUM_SIGNAL_MODE          Inp_SIG_MOD                        = 0;                                    // SIG_MOD: Signal Mode
// input  double                    Inp_SIG_TRH_LNG                    = 0;                                    // SIG_TRH_LNG: Long direction price Threshold, %
// input  double                    Inp_SIG_TRH_SHT                    = 0;                                    // SIG_TRH_SHT: Short direction price Threshold, %
// input  string                    Inp_FIL_DWA_LNG                    = 0;                                    // FIL_DWA_LNG: Days of Week allowed for Long
// input  string                    Inp_FIL_DWA_SHT                    = 0;                                    // FIL_DWA_SHT: Days of Week allowed for Short

// CASUNBotInputs inputs;
// inputs.ENT_LTP                   = Inp_ENT_LTP;                                                             // ENT_LTP: Lot Type
// inputs.ENT_LTV                   = Inp_ENT_LTV;                                                             // ENT_LTV: Lot Type Value
// inputs.ENT_LC_MOD                = Inp_ENT_LC_MOD;                                                          // ENT_LC_MOD: Lot Correction by Volatility Enabled
// inputs.ENT_LC_VR_DPT             = Inp_ENT_LC_VR_DPT;                                                       // ENT_LC_VR_DPT: Daily price movement threshold, %
// inputs.ENT_LC_VR_LTR             = Inp_ENT_LC_VR_LTR;                                                       // ENT_LC_VR_LTR: Lot Ratio applied after ever 'ENT_LC_VR_DPT' reached
// inputs.EXT_MOD                   = Inp_EXT_MOD;                                                             // EXT_MOD: Exit Mode
// inputs.EXT_TIM                   = Inp_EXT_TIM;                                                             // EXT_TIM: Exit fixed Time
// inputs.SIG_TIM                   = Inp_SIG_TIM;                                                             // SIG_TIM: Signal Time Interval (or strict time, e.g. "14:30")
// inputs.SIG_DIR                   = Inp_SIG_DIR;                                                             // SIG_DIR: Signal Direction Allowed
// inputs.SIG_MOD                   = Inp_SIG_MOD;                                                             // SIG_MOD: Signal Mode
// inputs.SIG_TRH_LNG               = Inp_SIG_TRH_LNG;                                                         // SIG_TRH_LNG: Long direction price Threshold, %
// inputs.SIG_TRH_SHT               = Inp_SIG_TRH_SHT;                                                         // SIG_TRH_SHT: Short direction price Threshold, %
// inputs.FIL_DWA_LNG               = Inp_FIL_DWA_LNG;                                                         // FIL_DWA_LNG: Days of Week allowed for Long
// inputs.FIL_DWA_SHT               = Inp_FIL_DWA_SHT;                                                         // FIL_DWA_SHT: Days of Week allowed for Short
void CASUNBotInputs::CASUNBotInputs():
       ENT_LTP(LOT_TYPE_DEPOSIT_PERCENT),
       ENT_LTV(200.0),
       ENT_LC_MOD(LOT_CORRECTION_MODE_VOLATILITY_RATIO){

};
bool CASUNBotInputs::CheckBeforeInit() {
  LastErrorMessage = "";
  if(!(ENT_LTV>0)) LastErrorMessage = "'ENT_LTV' must satisfy condition: ENT_LTV>0";
  if(!(ENT_LC_MOD == LOT_CORRECTION_MODE_VOLATILITY_RATIO && ENT_LC_VR_DPT>0)) LastErrorMessage = "'ENT_LC_VR_DPT' must satisfy condition: ENT_LC_MOD == LOT_CORRECTION_MODE_VOLATILITY_RATIO && ENT_LC_VR_DPT>0";
  if(!(SIG_TIM!=)) LastErrorMessage = "'SIG_TIM' must satisfy condition: SIG_TIM!=";

  return LastErrorMessage == "";
}
// GENERATED CODE == END == DO NOT REMOVE THIS COMMENT