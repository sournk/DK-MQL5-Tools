//+------------------------------------------------------------------+
//|                                                  CASUNInputs.mqh |
//|                                                  Denis Kislitsyn |
//|                                             https://kislitsyn.me |
//+------------------------------------------------------------------+

#include "Include\DKStdLib\Common\DKStdLib.mqh"

enum ENUM_LOT_TYPE
{
  LOT_TYPE_FIXED_LOT = 0,      // Fixed Lot
  LOT_TYPE_DEPOSIT_PERCENT = 1 // % of Deposit
};

enum ENUM_LOT_CORRECTION_MODE
{
  LOT_CORRECTION_MODE_NONE = 0,            // None
  LOT_CORRECTION_MODE_VOLATILITY_RATIO = 1 // Volatility Ratio
};

enum ENUM_TRADE_DIR
{
  TRADE_DIR_BOTH = 0,   // Both
  TRADE_DIR_LONG = +1,  // Long
  TRADE_DIR_SHORT = -1, // Short
};

enum ENUM_SIGNAL_MODE
{
  SIGNAL_MODE_PRICE = 0, // Price comparison
  SIGNAL_MODE_SMA = 1,   // SMA comparison
};

enum ENUM_EXIT_MODE
{
  EXIT_MODE_FIXED_TIME = 0,             // Fixed Time
  EXIT_MODE_KEEP_POS_ON_SAME_SIGNAL = 1 // Keep Position On Same Signal
};

// PARSING AREA OF INPUT STRUCTURE == START == DO NOT REMOVE THIS COMMENT
struct CASUNBotInputs
{
  // input  group                    "1. ENTRY (ENT)"
  ENUM_LOT_TYPE ENT_LTP;               // ENT_LTP: Lot Type // LOT_TYPE_DEPOSIT_PERCENT
  double ENT_LTV;                      // ENT_LTV: Lot Type Value // 200.0(x > 0)
  ENUM_LOT_CORRECTION_MODE ENT_LC_MOD; // ENT_LC_MOD: Lot Correction by Volatility Enabled // LOT_CORRECTION_MODE_VOLATILITY_RATIO
  double ENT_LC_VR_DPT;                // ENT_LC_VR_DPT: Daily price movement threshold, % // 5.0(ENT_LC_MOD == LOT_CORRECTION_MODE_VOLATILITY_RATIO && x > 0.0)
  double ENT_LC_VR_LTR;                // ENT_LC_VR_LTR: Lot Ratio applied after ever 'ENT_LC_VR_DPT' reached // 0.5(ENT_LC_MOD == LOT_CORRECTION_MODE_VOLATILITY_RATIO && x > 0.0)

  // input  group                    "2. EXIT (EXT)
  ENUM_EXIT_MODE EXT_MOD; // EXT_MOD: Exit Mode // EXIT_MODE_KEEP_POS_ON_SAME_SIGNAL
  string EXT_TIM;         // EXT_TIM: Exit fixed Time // "10:30"(x != "")

  // input  group                    "3. SIGNAL (SIG)"
  string SIG_TIM;           // SIG_TIM: Signal Time Interval (or strict time, e.g. "14:30") // "13:30-14:00"(x != "")
  ENUM_TRADE_DIR SIG_DIR;   // SIG_DIR: Signal Direction Allowed // TRADE_DIR_BOTH
  ENUM_SIGNAL_MODE SIG_MOD; // SIG_MOD: Signal Mode // SIGNAL_MODE_SMA
  double SIG_TRH_LNG;       // SIG_TRH_LNG: Long direction price Threshold, % // +0.4
  double SIG_TRH_SHT;       // SIG_TRH_SHT: Short direction price Threshold, % // -0.2

  // input  group                    "4. FILTER (FIL)"
  string FIL_DWA_LNG; // FIL_DWA_LNG: Days of Week allowed for Long (;-sep) // "1;2;3;4;5"
  string FIL_DWA_SHT; // FIL_DWA_SHT: Days of Week allowed for Short (;-sep) // "1;2;3;4"
                      // PARSING AREA OF INPUT STRUCTURE == END == DO NOT REMOVE THIS COMMENT

  string LastErrorMessage;
  bool CASUNBotInputs::InitAndCheck();
  bool CASUNBotInputs::Init();
  bool CASUNBotInputs::CheckBeforeInit();
  bool CASUNBotInputs::CheckAfterInit();
  void CASUNBotInputs::CASUNBotInputs();
};

//+------------------------------------------------------------------+
//| Init struc and Check values
//+------------------------------------------------------------------+
bool CASUNBotInputs::InitAndCheck()
{
  LastErrorMessage = "";

  if (!CheckBeforeInit())
    return false;

  if (!Init())
  {
    LastErrorMessage = "Input.Init() failed";
    return false;
  }

  return CheckAfterInit();
}

//+------------------------------------------------------------------+
//| Init struc
//+------------------------------------------------------------------+
bool CASUNBotInputs::Init()
{
  return true;
}

//+------------------------------------------------------------------+
//| Check struc after Init
//+------------------------------------------------------------------+
bool CASUNBotInputs::CheckAfterInit()
{
  LastErrorMessage = "";
  return LastErrorMessage == "";
}

// GENERATED CODE == START == DO NOT REMOVE THIS COMMENT

