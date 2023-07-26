# Fork of NamePlateKAI

This is a fork of the [NamePlateKAI](https://www.curseforge.com/wow/addons/nameplatekai) WoW addon.

Base version is 10.1.144.

## Fixes

- Fixed all broken font settings.
- Fixed label text for spell name size slider.
- Updated a deprecated API function.

## Additions, improvements

### Auras

- Increased maximum aura size to 30 (was 20).
- Automatically disable KAI's auras when the [NameplateAuras](https://www.curseforge.com/wow/addons/nameplateauras)
  addon is loaded.

### Nameplate texts

- Added setting to display player title.
- Removed the greater-than/less-than signs from the guild name.[^1]
- Added a separate font object for the player "small" text (usually the guild name), so that it can have a different
  size, analogous to the NPC nameplates.
- Added a multiplier slider for both player and NPC small text. The multiplier is relative to the respective normal name
  text size. (Previously, it was fixed at 0.9 for NPCs, and player small texts had the same size as the main name).

---

__Disclaimer:__ Some of the changes are pretty recent and might have bugs.

__License:__ MIT


[^1]: The greater-than/less-than signs have been used here as a substitute for angle brackets, as the client UI only seems to support ASCII (we're in 2023, but yeah). But they're not angle brackets, angle brackets look different (and better). Using these glyphs as brackets is OK in code (see html tags), but certainly not in displays.
    The fact that Blizz also uses these glyphs as angle brackets should not impress you; when it comes to UI design and typography, Blizz has the competence of a ten-year-old drunk typing his first essays in MS Word. So no reason to copy that nonsense. — And, besides all that, it simply looks better without *any* sort of brackets.
