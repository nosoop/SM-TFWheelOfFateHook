#if defined _tf_wheeloffatehook_included
  #endinput
#endif
#define _tf_wheeloffatehook_included

public SharedPlugin:__pl_tf_wheeloffatehook = {
    name = "tf_wheeloffatehook",
    file = "tf_wheeloffatehook.smx",
#if defined REQUIRE_PLUGIN
    required = 1,
#else
    required = 0,
#endif
};

public __pl_tf_wheeloffatehook_SetNTVOptional() {
    MarkNativeAsOptional("WheelOfFate_SetCard");
}

#define WHEEL_OF_FATE_ALL               -1

enum WheelOfFateCards {
    WheelOfFateCard_Null = 0,           // 0
    WheelOfFateCard_Whammy,             // 1
    WheelOfFateCard_SuperJump,          // 2
    WheelOfFateCard_SmallHead,          // 3
    WheelOfFateCard_SuperSpeed,         // 4
    WheelOfFateCard_ZeroGravity,        // 5
    WheelOfFateCard_BigHead,            // 6
    WheelOfFateCard_UberCharge,         // 7
    WheelOfFateCard_CriticalHits,       // 8
    WheelOfFateCard_Dancing,            // 9
    WheelOfFateCard_FishTroll,          // 10
    WheelOfFateCard_Decapitated,        // 11
    WheelOfFateCard_BAR,                // 12
    WheelOfFateCard_HellsBells,         // 13
    WheelOfFateCard_LuckyYou,           // 14
    WheelOfFateCard_CherryBomb,         // 15
};

enum WheelOfFateWhammy {
    WheelOfFateWhammy_Fire,
    WheelOfFateWhammy_Jarate,
    WheelOfFateWhammy_Ghosts,
    WheelOfFateWhammy_Bleed
};

enum WheelOfFateEffects {
    WheelOfFateEffect_WhammyFire,
    WheelOfFateEffect_WhammyJarate,
    WheelOfFateEffect_WhammyGhosts,
    WheelOfFateEffect_WhammyBleed,
    WheelOfFateEffect_SuperJump,
    WheelOfFateEffect_SmallHead,
    WheelOfFateEffect_SuperSpeed,
    WheelOfFateEffect_ZeroGravity,
    WheelOfFateEffect_BigHead,
    WheelOfFateEffect_UberCharge,
    WheelOfFateEffect_CriticalHits,
    WheelOfFateEffect_Dancing
};

/**
 * Called when a Wheel of Fate has settled on a card to display after being spun.
 * This should cover most effects with the exception of Whammy, 
 * which will call a different forward once we can differentiate from the possible effects.
 *
 * This method takes one frame after the wheel finishes spinning to determine the card.
 * 
 * @param iWheel            Entity index of the wheel displaying a card.
 * @param card              The card that is displayed.
 * @noreturn
 */
forward WheelOfFate_OnCardShown(iWheel, WheelOfFateCards:card);

// TODO create method WheelOfFate_OnEffectApplied that also figures out which exact effect is called.

forward WheelOfFate_OnWhammy(iWheel, WheelOfFateWhammy:whammyEffect);

/**
 * Called when a Wheel of Fate's effects expired.
 * Basically does the same thing as hooking the entity output.
 * 
 * @param iWheel            Entity index of the wheel whose effect has expired.
 * @noreturn
 */
forward WheelOfFate_OnEffectExpired(iWheel);

/**
 * Sets the card that is displayed on the wheel.
 * All this does is set the skin on the wheel; no changes to player HUD or anything else are made.
 * This is pretty much a wrapper for setting m_nSkin.
 * 
 * @param iWheel            Entity index of wheel.  Use WHEEL_OF_FATE_ALL to change all wheels.
 * @param card              The card to change the wheel to.
 */
native WheelOfFate_SetCard(iWheel=WHEEL_OF_FATE_ALL, WheelOfFateCards:card);