// input  group                    "1. ENTRY (ENT)"
// input  ENUM_LOT_TYPE             Inp_ENT_LTP                        = LOT_TYPE_DEPOSIT_PERCENT;             // ENT_LTP: Lot Type
// input  double                    Inp_ENT_LTV                        = 200.0;                                // ENT_LTV: Lot Type Value
// input  ENUM_LOT_CORRECTION_MODE  Inp_ENT_LC_MOD                     = LOT_CORRECTION_MODE_VOLATILITY_RATIO; // ENT_LC_MOD: Lot Correction by Volatility Enabled
// input  double                    Inp_ENT_LC_VR_DPT                  = 5.0;                                  // ENT_LC_VR_DPT: Daily price movement threshold, %
// input  double                    Inp_ENT_LC_VR_LTR                  = 0.5;                                  // ENT_LC_VR_LTR: Lot Ratio applied after ever 'ENT_LC_VR_DPT' reached

// input  group                    "2. EXIT (EXT)
// input  ENUM_EXIT_MODE            Inp_EXT_MOD                        = EXIT_MODE_KEEP_POS_ON_SAME_SIGNAL;    // EXT_MOD: Exit Mode
// input  string                    Inp_EXT_TIM                        = "10:30";                              // EXT_TIM: Exit fixed Time

// input  group                    "3. SIGNAL (SIG)"
// input  string                    Inp_SIG_TIM                        = "13:30-14:00";                        // SIG_TIM: Signal Time Interval (or strict time, e.g. "14:30")
// input  ENUM_TRADE_DIR            Inp_SIG_DIR                        = TRADE_DIR_BOTH;                       // SIG_DIR: Signal Direction Allowed
// input  ENUM_SIGNAL_MODE          Inp_SIG_MOD                        = SIGNAL_MODE_SMA;                      // SIG_MOD: Signal Mode
// input  double                    Inp_SIG_TRH_LNG                    = +0.4;                                 // SIG_TRH_LNG: Long direction price Threshold, %
// input  double                    Inp_SIG_TRH_SHT                    = -0.2;                                 // SIG_TRH_SHT: Short direction price Threshold, %

// input  group                    "4. FILTER (FIL)"
// input  string                    Inp_FIL_DWA_LNG                    = "1;2;3;4;5";                          // FIL_DWA_LNG: Days of Week allowed for Long (;-sep)
// input  string                    Inp_FIL_DWA_SHT                    = "1;2;3;4";                            // FIL_DWA_SHT: Days of Week allowed for Short (;-sep)

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
// inputs.FIL_DWA_LNG               = Inp_FIL_DWA_LNG;                                                         // FIL_DWA_LNG: Days of Week allowed for Long (;-sep)
// inputs.FIL_DWA_SHT               = Inp_FIL_DWA_SHT;                                                         // FIL_DWA_SHT: Days of Week allowed for Short (;-sep)


//+------------------------------------------------------------------+
//| Constructor
//+------------------------------------------------------------------+
void CASUNBotInputs::CASUNBotInputs():
       ENT_LTP(LOT_TYPE_DEPOSIT_PERCENT),
       ENT_LTV(200.0),
       ENT_LC_MOD(LOT_CORRECTION_MODE_VOLATILITY_RATIO),
       ENT_LC_VR_DPT(5.0),
       ENT_LC_VR_LTR(0.5),
       EXT_MOD(EXIT_MODE_KEEP_POS_ON_SAME_SIGNAL),
       EXT_TIM("10:30"),
       SIG_TIM("13:30-14:00"),
       SIG_DIR(TRADE_DIR_BOTH),
       SIG_MOD(SIGNAL_MODE_SMA),
       SIG_TRH_LNG(+0.4),
       SIG_TRH_SHT(-0.2),
       FIL_DWA_LNG("1;2;3;4;5"),
       FIL_DWA_SHT("1;2;3;4"){

};


//+------------------------------------------------------------------+
//| Check struc before Init
//+------------------------------------------------------------------+
bool CASUNBotInputs::CheckBeforeInit() {
  LastErrorMessage = "";
  if(!(ENT_LTV > 0)) LastErrorMessage = "'ENT_LTV' must satisfy condition: ENT_LTV > 0";
  if(!(ENT_LC_MOD == LOT_CORRECTION_MODE_VOLATILITY_RATIO && ENT_LC_VR_DPT > 0.0)) LastErrorMessage = "'ENT_LC_VR_DPT' must satisfy condition: ENT_LC_MOD == LOT_CORRECTION_MODE_VOLATILITY_RATIO && ENT_LC_VR_DPT > 0.0";
  if(!(ENT_LC_MOD == LOT_CORRECTION_MODE_VOLATILITY_RATIO && ENT_LC_VR_LTR > 0.0)) LastErrorMessage = "'ENT_LC_VR_LTR' must satisfy condition: ENT_LC_MOD == LOT_CORRECTION_MODE_VOLATILITY_RATIO && ENT_LC_VR_LTR > 0.0";
  if(!(EXT_TIM != "")) LastErrorMessage = "'EXT_TIM' must satisfy condition: EXT_TIM != """;
  if(!(SIG_TIM != "")) LastErrorMessage = "'SIG_TIM' must satisfy condition: SIG_TIM != """;

  return LastErrorMessage == "";
}
// GENERATED CODE == END == DO NOT REMOVE THIS COMMENT