/**
 * Sourcemod Plugin Template
 */

#pragma semicolon 1

#include <sourcemod>
#include <sdktools>
#include <tf_wheeloffatehook>

#define PLUGIN_VERSION          "0.0.1"     // Plugin version.

public Plugin:myinfo = {
    name = "[TF2] Wheel of Fate Hook",
    author = "nosoop",
    description = "Hooks into the Wheel of Fate result.",
    version = PLUGIN_VERSION,
    url = "http://github.com/nosoop/SM-TFWheelOfFateHook"
}

#define WHEEL_OF_DOOM                   "wheel_of_doom"
#define MERASMUS_VO_EFFECT_PREFIX       "vo/halloween_merasmus/sf12_wheel_"

new Handle:g_hWOFCardShown = INVALID_HANDLE,
    Handle:g_hWOFEffectExpired = INVALID_HANDLE;

public OnPluginStart() {
    HookEntityOutput(WHEEL_OF_DOOM, "OnEffectApplied", EntityOutput_OnEffectApplied);
    HookEntityOutput(WHEEL_OF_DOOM, "OnEffectExpired", EntityOutput_OnEffectExpired);
    
    g_hWOFCardShown = CreateGlobalForward("WheelOfFate_OnCardShown", ET_Ignore, Param_Cell, Param_Cell);
    g_hWOFEffectExpired = CreateGlobalForward("WheelOfFate_OnEffectExpired", ET_Ignore, Param_Cell);
}

public APLRes:AskPluginLoad2(Handle:hMySelf, bool:bLate, String:strError[], iMaxErrors) {
    RegPluginLibrary("tf_wheeloffatehook");
    CreateNative("WheelOfFate_SetCard", Native_SetCard);
    return APLRes_Success;
}

public EntityOutput_OnEffectApplied(const String:sOutput[], iCaller, iActivator, Float:fDelay) {
    RequestFrame(FrameRequestCallback_WheelOfFateCardCheck, iCaller);
}

public EntityOutput_OnEffectExpired(const String:sOutput[], iCaller, iActivator, Float:fDelay) {
    Call_StartForward(g_hWOFEffectExpired);
    Call_PushCell(iCaller);
    Call_Finish();
}

public FrameRequestCallback_WheelOfFateCardCheck(any:iCaller) {
    // Check card displayed on the entity.
    new nSkin = GetEntProp(iCaller, Prop_Data, "m_nSkin");
    
    Call_StartForward(g_hWOFCardShown);
    Call_PushCell(iCaller);
    Call_PushCell(nSkin);
    Call_Finish();
}

/**
 * Soundhook to determine which Whammy effect is in effect.
 * NOTE:  Inconsistent as fuck, so the hook is currently not used. 
 */
public Action:NormalSHook_OnEffectApplied(clients[64], &numClients, String:sample[PLATFORM_MAX_PATH], &entity, &channel, &Float:volume, &level, &pitch, &flags) {
    if (StrContains(sample, MERASMUS_VO_EFFECT_PREFIX) == 0) {
        // Sound plays at the same time the output is fired.
        // There is a delay of one frame before the card check runs.
        
        PrintToChatAll(sample[strlen(MERASMUS_VO_EFFECT_PREFIX)]);
    }
    
    return Plugin_Continue;
}

SetWheelOfFateCard(WheelOfFateCards:card, iEntity=WHEEL_OF_FATE_ALL) {
    if (iEntity == WHEEL_OF_FATE_ALL) {
        iEntity = -1;
        while ( (iEntity = FindEntityByClassname(iEntity, WHEEL_OF_DOOM)) != -1) {
            SetWheelOfFateCard(card, iEntity);
        }
    } else {
        SetEntProp(iEntity, Prop_Data, "m_nSkin", card);
        SetEdictFlags(iEntity, GetEdictFlags(iEntity) | FL_EDICT_CHANGED);
    }
}

public Native_SetCard(Handle:hPlugin, nParams) {
    new iWheel = GetNativeCell(1),
        WheelOfFateCards:card = GetNativeCell(2);
        
    SetWheelOfFateCard(card, iWheel);
}