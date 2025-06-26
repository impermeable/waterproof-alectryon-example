#!/bin/sh
sed 's/```coq/```{coq}/g; s|<input-area>||g; s|</input-area>||g' waterproof_tutorial_modified.mv > waterproof_tutorial_tmp.mv
awk '
/^```{coq}/ {block=1; content=""; lines[0]=$0; count=1; next}
block && /^```$/ {
  # End of block; check content for non-whitespace
  if (content ~ /[^[:space:]]/) {
    lines[count++] = $0
    for (i=0; i<count; i++) print lines[i]
  }
  block=0; delete lines; count=0; next
}
block {lines[count++] = $0; content = content $0}
!block {print}
' waterproof_tutorial_tmp.mv > waterproof_tutorial_modified2.mv
sed -z 's/```{coq}\nQed./```{coq}\nAdmitted./g' waterproof_tutorial_modified2.mv > waterproof_tutorial_final.mv


alectryon --frontend md --output-directory _site waterproof_tutorial_final.mv
mv _site/waterproof_tutorial_final.mv.html _site/index.html