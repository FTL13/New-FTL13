# Introduction to the "ftl" Folder

## Why do we use it?

FTL13 has tried to keep /tg/station as an upstream and to stay up-to-date with it. Previous attempts failed due to the number of conflicts, so the coders have decided to keep everything modularized. The less code in any folder that isn't this ftl one, the fewer conflicts will exist in future updates.

## What does it mean to modularize something?

Something is modular when it exists independent from the rest of the code. This means that by simply adding something modular to the DME file, it will exist in-game. It is not always possible to completely modularize something, but if standards are followed correctly, then there should be few to none conflicts with /tg/station in the future.

## Please mark your changes

All modifications to non-ftl files should be marked.

- Single line changes should have `// ftl -- reason` at the end of the exact line that was edited
- Multi line changes start with `// ftl start -- reason` and end with `// ftl end`. The reason MUST be included in the change in all cases, so that future coders looking at the line will know why it is needed.
- The reason should generally be about what it was before, or what the change is.
- Commenting out some /tg/ code must be done by putting `/* ftl start -- reason` one line before the commented out code, with said line having only the comment itself, and `ftl end */` one line after the commented out code, always in an empty line.
- Some examples:
```
var/obj/O = new(ftl) // ftl -- added ftl argument to new
```
```
/* ftl start -- mirrored in our file
/proc/del_everything
	del(world)
	del(O)
	del(everything)
ftl end */
```

Once marking your changes to the /tg/ files with the proper comment standards, be sure to include the file path of the tg file in our changes.md in this folder. Keep the alphabetical order.


### tgstation.dme versus ftl13.dme

Do not alter the tgstation.dme file. All additions and removals should be to the ftl13.dme file. Do not manually add files to the dme! Check the file's box in the Dream Maker program. The Dream Maker does not always use alphabetical order, and manually adding a file can cause it to reorder. This means that down the line, many PRs will contain this reorder when it could have been avoided in the first place.

### Icons, code, and sounds

Icons are notorious for conflicts. Because of this, **ALL NEW ICONS** must go in the "ftl/icons" folder. There are to be no exceptions to this rule. Sounds don't cause conflicts, but for the sake of organization they are to go in the "ftl/sounds" folder. No exceptions, either. Unless absolutely necessary, code should go in the "ftl/code" folder. Small changes outside of the folder should be done with "hook" procs. Larger changes should simply mirror the file in the "ftl/code" folder.

If a multiline addition needs to be made outside of the "ftl" folder, then it should be done by adding a proc called "hook" proc. This proc will be defined inside of the "ftl" folder. By doing this, a large number of things can be done by adding just one line of code outside of the folder! If possible, also add a comment in the ftl file pointing at the file and proc where the "hook" proc is called, it can be helpful during upstream merges and such.

If a file must be completely changed, re-create it with the changes inside of the "ftl/code" folder. **Make sure to follow the file's path correctly** (i.e. code/modules/clothing/clothing.dm.) Then, remove the original file from the ftl13.dme and add the new one.

### Defines

Defines only work if they come before the code in which they are used. Because of this, please put all defines in the `code/__DEFINES/~ftl_defines' path. Use an existing file, or create a new one if necessary.

## Specific cases and examples

### Clothing

New clothing items should be a subtype of "/obj/item/clothing/CLOTHINGTYPE/ftl" inside of the respective clothing file. For example, replace CLOTHINGTYPE with ears to get "/obj/item/clothing/ears/ftl" inside of "ears.dm" in "code/modules/clothing." If the file does not exist, create it and follow this format.

### Actions and spells

New actions and spells should use the "ftl/icons/mob/actions.dmi" file. If it is a spell, put the code for the spell in "ftl/code/modules/spells." To make sure that the spell uses the FTL icon, please add "action_icon = 'ftl/icons/mob/actions.dmi'" and the "action_icon_state" var.

### Reagents

New reagents should go inside "ftl/code/modules/reagents/drug_reagents.dm." In this case, "drug_reagents" is an example, so please use or create a "toxins.dm" if you are adding a new toxin, etc. Recipes should go inside "ftl/code/modules/reagents/recipes/drug_reagents.dm." Once again, "drug_reagents" has been used as an example.