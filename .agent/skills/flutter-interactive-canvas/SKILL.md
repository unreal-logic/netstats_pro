---
name: flutter-interactive-canvas
description: Skill for rendering complex vector graphics, tappable coordinate systems, and spatial data visualizations (like sport courts and heatmaps) using CustomPainter and GestureDetector.
---

# Flutter Interactive Canvas

## When to Use This Skill
- When rendering complex backgrounds that cannot be achieved with standard widgets (e.g., a netball court with accurate line markings).
- When capturing precise X, Y coordinates from user taps (e.g., plotting where a shot was taken on a court).
- When rendering heatmaps or polygons (e.g., GeoJSON scoring zones) over a visual area.
- When an interface requires zooming and panning.

## How to Use This Skill
1. **The Canvas:** Use `CustomPaint` and extend `CustomPainter` to draw lines, circles, and paths using the low-level Canvas API. Override `paint()` and `shouldRepaint()`.
2. **Interaction:** Wrap the `CustomPaint` (or a `Stack` over it) with a `GestureDetector`. Use `onPanUpdate` or `onTapDown` to capture `details.localPosition`.
3. **Responsive Scaling:** Never hardcode pixel values in `CustomPainter`. Always draw relative to the `size` argument provided to the `paint` method so the canvas scales automatically on different devices.
4. **Data Plotting:** To map UI coordinates (pixels) back to real-world domain coordinates (meters), strictly define a scaling ratio.

## Conventions
- **Performance:** Complex `CustomPainter`s should be wrapped in a `RepaintBoundary` to prevent the rest of the UI from forcing a canvas redraw.
- **State Separation:** Pass data to be drawn (like a list of previous events) into the `CustomPainter` via constructor. The painter should not manage state or call APIs.
- **MCP Integration:** Use the `dart-mcp-server` tools (like `get_widget_tree`) to verify that the `CustomPaint` boundary is sized correctly within the layout hierarchy.
