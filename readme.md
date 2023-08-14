# Fork of NamePlateKAI

This is a fork of the [NamePlateKAI](https://www.curseforge.com/wow/addons/nameplatekai) WoW addon.

Currently based on official NamePlateKAI 10.1.146.

NamePlateKAI 10.1.145 had integrated most of my previous fixes/improvements (see [changelog](https://github.com/tflo/Fork-of-NamePlateKAI/blob/master/changelog.md)).  
The remaining ones are these:

## Fixes

- More accurate label texts for spell name font selector, spell name size slider, and player small text font checkbox.

## Additions, improvements

### Auras

- Automatically disable KAI's auras when the [NameplateAuras](https://www.curseforge.com/wow/addons/nameplateauras)
  addon is loaded.

### Nameplate texts

- Removed the ugly *greater-than/less-than* signs from the guild name.[^1]

---

__License:__ MIT


[^1]: The *greater-than/less-than* signs have been used here as a substitute for angle brackets, as the client UI only seems to support ASCII (we're in 2023, but yeah). Using ASCII substitutes is OK in code (see html tags), but way too ugly in displays.  
The fact that Blizz also uses these glyphs as angle brackets should not impress you; when it comes to UI design and typography, Blizz has the competence of a ten-year-old drunk typing his first essays in MS Word. So no reason to copy that nonsense. — And besides, it just looks better without *any* sort of brackets, and semantically, there is no need at all for delimiters, as the guild name is already on its own line.
