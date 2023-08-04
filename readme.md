# Fork of NamePlateKAI

This is a fork of the [NamePlateKAI](https://www.curseforge.com/wow/addons/nameplatekai) WoW addon.

Base version is 10.1.145. This version has integrated most of my previous fixes/improvements (see [changelog](https://github.com/tflo/Fork-of-NamePlateKAI/blob/master/changelog.md)).

The remaining ones are these:

## Fixes

- Less misleading label texts for spell name font selector and size slider.

## Additions, improvements

### Auras

- Automatically disable KAI's auras when the [NameplateAuras](https://www.curseforge.com/wow/addons/nameplateauras)
  addon is loaded.

### Nameplate texts

- Removed the ugly greater-than/less-than signs from the guild name.[^1]

---

__License:__ MIT


[^1]: The greater-than/less-than signs have been used here as a substitute for angle brackets, as the client UI only seems to support ASCII (we're in 2023, but yeah). But they're not angle brackets, angle brackets look different (and better). Using these glyphs as brackets is OK in code (see html tags), but certainly not in displays.
    The fact that Blizz also uses these glyphs as angle brackets should not impress you; when it comes to UI design and typography, Blizz has the competence of a ten-year-old drunk typing his first essays in MS Word. So no reason to copy that nonsense. — And, besides all that, it simply looks better without *any* sort of brackets.
