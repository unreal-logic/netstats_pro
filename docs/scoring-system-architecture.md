# Netball Universal Scoring System Architecture

Based on the official variations of Netball (Standard World Netball, Fast5, Suncorp Super Netball (SSN), and WINA Indoor 6s/7s), a rigid 1-point system is insufficient. This application implements an **Event-Driven Spatial Scoring Architecture** to handle complex scoring rules.

## 1. Format Variations & Scoring Logic

| Format | Scoring Zones | Base Points | Modifiers & Conditions |
| :--- | :--- | :--- | :--- |
| **Standard (7-a-side)** | Goal Circle (4.9m radius) | 1 pt | Shots outside circle are invalid. |
| **Suncorp Super Netball** | Standard Goal Circle<br>Super Shot Zone (Outer 1.9m of circle) | 1 pt<br>2 pts | **Super Shot**: Only active in the last 5 minutes of each quarter. |
| **Fast5 Netball** | Inner Circle (1pt Zone)<br>Outer Circle (2pt Zone)<br>Super Shot Zone (Goal Third outside circle) | 1 pt<br>2 pts<br>3 pts | **Power Play**: Quarters double all points (1pt &rarr; 2pt, 2pt &rarr; 4pt, 3pt &rarr; 6pt). |
| **Indoor Netball (6s/7s)** | Inside Goal Circle<br>Outside Goal Circle (within Goal Third) | 1 pt<br>2 pts | Played in netted courts. Outside circle shots are valid. |

## 2. Spatial Calculation Engine

To determine the score of a registered shot, the system utilizes Euclidean distance from the shot's X/Y coordinates to the center of the relevant goal post.

**Court Dimensions**: 30.5m x 15.25m (Mapped to an internal 305 x 152.5 coordinate grid).

### Distance Formula
```
d = sqrt((x - post_x)^2 + (y - post_y)^2)
```

### Logic Tree
1. **Determine Active Half**: Check if coordinates are in the Left Goal Third or Right Goal Third. If in the Center Third, return `Invalid Location`.
2. **Calculate Distance**: Find distance `d` to the relevant post.
3. **Apply Active Ruleset Modifiers**: Check match state (e.g., *Is Super Shot Active?*, *Is Fast5 Power Play Active?*).
4. **Evaluate Boundaries**: Compare `d` against format-specific radii boundaries to assign the correct point value.

## 3. Recommended Database Schema

To support this in production, the data model must capture exact coordinates and the match state at the time of the event.

```json
{
  "match_id": "uuid",
  "ruleset": "fast5",
  "events": [
    {
      "event_id": "uuid",
      "timestamp_ms": 1678883201000,
      "period": 4,
      "event_type": "shot_attempt",
      "team_id": "team_A",
      "player_id": "player_7",
      "coordinates": { "x": 12.5, "y": 70.2 },
      "result": "made",
      "zone_calculated": "outer_circle",
      "points_awarded": 4,
      "modifiers_active": ["power_play"]
    }
  ]
}
```
