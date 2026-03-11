import re
import os

filePath = r'c:\Users\unreallogic\Dev\netstats_pro\lib\presentation\games\widgets\shot_map_scoring.dart'

with open(filePath, 'r', encoding='utf-8') as f:
    content = f.read()

# 1. Update _isLocationValid and add _getClampedLogical
is_valid_pattern = r'bool _isLocationValid\(Offset point, Size size\) \{(?:.|\n)*?return true;\n  \}'
new_is_valid = """bool _isLocationValid(Offset point, Size size) {
    // We allow taps anywhere in the touch box and clamp them to court bounds in processing
    return true;
  }

  Offset _getClampedLogical(Offset point, Size size) {
    final x = (point.dx / size.width) * ShotMapScoring.courtWidth;
    const totalLogicalHeight =
        ShotMapScoring.thirdHeight + (ShotMapScoring.verticalPadding * 2);
    final y =
        ((point.dy / size.height) * totalLogicalHeight) -
            ShotMapScoring.verticalPadding;

    return Offset(
      x.clamp(0.0, ShotMapScoring.courtWidth),
      y.clamp(0.0, ShotMapScoring.thirdHeight),
    );
  }"""

content = re.sub(is_valid_pattern, new_is_valid, content)

# 2. Update _processShot to use logical clamping
process_shot_pattern = r'final logicalX = \(_dragStart!\.dx / size\.width\) \* ShotMapScoring\.courtWidth;\n    final logicalY =\n        \(\(_dragStart!\.dy / size\.height\) \* totalLogicalHeight\) -\n            ShotMapScoring\.verticalPadding;'
new_process_shot = """final logicalPos = _getClampedLogical(_dragStart!, size);
    final logicalX = logicalPos.dx;
    final logicalY = logicalPos.dy;"""

content = re.sub(process_shot_pattern, new_process_shot, content)

with open(filePath, 'w', encoding='utf-8') as f:
    f.write(content)

print("Successfully patched ShotMapScoring.dart")
