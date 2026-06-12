# ==========================================
#  PRAAT SCRIPT: Intervocalic lenition export
#  Measure = ((V1max + V2max) / 2) - Cmin
#  Output: tab-delimited .txt
#
#  If you use this script, please cite:
#  Syamken, S. (2025). Intervocalic lenition exporter [Praat script]. Georgetown University. Retrieved from https://sarah-syamken.github.io/sarah-syamken
#
#  HOW TO CUSTOMIZE:
#  1. Fill in the form when it pops up
#  2. Edit the variables in the section
#     marked "Edit these to match your data"
#     directly in this script file
# ==========================================

form Export Intervocalic Lenition Table
    sentence FileID recording_01
    sentence Output_folder C:\Users\YourName\Documents\
    sentence Output_filename results_intervocalic_lenition.txt
    integer Phones_tier 2
    integer Targets_tier 3
    real Min_duration 0.01
endform

# ==========================================
#  EDIT THESE TO MATCH YOUR DATA
# ==========================================
target_labels$ = "b r"
vowel_labels$  = "a e i o u"
class1_name$   = "stop"
class1_labels$ = "b"
class2_name$   = "rhotic"
class2_labels$ = "r"
class3_name$   = ""
class3_labels$ = ""
# ==========================================

sound = selected("Sound")
tg = selected("TextGrid")

if sound = 0 or tg = 0
    exitScript: "Please select one Sound and one TextGrid before running."
endif

# Build full output path
outputfile$ = output_folder$ + output_filename$

# Pad lists for whole-word matching
targets$ = " " + target_labels$ + " "
vowels$  = " " + vowel_labels$  + " "
c1$      = " " + class1_labels$ + " "
c2$      = " " + class2_labels$ + " "
c3$      = " " + class3_labels$ + " "

selectObject: sound
To Intensity... 75 0 yes
intensity = selected("Intensity")

filedelete 'outputfile$'
fileappend 'outputfile$' "fileid	tokenid	targetlabel	phonelabel	class	context	cstart	cend	duration	prevlabel	nextlabel	v1start	v1end	v2start	v2end	v1max	cmin	v2max	vavgmax	intdiff\n"

selectObject: tg
numtargets = Get number of intervals... targets_tier
tokenid = 0

for i from 1 to numtargets
    selectObject: tg
    targetlabel$ = Get label of interval... targets_tier i

    if targetlabel$ <> ""
        istarget = index(targets$, " " + targetlabel$ + " ") > 0

        if istarget
            cstart = Get start time of interval... targets_tier i
            cend   = Get end time of interval...   targets_tier i

            if cend - cstart > min_duration
                cmid = (cstart + cend) / 2

                selectObject: tg
                phoneindex = Get interval at time... phones_tier cmid
                numphones  = Get number of intervals... phones_tier

                if phoneindex > 1 and phoneindex < numphones
                    phonelabel$ = Get label of interval... phones_tier phoneindex
                    prevlabel$  = Get label of interval... phones_tier (phoneindex - 1)
                    nextlabel$  = Get label of interval... phones_tier (phoneindex + 1)

                    previsvowel = index(vowels$, " " + prevlabel$ + " ") > 0
                    nextisvowel = index(vowels$, " " + nextlabel$ + " ") > 0

                    if previsvowel and nextisvowel
                        v1start = Get start time of interval... phones_tier (phoneindex - 1)
                        v1end   = Get end time of interval...   phones_tier (phoneindex - 1)
                        v2start = Get start time of interval... phones_tier (phoneindex + 1)
                        v2end   = Get end time of interval...   phones_tier (phoneindex + 1)

                        selectObject: intensity
                        v1max  = Get maximum... v1start v1end Parabolic
                        cmin   = Get minimum... cstart cend Parabolic
                        v2max  = Get maximum... v2start v2end Parabolic

                        vavgmax  = (v1max + v2max) / 2
                        intdiff  = vavgmax - cmin
                        duration = cend - cstart

                        # ---------- Assign class ----------
                        class$ = "other"
                        if class1_name$ <> "" and index(c1$, " " + targetlabel$ + " ") > 0
                            class$ = class1_name$
                        elsif class2_name$ <> "" and index(c2$, " " + targetlabel$ + " ") > 0
                            class$ = class2_name$
                        elsif class3_name$ <> "" and index(c3$, " " + targetlabel$ + " ") > 0
                            class$ = class3_name$
                        endif

                        context$ = prevlabel$ + "_" + targetlabel$ + "_" + nextlabel$
                        tokenid  = tokenid + 1

                        tokenid$  = string$(tokenid)
                        cstart$   = fixed$(cstart, 6)
                        cend$     = fixed$(cend, 6)
                        duration$ = fixed$(duration, 6)
                        v1start$  = fixed$(v1start, 6)
                        v1end$    = fixed$(v1end, 6)
                        v2start$  = fixed$(v2start, 6)
                        v2end$    = fixed$(v2end, 6)
                        v1max$    = fixed$(v1max, 6)
                        cmin$     = fixed$(cmin, 6)
                        v2max$    = fixed$(v2max, 6)
                        vavgmax$  = fixed$(vavgmax, 6)
                        intdiff$  = fixed$(intdiff, 6)

                        fileappend 'outputfile$' "'FileID$'	'tokenid$'	'targetlabel$'	'phonelabel$'	'class$'	'context$'	'cstart$'	'cend$'	'duration$'	'prevlabel$'	'nextlabel$'	'v1start$'	'v1end$'	'v2start$'	'v2end$'	'v1max$'	'cmin$'	'v2max$'	'vavgmax$'	'intdiff$'\n"
                    endif
                endif
            endif
        endif
    endif
endfor

selectObject: intensity
Remove

clearinfo
appendInfoLine: "🤠 Nicely done! Results written to: 'outputfile$'"
appendInfoLine: "Total tokens exported: 'tokenid'"
