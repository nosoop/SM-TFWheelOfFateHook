/**
 * Sourcemod Plugin Template
 */

#pragma semicolon 1

#include <sourcemod>
#include <sdkhooks>
#include <sdktools>
#include <tf2>
#include <tf2_stocks>
#include <tf_wheeloffatehook>

#define PLUGIN_VERSION          "0.0.0"     // Plugin version.

public Plugin:myinfo = {
    name = "[TF2] Wheel of Fate Dance Fix",
    author = "nosoop",
    description = "Fixes the Wheel of Fate Dance on custom maps.",
    version = PLUGIN_VERSION,
    url = "localhost"
}

new bool:g_bAllDancing;

public OnMapStart() {
    g_bAllDancing = false;
}

public WheelOfFate_OnCardShown(iWheel, WheelOfFateCards:card) {
    if (card == WheelOfFateCard_Dancing) {
        g_bAllDancing = true;
        for (new i = MaxClients; i > 0; --i) {
            if (IsValidDanceTarget(i)) {
                SDKHook(i, SDKHook_PreThink, SDKHook_PreThinkDance);
            }
        }
    }
}

public SDKHook_PreThinkDance(iClient) {
    if (g_bAllDancing) {
        TF2_AddCondition(iClient, TFCond_HalloweenThriller, -1.0);
        FakeClientCommand(iClient, "taunt");
    } else {
        TF2_RemoveCondition(iClient, TFCond_HalloweenThriller);
        SetVariantInt(0);
        AcceptEntityInput(iClient, "SetForcedTauntCam");
    }
}

public WheelOfFate_OnEffectExpired(iWheel) {
    g_bAllDancing = false;
}

bool:IsValidDanceTarget(iClient) {
    return IsClientInGame(iClient)
            && IsPlayerAlive(iClient)
            && !TF2_IsPlayerInCondition(iClient, TFCond_HalloweenGhostMode);
}