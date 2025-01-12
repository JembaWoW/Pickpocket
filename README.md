# Pickpocket
[SuperWoW](https://github.com/balakethelock/SuperWoW) (1.12) addon which displays if a mob has been pickpocketed on mouseover.

## Known Bugs

* Pickpocked state will never reset without reloaduing your UI: `/run ReloadUI()`
* If pickpocketing fails for whatever reason (out of range, resist, not in stealth etc.) the target will still be marked as being pickpocketed.
