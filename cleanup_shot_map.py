import re

filePath = r'c:\Users\unreallogic\Dev\netstats_pro\lib\presentation\games\widgets\shot_map_scoring.dart'

with open(filePath, 'r', encoding='utf-8') as f:
    content = f.read()

# Pattern to find the unused totalLogicalHeight in _processShot
# It should be after if (_dragStart == null ...) and before _getClampedLogical
pattern = r'    const totalLogicalHeight =\n\s+ShotMapScoring\.thirdHeight \+ \(ShotMapScoring\.verticalPadding \* 2\);\n\n\s+final logicalPos = _getClampedLogical'
replacement = r'    final logicalPos = _getClampedLogical'

new_content = re.sub(pattern, replacement, content)

if new_content != content:
    with open(filePath, 'w', encoding='utf-8') as f:
        f.write(new_content)
    print("Successfully removed unused variable")
else:
    print("Could not find the pattern to remove")
