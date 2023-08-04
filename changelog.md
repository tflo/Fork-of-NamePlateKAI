# Changelog for this fork

## Changes 2023-08-04

### Selective merge of the new official 10.1.145 into my fork

#### Version 10.1.145 has adopted some of my previous fixes/improvements:

- Fixed all broken font settings.
- Updated a deprecated API function.
- Increased maximum aura size to 30 (was 20).
- Added setting to display player title.
- Added a separate font object for the player "small" text (usually the guild name), so that it can have a different
  size.
- Added a multiplier slider for both player and NPC small text.

#### Not integrated in 10.1.145, and thus *not* merged into the fork (i.e. thses changes remain active in the fork):

- Automatically disable KAI's auras when the [NameplateAuras](https://www.curseforge.com/wow/addons/nameplateauras)
  addon is loaded.
- Default value of 0.85 for small text font scale.
- Removed the greater-than/less-than signs from the guild name.
- They added a (mislabeled) checkbox to use the Spell Name font also for player small texts. Despite that, the labels of
  spell name font selector and size slider are still/again misleading, so I kept my old fixed labels with a slight
  modification. What the controls currently do is this:
  - The font selector selects the font for spell names and NPC small texts. If the new checkbox is enabled, then also
    for player small texts.
  - The slider presumably sets the font size for spell name texts, but not for NPC or player small texts (this is
    covered by the new multiplier slider).

All other changes have been merged into the fork.

### New fixes

#### Minor

- Fixed typo in a string ("frinedly"). (There is also a related misspelled variable name (`disableFreindlyBarsCheck`), but to
  avoid additional conflicts with future merges I left that as it is.)

## Changes 2023-07

### Fixes

- Fixed all broken font settings.
- Fixed label text for spell name size slider.
- Updated a deprecated API function.

### Additions, improvements

#### Auras

- Increased maximum aura size to 30 (was 20).
- Automatically disable KAI's auras when the [NameplateAuras](https://www.curseforge.com/wow/addons/nameplateauras)
  addon is loaded.

#### Nameplate texts

- Added setting to display player title.
- Removed the greater-than/less-than signs from the guild name.[^1]
- Added a separate font object for the player "small" text (usually the guild name), so that it can have a different
  size, analogous to the NPC nameplates.
- Added a multiplier slider for both player and NPC small text (default: 0.85). The multiplier is relative to the
  respective normal name text size. (Previously, it was fixed at 0.9 for NPCs, and player small texts had the same size
  as the main name).
