# ==========================================
#  PRAAT SCRIPT: Copy intervocalic tokens to "targets tier" -- make sure you add this before running the script! 
#  Targets: customizable consonants
#  Context: customizable vowels

#  If you use this script, please cite:
#  Syamken, S. (2025). Intervocalic token extractor [Praat script]. Georgetown University. Retrieved from https://sarah-syamken.github.io/sarah-syamken/
# =========================================
form Intervocalic Token Extractor
    comment Tier numbers:
    integer Phones_tier_number 2
    integer Targets_tier_number 3
    comment Target consonants (space-separated, e.g.: b d g):
    sentence Target_labels 
    comment Flanking vowels (space-separated, e.g.: a e i):
    sentence Vowel_labels 
endform

tg = selected("TextGrid")
if tg = 0
    exitScript: "Please select your TextGrid in the Objects window before running."
endif

eps = 0.0001
selectObject: tg

# Pad lists with spaces for whole-word matching
targets$ = " " + target_labels$ + " "
vowels$  = " " + vowel_labels$  + " "

# ---------- Ensure 'targets' tier exists ----------
nTiers = Get number of tiers
if nTiers < targets_tier_number
    Insert interval tier... nTiers + 1 "targets"
endif

numIntervals = Get number of intervals... phones_tier_number

# ---------- Loop through phones ----------
for j from 2 to numIntervals - 1
    lab$  = Get label of interval... phones_tier_number j
    prev$ = Get label of interval... phones_tier_number (j - 1)
    next$ = Get label of interval... phones_tier_number (j + 1)

    prevIsVowel = index(vowels$,  " " + prev$ + " ") > 0
    nextIsVowel = index(vowels$,  " " + next$ + " ") > 0
    isTarget    = index(targets$, " " + lab$  + " ") > 0

    if isTarget and prevIsVowel and nextIsVowel
        t1 = Get start time of interval... phones_tier_number j
        t2 = Get end time of interval...   phones_tier_number j
        mid = (t1 + t2) / 2

        # ---------- Add left boundary ----------
        already = 0
        n = Get number of intervals... targets_tier_number
        for k from 1 to n
            s    = Get start time of interval... targets_tier_number k
            endT = Get end time of interval...   targets_tier_number k
            if abs(t1 - s) < eps or abs(t1 - endT) < eps
                already = 1
            endif
        endfor
        if already = 0
            Insert boundary... targets_tier_number t1
        endif

        # ---------- Add right boundary ----------
        already = 0
        n = Get number of intervals... targets_tier_number
        for k from 1 to n
            s    = Get start time of interval... targets_tier_number k
            endT = Get end time of interval...   targets_tier_number k
            if abs(t2 - s) < eps or abs(t2 - endT) < eps
                already = 1
            endif
        endfor
        if already = 0
            Insert boundary... targets_tier_number t2
        endif

        # ---------- Copy the label ----------
        k = Get interval at time... targets_tier_number mid
        Set interval text... targets_tier_number k 'lab$'
    endif
endfor

clearinfo
appendInfoLine: "🤠 Buen trabajo! Intervocalic tokens copied to 'targets' tier."
