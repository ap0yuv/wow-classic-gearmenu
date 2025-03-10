# GearMenu

![](docs/gm_ragedunicorn_love_classic.png)

> GearMenu aims to help the player switching between items in and out of combat. When the player is in combat a combatqueue will take care of switching the item as soon as possible. It also allows you to define switching rules and keybinding slots.

![](docs/wow_badge.svg)
![](docs/license_mit.svg)
![Lint](https://github.com/RagedUnicorn/wow-classic-gearmenu/actions/workflows/lint.yaml/badge.svg?branch=master)

## Providers

[![](docs/curseforge.svg)](https://www.curseforge.com/wow/addons/gearmenu)
[![](docs/wago.svg)](https://addons.wago.io/addons/gearmenu)

**WoW Burning Crusade Classic Support**

> This Addon supports WoW Burning Crusade Classic see - [bcc-GearMenu](https://github.com/RagedUnicorn/wow-bcc-gearmenu/)

<a href="https://github.com/RagedUnicorn/wow-bcc-gearmenu/"><img src="/docs/the_burning_crusade_logo.png" width="40%"></img></a>

## Installation

WoW-Addons are installed directly into your WoW directory:

`[WoW-installation-directory]\Interface\AddOns`

Make sure to get the newest version of the Addon from the releases tab:

[GearMenu-Releases](https://github.com/RagedUnicorn/wow-classic-gearmenu/releases)

> Note: If the Addon is not showing up in your ingame Addonlist make sure that the Addon is named `GearMenu` in your Addons folder

## What is GearMenu?

GearMenus goal is to help the player switching between items on certain slots. Often players have items such as engineering items that have a one time use followed by a long cooldown. After using them during a fight the player wants to switch back to a more useful item. While changing items during combat is not possible (with some exceptions such as weapons) GearMenu can help with switching them as soon as possible. When a player tries to switch an item during combat it will be put into the combatqueue and switched as soon as possible. If the player leaves combat for just a split second all the items in the combatqueue will be switched. For some classes this might be even easier because they can use spells such as rogue - vanish or hunter - feign death.

**Supported slots:**

| Slotname          | Description                  |
|-------------------|------------------------------|
| HeadSlot          | Head/Helmet slot             |
| NeckSlot          | Neck slot                    |
| ShoulderSlot      | Shoulder slot                |
| ChestSlot         | Chest/Robe slot              |
| WaistSlot         | Waist/Belt slot              |
| LegsSlot          | Legs slot                    |
| FeetSlot          | Feet/Boots slot              |
| WristSlot         | Wrist/Bracers slot           |
| HandsSlot         | Hands slot                   |
| Finger0Slot       | First/Upper Ring slot        |
| Finger1Slot       | Second/Upper Ring slot       |
| Trinket0Slot      | First/Upper Trinket slot     |
| Trinket1Slot      | Second/Lower Trinket slot    |
| BackSlot          | Back/Cloak slot              |
| MainhandSlot      | Main-hand slot               |
| SecondaryHandSlot | Secondary-hand/Off-hand slot |
| RangedSlot        | Ranged slot                  |
| AmmoSlot          | Ammo slot                    |

## Features of GearMenu

### Item switch for certain slots

With GearMenu it is easy to switch between items in supported slots. This is especially useful for engineering items that you wear for a certain amount of time and then switch back to your usual gear.

![](docs/gm_switch_items.gif)

### CombatQueue

Certain items cannot be switched while the player is in combat. Weapons will be switched immediately whether the player is in combat or not. Other items that cannot be switched in combat will be enqueued in the combatqueue and switched as soon as possible. This is especially useful in PvP when you leave combat for a short time.

![](docs/gm_combat_queue.gif)

> Note: You can right-click any slot to clear the combatqueue for that slot

![](docs/gm_combat_queue_cancel.gif)

GearMenu also detects whether an itemswitch is possible even when out of combat. If you're switching an item while you're casting your mount or any other spell it will put the item in the combatqueue. As soon as the cast is over the item will be switched.

![](docs/gm_combat_queue_cast.gif)

This is also the case if you cancel your cast.

![](docs/gm_combat_queue_cast_cancel.gif)

### Quick Change

Quick change consists of rules that apply when certain items are used. The player can define rules for items that have a usable effect. An item might be immediately switched after use or only after a certain delay. Otherwise, the same rules for item switching apply. This means that if the user is in combat it will be moved to the combat queue and if he is out of combat the item will be immediately switched. See the optionsmenu for defining new rules based on the item type.

> Note: If an item has a buff effect, and you immediately change the item you will usually also lose its buff. In most cases it makes sense to set the delay to the duration of the buff

![](docs/gm_quick_change_add_rule.gif)

### Keybinding

GearMenu allows to keybind to every slot with a keybinding. Keybindings have to be set directly inside GearMenus configuration.

![](docs/gm_keybinding.gif)

### Drag and drop support

GearMenu allows dragging and dropping items onto slots, remove from slots and slots can even be switched in between.

#### Drag and drop between slots

![](docs/gm_drag_and_drop_slots.gif)

#### Drag and drop item to GearMenu

![](docs/gm_drag_and_drop_equip.gif)

#### Unequip item by drag and drop

![](docs/gm_drag_and_drop_unequip.gif)

### Combined Equipping

Slots such as trinket and ring slots have combined equipping enabled. This means that in addition to a left click on the item the player wishes to equip they also support right click. Slots that do not support combined quipping (which most don't) will normally equip any item whether it was left- or right-clicked. If the slot has combined equipping enabled a right click will instead put the chosen item into the opposite slot.

![](docs/gm_combined_equip.gif)

### Unequip Items

Enable an empty slot in the changeMenu that allows for quicker and easier unequipping of items.

![](docs/gm_unequip.gif)

### TrinketMenu

TrinketMenu allows the player to have all available trinkets and their status in view at all times. This makes it easier for the player to plan when to equip a trinket with a long cooldown. A left click will equip the trinket into the upper trinketslot and a right click will equip the item into the lower trinketslot.

![](docs/gm_trinketmenu_demo.gif)

### Macro Support

If you prefer having certain items in your actionslots GearMenu can still be of use. By using the macro-bridge you get all the advantages of the combatQueue in a normal macro.

#### Add Item to CombatQueue
```
/run GM_AddToCombatQueue(itemId, slotId)

# Example - Equip Hand of Justice into the lower trinket slot
/run GM_AddToCombatQueue(11815, 14)
```

> Note: It is not recommended using this for weapons because addons cannot switch weapons during combat (GearMenu will put the item into the combatQueue). With a normal weaponswitch macro however this is still possible.

#### Clear Slot From CombatQueue
```
/run GM_RemoveFromCombatQueue(slotId)

# Example - Clear headSlot queue
/run GM_AddToCombatQueue(1)
```

##### Finding itemId

Finding the id of a certain item is easiest with websites such as [wowhead](https://classic.wowhead.com/).

```
# Example:
https://classic.wowhead.com/item=11815/hand-of-justice
```

The number after item is the itemId we search for.

##### Finding slotId

For finding the correct slotId refer to the image below. Only InventorySlotIds are valid targets for GearMenu

![](docs/gm_interface_slots.png)

## Configurability

GearMenu is configurable. Don't need a certain slot? You can hide it.

To show the configuration screen use `/rggm opt` while ingame and `/rggm info` for an overview of options or check the standard blizzard addon options.

### Creating a GearBar

With the latest release it is possible to create multiple GearBars that can act independently of each other.

![](docs/gm_create_gearbar.gif)

### Configure a GearBar

Each GearBar has some configurations that can be done individually for each GearBar. This includes various sizes of the GearBar, its locked or unlocked state and what GearSlots are configured for the GearBar.

![](docs/gm_configure_gearslots.gif)

### Individual GearBar Configuration

#### Hide/Show Cooldowns

Whether cooldowns should be shown or hidden can be configured individually for each GearBar.

![](docs/gm_options_cooldowns.gif)

#### Hide/Show Keybindings

Whether keybindings should be shown or hidden can be configured individually for each GearBar.

![](docs/gm_options_keybindings.gif)

#### Lock/Unlock Window

Whether a GearBar should be freely movable or be locked in place can be configured individually for each GearBar.

![](docs/gm_options_lock_window.gif)

#### GearSlot Size

Every GearBar can have a different size for its GearSlots. You could for an example have a GearBar with very big trinkets and another with smaller slots for less important items.

![](docs/gm_options_gearslot_size.gif)

#### ChangeMenu Size

The size of the ChangeMenu can be configured individual from the GearSlot size.

![](docs/gm_options_changemenu_size.gif)

### General Configuration

#### FastPress Support

Enable whether an item in a Gearslot should be used when the player pressed down(keydown) or only after the key was released(keyup).

#### Filter Items by Quality

Not interested to see items with a quality level below a certain level? Filter them out and only items that meet your set level will be considered to be displayed in GearMenu.

![](docs/gm_options_filter_item_quality.gif)

#### Themes

GearMenu supports two different themes for its ui elements. By default, the custom theme will be used.

##### Custom

![](docs/gm_theme_custom.jpg)

##### Classic

![](docs/gm_theme_classic.jpg)

### TrinketMenu Configuration

TrinketMenu supports the following configuration features.

- Enabling/Disabling TrinketMenu completely
- Lock/Unlock the TrinketMenu
- Show or Hide trinket cooldowns
- Adapt size of the TrinketMenu

![](docs/gm_trinketmenu_configuration.gif)

## FAQ

#### The Addon is not showing up in WoW. What can I do?

Make sure to recheck the installation part of this Readme and check that the Addon is placed inside `[WoW-installation-directory]\Interface\AddOns` and is correctly named as `GearMenu`.

#### I get a red error (Lua Error) on my screen. What is this?

This is what we call a Lua error, and it usually happens because of an oversight or error by the developer (in this case me). Take a screenshot off the error and create a GitHub Issue with it, and I will see if I can resolve it. It also helps if you can add any additional information of what you were doing at the time and what other addons you have active. Additionally, if you are able to reproduce the error make sure to check if it still happens if you disable all others addons.

#### GearMenu spams my chat with messages. How can I deactivate this?

Those obnoxious messages are intended for the development of this addon and means that you download a development version of the addon instead of a proper release. Releases can be downloaded from here - https://github.com/RagedUnicorn/wow-classic-gearmenu/releases

#### A certain item is not showing up when I hover a slot. Why is that?

GearMenu filters by default, items that are below common (green) quality. This can be changed in the addon configuration settings in the option "Filter Item Quality".

#### GearMenu failed to switch my item. What happened?

There are certain limitations that make it harder to switch an item even if the player is out of combat. One such example is that WoW prevents switching items while the player is casting a spell. GearMenu detects this and changes the item as soon as there is a pause between two spells or if a spell was cancelled. Just keep this in mind if you absolutely need the item switch to happen as soon as possible. Another factor can be a loss of control effect such as sap, iceblock and similar effects. In such circumstances it is not possible to switch an item. GearMenu is aware of such effects on the player and will switch the item as soon as possible.

If you still think you found an issue where GearMenu doesn't switch items as expected feel free to create an [issue](https://github.com/RagedUnicorn/wow-classic-gearmenu/issues).

#### Why can't I switch Weapons during Combat?

This is a limitation that Blizzard puts on addons. It is not currently possible to switch to an arbitrary weapon while in combat. It is however possible to create weaponswitch macros because it is already known from which weapon to what weapon the player wants to switch. While it is not ideal, to work around this issue GearMenu puts weapons in the CombatQueue if a weaponswitch is done while the player is in combat. If he is not in combat the switch will happen immediately. This might be improved in a future release if there is a better workaround possible.

> Note: It is also possible to switch a weapon by dragging and dropping the weapon in the standard Blizzard interfaces. This however is in no way connected to GearMenu

#### Why can't I create an Itemset?

This addon does not have the intention on supporting the functionality of switching between a PVE and a PVP set (or any other set). Its intention is to assist the player in switching single items fast and possibly during combat. It does not try to be the next Outfitter addon.

## Development

### Switching between Environments

Switching between development and release can be achieved with maven.

```
mvn generate-resources -D generate.sources.overwrite=true -P development
```

This generates and overwrites `GM_Environment.lua` and `GearMenu.toc`. You need to specifically specify that you want to overwrite the files to prevent data loss. It is also possible to omit the profile because development is the default profile that will be used.

Switching to release can be done as such:

```
mvn generate-resources -D generate.sources.overwrite=true -P release
```

In this case it is mandatory to add the release profile.

**Note:** Switching environments has the effect changing certain files to match an expected value depending on the environment. To be more specific this means that as an example test and debug files are not included when switching to release. It also means that variables such as loglevel change to match the environment.

As to not change those files all the time the repository should always stay in the development environment. Do not commit `GearMenu.toc` and `GM_Environment.lua` in their release state. Changes to those files should always be done inside `build-resources` and their respective template files marked with `.tpl`.

### Packaging the Addon

To package the addon use the `package` phase.

```
mvn package -D generate.sources.overwrite=true -P development
```

This generates an addon package for development. For generating a release package the release profile can be used.

```
mvn package -D generate.sources.overwrite=true -P release
```

**Note:** This packaging and switching resources can also be done one after another.

**Note:** The packaging is not fit to be used for CurseForge because CurseForge expects a specific packaging

```
# switch environment to release
mvn generate-resources -D generate.sources.overwrite=true -P release
# package release
mvn package -P release
```

### Deploy GitHub Release

Before creating a new release update `addon.tag.version` in `pom.xml`. Afterwards to create a new release and deploy to GitHub the `deploy-github` profile has to be used.

```
# switch environment to release
mvn generate-resources -D generate.sources.overwrite=true -P release
# deploy release
mvn package -P deploy-github -D github.auth-token=[token]
```

**Note:** This is only intended for manual deployment to GitHub. With GitHub actions the token is supplied as a secret to the build process

### Deploy CurseForge Release

**Note:** It's best to create the release for GitHub first and only afterwards the CurseForge release. That way the tag was already created.

```
# switch environment to release
mvn generate-resources -D generate.sources.overwrite=true -P release
# deploy release
mvn package -P deploy-curseforge -D curseforge.auth-token=[token]
```

**Note:** This is only intended for manual deployment to CurseForge. With GitHub actions the token is supplied as a secret to the build process

### Deploy Wago.io Release

**Note:** It's best to create the release for GitHub first and only afterwards the Wago.io release. That way the tag was already created.

```
# switch environment to release
mvn generate-resources -D generate.sources.overwrite=true -P release
# deploy release
mvn package -P deploy-wago -D wago.auth-token=[token]
```

**Note:** This is only intended for manual deployment to Wago.io. With GitHub actions the token is supplied as a secret to the build process

### GitHub Action Profiles

This project has GitHub action profiles for different Devops related work such as linting and deployments to different providers. See `.github` folder for details.

## License

MIT License

Copyright (c) 2022 Michael Wiesendanger

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
