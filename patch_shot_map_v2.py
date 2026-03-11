import re
import os

filePath = r'c:\Users\unreallogic\Dev\netstats_pro\lib\presentation\games\widgets\shot_map_scoring.dart'

with open(filePath, 'r', encoding='utf-8') as f:
    content = f.read()

# Pattern for _processShot mapping
old_mapping = r'final logicalX = \(_dragStart!\.dx / size\.width\) \* ShotMapScoring\.courtWidth;\n\s+final logicalY =\n\s+\(\(_dragStart!\.dy / size\.height\) \* totalLogicalHeight\) -\n\s+ShotMapScoring\.verticalPadding;'
new_mapping = """final logicalPos = _getClampedLogical(_dragStart!, size);
    final logicalX = logicalPos.dx;
    final logicalY = logicalPos.dy;"""

content = re.sub(old_mapping, new_mapping, content)

with open(filePath, 'w', encoding='utf-8') as f:
    f.write(content)

print("Successfully applied second patch to ShotMapScoring.dart")
