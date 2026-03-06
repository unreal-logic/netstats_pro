# The Digital Court: Comprehensive

# Analysis of Netball Variations, Statistical

# Architectures, and SaaS Ecosystems

## 1. Introduction: The Data-Driven Evolution of a

## Multi-Format Sport

The global sporting landscape has undergone a radical transformation over the last decade,
shifting from manual, paper-based record-keeping to sophisticated, real-time digital
ecosystems. Netball, a sport with over 20 million participants worldwide 4 , stands at the
forefront of this evolution, presenting a unique set of challenges and opportunities for data
architects, performance analysts, and software engineers. Unlike sports with relatively static
global rule sets, netball is characterized by a high degree of distinct variations—ranging from
the traditional seven-a-side international format to high-octane commercial leagues like
Suncorp Super Netball (SSN), the strategic complexity of Fast5, the enclosed intensity of
Indoor Netball, and scientifically designed junior pathways like NetSetGO and futureFERNS.
For a Software-as-a-Service (SaaS) platform to successfully serve this diverse community, it
cannot rely on a rigid, "one-size-fits-all" data model. It must instead be built upon a flexible,
event-driven architecture capable of handling dynamic rule configurations, variable team
sizes, multi-valued scoring systems, and complex player rotation policies. This report provides
an exhaustive technical analysis of these requirements, dissecting the specific rules and
statistical frameworks of each netball variation and mapping them to the necessary data
structures and user experience (UX) designs required for elite performance analysis and
grassroots management.
The following analysis is divided into core sections addressing the specific regulatory
frameworks of each game version, the statistical definitions used by elite data providers like
Champion Data, the architectural requirements for multi-tenant SaaS platforms, and the
visualization techniques required to turn raw data into actionable coaching insights. By
synthesizing these elements, we establish a blueprint for the next generation of netball
technologies—platforms that are not merely digital scorecards, but intelligent systems that
drive player development, fan engagement, and tactical innovation.

## 2. Standard International Netball: The Baseline Data

## Model


To understand the complexity of netball’s variations, one must first establish the baseline data
model derived from the standard World Netball rules. This format serves as the foundation
upon which all other variations are built, defining the core entities of the court, the player, and
the event.

### 2.1 Spatial Constraints and Positional Logic

The most defining characteristic of netball is its strict zonal restriction system. Unlike
basketball or football (soccer), where players are free to traverse the entire field of play,
netball restricts players to specific thirds or circles based on their assigned position. This
creates a data environment where "validity" is spatially determined.

#### 2.1.1 The Court Geometry

The standard court measures 30.5 meters (100 feet) in length and 15.25 meters (50 feet) in
width.^5 It is divided tranversely into three equal sections: the Goal Third (Defensive), the
Centre Third, and the Goal Third (Attacking). Additionally, a Goal Circle (radius 4.9m or 16 feet)
exists at each end.
From a data modeling perspective, the court is essentially a coordinate plane (0,0 to 100,
normalized) overlaid with polygon zones. Every event recorded—whether a pass, a shot, or an
interception—possesses an (x, y) coordinate property. The validity of this event is determined
by a logic check against the player's position at the timestamp of the event.

#### 2.1.2 Positional Validations

The seven on-court positions dictate the "valid zones" for player movement. In a modern
tracking system or a manual entry app, data points occurring outside these zones constitute
an "Offside" event, which is a specific type of turnover.
**Position Abbreviation Permitted
Zones
Exclusion
Zones
Data
Architecture
Implication
Goal Shooter** GS Attacking Goal
Third
Centre Third,
Defensive
Third, Outside
Goal Circle
Coordinate
validation must
restrict y axis
to the
attacking third
and Euclidean
distance from
goal post <
4.9m.


**Goal Attack** GA Attacking Goal
Third, Centre
Third
Defensive
Third, Outside
Goal Circle (for
shooting)
Can enter the
circle to shoot;
coordinates
inside circle
allow
event_type =
SHOT.
**Wing Attack** WA Attacking Goal
Third, Centre
Third
Goal Circle,
Defensive
Third
Requires a
"negative"
spatial
constraint:
valid in
Attacking Third
_except_ if
distance to
post < 4.9m.
**Centre** C All Three
Thirds
Both Goal
Circles
The most
complex
spatial
validation;
valid in the
largest area
but strictly
excluded from
the two critical
scoring zones.
**Wing Defence** WD Defensive Goal
Third, Centre
Third
Goal Circle,
Attacking Third
Mirror image
of WA
constraints.
**Goal Defence** GD Defensive Goal
Third, Centre
Third
Attacking Third Mirror image
of GA
constraints;
allows entry
into defensive
circle.


**Goal Keeper** GK Defensive Goal
Third
Centre Third,
Attacking Third
Mirror image
of GS
constraints.
This rigid structure implies that the data model for a "Player" entity is not static. A player is an
entity that assumes a "Role" (Position) which inherits specific "Constraints" (Zones). In a SaaS
platform, if a coach moves a player from C to WA during a quarter, the validation logic for that
player's data stream must instantly update to reflect the new zonal permissions.

### 2.2 Temporal Structure and Match Flow

Standard matches consist of four quarters, typically 15 minutes in duration. The clock is a
"stop-clock" system in elite games (stopping for injuries or tactical timeouts) but often a
"running clock" in community levels.

#### 2.2.1 The Event Stream

The flow of data in a netball match is a linear sequence of atomic events. The fundamental
event loop is:

1. **Centre Pass** : The restart of play.
2. **Possession Chain** : A sequence of passes (Pass -> Receive).
3. **Circle Entry** : A distinct event type critical for analytics (Feed).
4. **Shooting Phase** : Attempt -> Outcome (Goal/Miss) -> Rebound/Restart.
5. **Turnover Phase** : If the chain breaks (Intercept, Out of Court, Error), possession swaps.
In a relational database or NoSQL event store, each of these actions must be logged with
precise timestamps (down to the millisecond for professional analysis) to allow for the
calculation of derived metrics like "Time in Possession" or "Speed of Ball Movement."

### 2.3 Regulatory Nuance: The 2024 Rules Update

Recent changes to World Netball rules 6 have introduced "Tactical Changes," allowing players
to swap positions or substitute immediately after a goal is scored without holding time.
● **Data Implication:** Previously, substitutions were distinct "Stoppage" events. Now, the
Player_Position attribute is highly volatile. The system must support "hot-swapping" of
roles in the data feed without pausing the match_clock.
● **The "Throw-In" Logic:** Players can now take a throw-in without waiting for all players to
be on court.^8 This increases the speed of the game, requiring data entry operators
(scorers) to react faster. The User Interface (UI) for scoring apps must therefore minimize
latency and interactions required to log a restart.


## 3. High-Performance Commercial Variations: Suncorp

## Super Netball (SSN) & Fast

While standard rules provide the baseline, commercial imperatives have driven the creation of
distinct, high-intensity formats designed for broadcast appeal. Suncorp Super Netball (SSN)
and Fast5 introduce radical departures in scoring and team structure, requiring a rules engine
capable of dynamic reconfiguration.

### 3.1 Suncorp Super Netball (SSN): The Commercial Powerhouse

SSN is the premier domestic league in Australia and serves as a testing ground for innovations
that prioritize entertainment and high scores.

#### 3.1.1 The Super Shot (Two-Point Zone)

The most significant deviation in SSN is the introduction of the Super Shot.^9
● **The Rule:** In the final five minutes of any quarter (the "Power 5" period), goals scored
from a designated "outer circle" zone (between 3.0m and 4.9m from the goal post) are
awarded 2 points instead of 1.
● **Statistical Impact:** This rule necessitates a fundamental change in the Shot event entity.
It is no longer sufficient to record outcome: GOAL. The system must capture:
○ shot_distance: Precise distance from the post.
○ zone_type: "Inner" vs "Outer".
○ match_clock: The specific second the shot was taken.
● **Dynamic Valuation Logic:** The scoring engine must implement a conditional logic flow:
IF (match_clock <= 5:00) AND (shot_zone == 'OUTER') THEN
point_value = 2
ELSE
point_value = 1
This logic must be robust enough to handle edge cases, such as a shot released at 5:
but passing through the ring at 4:59.

#### 3.1.2 Rolling Substitutions and Timeouts

SSN permits rolling substitutions, meaning play continues while players interchange.^10
● **Tracking Complexity:** In standard netball, a "Team Sheet" is static for a quarter. In SSN,
the "On-Court 7" is a fluid state.
● **Load Monitoring:** To accurately calculate "Minutes Played" for load management, the
system must log Entry_Timestamp and Exit_Timestamp pairs for every player. A simple
"played the quarter" boolean is insufficient.
● **Tactical Timeouts:** SSN allows tactical timeouts, creating specific "break in play" events
that are statistically significant for momentum analysis (e.g., "Scoring rate before vs after


```
timeout").
```
#### 3.1.3 Extra Time Procedures

In the event of a draw, SSN utilizes extra time periods.^8 The data model must support Period_
and Period_6 (extra time halves), ensuring that statistical aggregations (e.g., "Full Time
Score") can distinguish between regulation time and overtime.

### 3.2 Fast5 Netball: The T20 of the Court

Fast5 is an abbreviated format designed for speed and high variance in scoring.^12 It
fundamentally alters the team structure and scoring potential, requiring distinct validation
schemas.

#### 3.2.1 Structural Reductions

```
● Team Size: 5 players on court (GS, GA, C, GD, GK). The Wing Attack (WA) and Wing
Defence (WD) positions are removed.
● Duration: Four quarters of 6 minutes (significantly shorter than the standard 15).
● Data Validation: The SaaS platform's "Team Sheet" validator must enforce a maximum of
5 active players. If a user attempts to assign a WA in a Fast5 match, the system must
throw a validation error.
```
#### 3.2.2 The Three-Tier Scoring System

Fast5 introduces a complex multi-zone scoring architecture 12 :

1. **Inner Zone (Zone 1):** Radius 3.5m. Value = 1 point.
2. **Outer Zone (Zone 2):** Area between 3.5m and 4.9m (edge of circle). Value = 2 points.
3. **Super Shot Zone (Zone 3):** Any area outside the goal circle. Value = 3 points.
    ○ _Note:_ In standard netball, a shot from outside the circle is invalid/turnover. In Fast5, it
       is the highest-value play. The "Offside" validation logic for the GS/GA must be
       disabled for the attacking third in this mode.

#### 3.2.3 The Power Play

Each team nominates one "Power Play" quarter where their points are doubled.^13
● **Algorithmic Complexity:** The scoring engine requires a power_play_active boolean flag
linked to specific team-quarter pairs.
● **Maximum Event Value:** A Super Shot (3 points) scored during a Power Play (x2) results
in a single event worth **6 points**. This creates massive variance in "Score Flow" charts and
requires the database to handle points_scored as a variable integer (1, 2, 3, 4, 6) rather
than a binary 1.

#### 3.2.4 Substitution Box Dimensions


Fast5 utilizes a rolling substitution box measuring 4m by 1m.^12 While primarily a physical
marking, digital systems managing venue layouts or court diagrams for coaches must
accurately render these dimensions to assist with logistical planning.

## 4. Indoor Netball: The WINA Framework

Indoor Netball, governed by the World Indoor Netball Association (WINA), is played within
tensioned nets, keeping the ball continuously in play. This format introduces unique rules
regarding the interaction with the court boundary (the net) and player roles.^15

### 4.1 The 6-a-Side "Link" Variation

One of the most distinct variations is the 6-a-side format, which removes the Wing positions
and introduces a specialized role: the **Link (L)** or Centre/Link.

#### 4.1.1 Positional Logic for the Link

```
● Team Composition: 2 Attackers, 2 Defenders, 2 Centre/Link players.
● Valid Zones: The Link player can traverse the entire court except for the two shooting
circles.^17
● Data Model Impact: Standard netball databases typically use an ENUM for positions
(GS, GA, WA, C, WD, GD, GK). The Indoor format requires expanding this ENUM to include
LINK. Furthermore, the spatial validation logic for LINK is unique: valid in Attacking_Third
+ Centre_Third + Defensive_Third but invalid in Goal_Circle_A + Goal_Circle_B.
```
#### 4.1.2 Scoring Structure

```
● Halves vs Quarters: Indoor netball is often played in two halves rather than four
quarters.^17 The Match object must support a dynamic period_count.
● Skins/Sets Scoring: Some indoor leagues use a "Skins" format where each quarter/half
is worth points independent of the total score. The SaaS platform must support
"Standings Tables" that calculate league points based on quarters_won in addition to
matches_won.
```
### 4.2 Net Interactions and "Net Abuse"

In Indoor Netball, the net is a playing surface. Players can use it to regain balance or keep the
ball in play, but strict rules govern its abuse.
● **Net Abuse:** Jumping into the net, climbing it, or using it to pin a player is a penalty.^15
● **Net Rebound:** A missed shot that bounces off the net remains in play (unlike standard
netball where it would be out).
● **Statistical Category:** A comprehensive indoor stats system needs a Net_Interaction
event type. This tracks how often a team utilizes the net for feeds or rebounds, a tactical


```
dimension absent in the outdoor game.
```
### 4.3 7-a-Side Indoor

This format more closely mirrors the standard outdoor game but retains the net-enclosed
court rules. The primary difference is the inclusion of WA and WD, removing the "Link" player.^17
This highlights the need for a system that can toggle between "6-a-side" and "7-a-side"
configurations at the click of a button.

## 5. Developmental Pathways: Junior Modified Rules

At the grassroots level, netball rules are modified to facilitate skill acquisition and
participation. These modifications, such as those in **NetSetGO** (Australia) and **futureFERNS**
(New Zealand), are not merely simplified rules—they are distinct regulatory frameworks with
their own data requirements.

### 5.1 NetSetGO (Australia)

NetSetGO is divided into tiers ("Set" and "Go") with progressive rules.^19

#### 5.1.1 Rule Modifications

```
● Duration: "Set" tier matches are 4 x 8 minutes; "Go" tier matches are 4 x 10 minutes.^21
● Footwork: The strict "grounded foot" rule is relaxed. "Shuffling on the spot" to regain
balance is permitted.^19 From a data perspective, this means fewer "Stepping" penalties
should be recorded. A coaching app configured for this level might remove the
"Stepping" button to declutter the interface.
● Scoring Suppression: While scores can be kept for coaching, they must often be
suppressed from public ladders to prioritize participation over winning.^22 The SaaS
platform must have a public_visibility flag for scores, allowing them to be recorded
backend but hidden frontend.
```
#### 5.1.2 Rotation Policies

Strict rotation policies mandate that players must experience all positions.
● **The Policy:** Players should play different positions throughout the season.^21
● **Software Requirement:** A "Rotation Tracker" feature is essential. The software should
analyze a player's history (e.g., "Sarah has played 8 quarters at GS") and flag if they are
becoming pigeonholed. It should suggest rotations (e.g., "Sarah should play WD this
week") to ensure compliance with the Netball Australia Junior Sports Policy.

### 5.2 futureFERNS (New Zealand)


The futureFERNS pathway is scientifically designed based on research by AUT, which showed
that modified formats (fewer players, smaller courts) led to more touches and successful
shots.^23

#### 5.2.1 Progressive Formats

```
● Year 1-2: 4 v 4, played across the transverse width of one-third of the court. No
goalposts (hula hoops used).^25
● Year 3-4: 5 v 5, played on two-thirds of a court. No Wing positions.
● Year 5-6: 6 v 6, full court.
● Year 7-8: 7 v 7, standard rules.^25
```
#### 5.2.2 Statistical Justification

Research indicated that in the 5 v 5 game, there was a successful shot every 3.1 minutes,
compared to every 8.9 minutes in the 7 v 7 game for the same age group.^23 This data point
validates the rule changes. A sophisticated analytics platform for juniors should track
"Engagement Metrics" (touches per player per minute) rather than just goals, proving to
parents and coaches that the modified format is aiding development.

## 6. The Statistical Lexicon: Definitions and Advanced

## Metrics

To standardize data across these variations, elite netball relies on a specific statistical lexicon,
largely defined by **Champion Data** , the official provider for major leagues.^26 Understanding
these definitions is crucial for accurate reporting.

### 6.1 Primary Statistics (Raw Events)

```
Category Statistic Definition & Nuance
Shooting Goal Attempt Any deliberate shot at the
ring.
Goal Made Successful entry. In SSN,
validated against time/zone
for points.
Goal Miss Attempt fails to enter.
```

**Possession Centre Pass Receive
(CPR)**
The _first_ player to receive
the ball in the centre third
after a Centre Pass.^27
Critical for measuring
midcourt dominance.
**Feed** Any pass that enters the
shooting circle.
**Goal Assist** The _final_ pass before a goal
is scored.^3 Distinct from a
Feed; measures the quality
of the final ball.
**Pickup** Gaining possession of a
loose ball (uncontested).^28
**Defensive Intercept** Gaining possession by
cutting off an opposition
pass.
**Deflection** Touching the ball to
change its path but _not_
gaining possession.
**Deflection with Gain** A deflection where the
deflector or a teammate
gains possession.^29

(^) **Rebound** Retrieving the ball after a
missed shot (Offensive or
Defensive).
**Errors General Play Turnover** Loss of possession due to
error (stepping, offside).
**Bad Hands** Dropping a catchable pass
(receiver error). Distinct
from "Bad Pass" (thrower
error).^29


### 6.2 Advanced Analytics (Derived Metrics)

Raw counts are insufficient for elite analysis. The SaaS rules engine must calculate derived
metrics to provide context.

#### 6.2.1 Gains and Gain to Goal % (GAG%)

The "Gain" is the definitive defensive metric, summing Intercepts, Deflections with Gain, and
Defensive Rebounds.
● **Gain to Goal % (GAG%):** Measures how often a team converts a defensive win into a
goal.
● _Formula:_.
● _Benchmark:_ The Melbourne Vixens recorded a GAG% of **69.3%** in the 2024 season.^29 A
drop below 50% usually correlates with a loss.

#### 6.2.2 Centre Pass Conversion (CP% / GCP%)

This measures offensive efficiency—the ability to score from one's own start.
● _Formula:_
.
● _Benchmark:_ Elite teams target **>75%**. The West Coast Fever topped this stat with
**79.3%**.^29
● _Implication:_ If a team has high gains but low CP%, the problem lies in their offense, not
their defense.

#### 6.2.3 Feed Efficiency

Differentiating between a "Feed" and a "Goal Assist" highlights the quality of entry.
● _Formula:_.
● _Insight:_ High feeds but low assists suggest the midcourters are forcing the ball into poor
positions, or shooters are missing under pressure.

## 7. Technical Data Architecture for SaaS Platforms

Building a platform like PlayHQ, NetballConnect, or a custom elite analytics tool requires a
robust technical architecture capable of handling the complexity described above.

### 7.1 Entity-Relationship Model (ERD)

The core database schema must reflect the hierarchical nature of sports organizations while
allowing for the flexibility of game variations.


#### 7.1.1 Core Entities

```
● Tenant (Organization): The top-level container (e.g., "Netball Victoria").
● Competition (League): e.g., "Saturday Morning Junior League."
● Season: e.g., "Winter 2026."
● Grade/Division: e.g., "Under 15 Division 1." This entity is crucial as it links to the
Ruleset_Config.
● Round: e.g., "Round 1."
● Match: The specific game instance. Attributes: venue_id, start_time, status (scheduled,
live, completed), home_team_id, away_team_id.
● Player: Attributes include ID, Name, DOB (for age verification).
● Team_Membership: Links Player to Team for a specific Season.
```
#### 7.1.2 The "Ruleset Configuration" Entity

To handle variations (Fast5 vs. Standard), the Grade entity must reference a Ruleset
configuration object (stored as a JSON blob or related table). This configuration drives the
validation logic of the application.
● periods: (4 quarters or 2 halves)
● period_duration_minutes: (15, 10, 8, or 6)
● team_size_on_court: (7, 6, or 5)
● scoring_zones: (Standard 1 or Fast5 1 )
● super_shot_active: (Boolean)
● power_play_enabled: (Boolean)
● rolling_subs: (Boolean)

### 7.2 Multi-Tenancy Strategies

For platforms serving thousands of clubs (like PlayHQ), data isolation is paramount.^30
● **Logical Isolation:** The most scalable approach. A tenant_id column is added to every
primary table (players, matches, teams). All API queries inject the tenant_id from the
authenticated user's session token (JWT) into the SQL WHERE clause. This prevents
"data leakage" where a coach from Club A accidentally sees stats from Club B.
● **Role-Based Access Control (RBAC):** Granular roles are required.^32
○ **Super Admin:** System-wide access.
○ **Association Admin:** Can generate fixtures and manage registrations.
○ **Club Admin:** Manage teams and payments.
○ **Coach:** View detailed stats for their team.
○ **Parent/Player:** Read-only access to their own data.

### 7.3 The Event Stream Architecture (NoSQL)

While organizational data fits a relational model (PostgreSQL), match statistics are best suited
for an immutable event stream (e.g., DynamoDB, MongoDB). A single match generates


thousands of atomic events.
JSON
{
"event_id": "evt_123456789",
"match_id": "match_555",
"timestamp_utc": "2026-05-20T14:30:25.000Z",
"match_clock": "00:12:45",
"period": 4 ,
"team_id": "team_A",
"player_id": "player_88",
"event_type": "GOAL_MADE",
"coordinates": { "x": 85.5, "y": 45.2 },
"attributes": {
"zone_type": "OUTER_CIRCLE",
"points": 2 , // Calculated by rules engine
"is_power_play": false
}
}

### 7.4 The Rules Engine

The backend requires a state machine to validate events.
● _Validation Example:_ If a CENTRE_PASS event is received, the engine checks the previous
state. It must be preceded by START_OF_PERIOD or GOAL_SCORED.
● _Dynamic Scoring:_ When a GOAL_MADE event arrives, the engine checks the
Ruleset_Config. If super_shot_active is true AND match_clock <= 5:00 AND zone_type ==
'Outer', it assigns 2 points. If power_play_enabled is true, it multiplies by 2.

## 8. User Experience (UX) and Live Scoring

The integrity of the data depends on the accuracy of the input. Scorers are often volunteers
or parents using mobile devices in fast-paced environments. The UX must be designed to
minimize cognitive load and latency.^33

### 8.1 Mobile Interface Design

```
● One-Handed Operation: Critical buttons (Goal, Miss, Turnover) should be placed in the
```

```
"thumb zone" (bottom third of the screen).^34
● Gesture Controls: To reduce "tap fatigue," gestures can be used:
○ Swipe UP on the court view for a Goal.
○ Swipe DOWN for a Miss.
○ Swipe SIDEWAYS for a Turnover.
● Haptic Feedback: Vibrations confirm entry, allowing the scorer to keep their eyes on the
game.
```
### 8.2 Contextual Intelligence

The app should predict the next likely event to reduce search time.
● _Scenario:_ A Goal is recorded.
● _System Action:_ Immediately prompt "Who takes the Centre Pass?" (or auto-select based
on alternating rules) and highlight the Centre player.
● _Scenario:_ A Miss is recorded.
● _System Action:_ Immediately present two large buttons: "Offensive Rebound" or
"Defensive Rebound."

### 8.3 Offline Capabilities

Netball courts often have poor connectivity. The app must support **Offline First**
architecture.^35 Events are stored locally (e.g., SQLite or Realm) and synced to the cloud via
WebSockets once connectivity is restored. This ensures the "Live Score" doesn't hang or
crash during the match.

## 9. Performance Analysis and Visualization

Once data is captured, it must be visualized to provide value to coaches and analysts.

### 9.1 Visualizing Space: Heatmaps and Flow

```
● Shot Charts: Unlike the scattered shot charts of basketball, netball shots are
concentrated. However, visualizing the entry point of the feed relative to the shot location
provides insight into the "Feed to Goal" relationship. In SSN, visualizing the density of
Super Shot attempts vs. success rate is critical for risk analysis.
● Possession Heatmaps: By plotting the (x,y) of every Centre Pass Receive, coaches can
see if a team favors the left or right pocket. A density map skewed to the sidelines
suggests the defense is forcing them wide (a win for the defense).
```
### 9.2 Rotation Management Algorithms

For junior grades, the software acts as a compliance tool.^36


```
● The Problem: Ensuring 9 players get equal time across 7 positions over a season.
● The Solution: A "Rotation Generator" algorithm.
○ Input: Player list, number of quarters.
○ Logic: Minimize variance in total_minutes. Enforce positions_played diversity (e.g.,
ensure every player plays 1 quarter in defense and 1 in attack).
○ Output: A printable quarter-by-quarter matrix for the coach.
```
### 9.3 Coaching Dashboards

Dashboards should move beyond tables to "Flow" visualizations.
● **Momentum Charts:** A line graph of "Score Difference" over time, annotated with
"Timeout" events. This reveals the impact of tactical interventions.
● **Win the Quarter:** A comparative view of Gains vs Turnovers per quarter. If Gains >
Turnovers, the team is statistically likely to win the period.
● **Conversion Funnels:** Visualizing the drop-off at each stage of play:
○ Centre Pass -> (90%) -> Circle Entry -> (80%) -> Shot Attempt -> (70%) -> Goal.
○ _Diagnosis:_ A drop at "Circle Entry" indicates midcourt pressure; a drop at "Goal"
indicates shooting inaccuracy.

## 10. Conclusion

The digitization of netball is not merely about replacing paper scorecards with screens; it is
about creating an intelligent infrastructure that respects the sport's diversity. From the
precision required to track a two-point Super Shot in Suncorp Super Netball to the
compliance logic ensuring a 7-year-old gets fair game time in NetSetGO, the data
requirements are vast and varied.
A successful SaaS platform in this domain must be built on a foundation of **flexibility**. It
requires a multi-tenant database to secure organizational data, a dynamic rules engine to
adapt to changing formats like Fast5 and Indoor Netball, and an event-driven architecture to
capture the high-frequency statistics of the modern elite game. By implementing the
statistical definitions, architectural patterns, and user experience designs outlined in this
report, technology providers can empower the netball community—from the grassroots
volunteer to the national performance analyst—to unlock the full potential of the game.
**Citations:**
3

#### Works cited

#### 1. A Systems Approach to Performance Analysis in Women's Netball: Using Work

#### Domain ... - PMC, accessed on February 13, 2026,


#### https://pmc.ncbi.nlm.nih.gov/articles/PMC6372500/

#### 2. Champion Data: Home, accessed on February 13, 2026,

#### https://www.championdata.com/

#### 3. On Performance Analysis in Elite Netball: Data Analytics Through The Use Of

#### Machine Learning and Computer Vision - USC Research Bank, accessed on

#### February 13, 2026,

#### https://research.usc.edu.au/view/pdfCoverPage?instCode=61USC_INST&filePid=

#### 3146429720002621&download=true

#### 4. Netball - Wikipedia, accessed on February 13, 2026,

#### https://en.wikipedia.org/wiki/Netball

#### 5. http://www.worldindoornetballassociation.com - Action Sports Meyersdal, accessed on

#### February 13, 2026,

#### https://albertonactioncricket.co.za/wp-content/uploads/2024/12/WINA_7s_6s_Rul

#### e_Book_2019_v2_Web.pdf

#### 6. World Netball Rules Book 2024, accessed on February 13, 2026,

#### https://netball.sport/wp-content/uploads/2024/01/World-Netball-Rules-Book-

#### 4.pdf

#### 7. 2024 Rules of Netball Update, accessed on February 13, 2026,

#### https://walesnetball.com/2024-rules-of-netball-update-2/

#### 8. Suncorp Super Netball rules update - NSW Swifts, accessed on February 13, 2026,

#### https://nswswifts.com.au/news/suncorp-super-netball-rules-update

#### 9. The effect of the Super Shot on team technical and tactical performance

#### indicators in Suncorp Super Netball - University of the Sunshine Coast,

#### Queensland, accessed on February 13, 2026,

#### https://research.usc.edu.au/esploro/outputs/journalArticle/The-effect-of-the-Sup

#### er-Shot/

#### 10. Suncorp Super Netball Launches Super Shot Rules Trial, accessed on February 13,

#### 2026,

#### https://netball.sport/wp-content/uploads/2024/02/Suncorp-Super-Netball-Launc

#### hes-Super-Shot-Rules-Trial.pdf

#### 11. When does risk outweigh reward? Identifying potential scoring strategies with

#### netball's new two-point rule | PLOS One - Research journals, accessed on

#### February 13, 2026,

#### https://journals.plos.org/plosone/article?id=10.1371/journal.pone.

#### 12. Rules of FAST5 - Netball, accessed on February 13, 2026,

#### https://netball.sport/wp-content/uploads/2024/01/World-Netball-Rules-of-FAST

#### -Netball-2022.pdf

#### 13. Everything you need to know about FAST5 Netball - Sportsnet® Holidays,

#### accessed on February 13, 2026,

#### https://sportsnetholidays.com/blog/everything-you-need-to-know-about-FAST5-

#### netball

#### 14. Fast5 Netball rules explained - YouTube, accessed on February 13, 2026,

#### https://www.youtube.com/watch?v=S77gUafQ4tE

#### 15. http://www.worldindoornetballassociation.com, accessed on February 13, 2026,

#### https://cdn.prod.website-files.com/6431f4ff5d665f0710394f79/643b5216599bb


#### db1e649ab_WINA_Rule_Book_6s_2014_Web.pdf

#### 16. WINA_6s_Rule_Book_2019_v2_... - the World Indoor Netball Association,

#### accessed on February 13, 2026,

#### https://worldindoornetballassociation.com/download/WINA_6s_Rule_Book_2019_

#### v2_Web.pdf

#### 17. Indoor Netball rules | The Rec Club | Sydney, accessed on February 13, 2026,

#### https://www.recclub.com.au/netball-rules

#### 18. Indoor netball - Wikipedia, accessed on February 13, 2026,

#### https://en.wikipedia.org/wiki/Indoor_netball

#### 19. Suncorp NetSetGO Handbook - Netball WA, accessed on February 13, 2026,

#### https://wa.netball.com.au/sites/wa/files/2021-01/Suncorp%20NetSetGO%20Hand

#### book%20PDF.pdf

#### 20. Suncorp NetSetGO Modified Rules - Netball NSW, accessed on February 13, 2026,

#### https://nsw.netball.com.au/sites/nsw/files/2020-06/ModifiedRulesSummary.pdf

#### 21. Woolworths NetSetGO Modified Rules. (2).pdf, accessed on February 13, 2026,

#### https://qld.netball.com.au/sites/qld/files/2023-03/Woolworths%20NetSetGO%

#### Modified%20Rules.%20%282%29.pdf

#### 22. FNA-NetSetGO-Rules-2022-FINAL.pdf - Fremantle Netball Association, accessed

#### on February 13, 2026,

#### https://fremantlenetball.com.au/wp-content/uploads/2022/04/FNA-NetSetGO-Ru

#### les-2022-FINAL.pdf

#### 23. Netball NZ leading change | Sport New Zealand - Ihi Aotearoa, accessed on

#### February 13, 2026, https://sportnz.org.nz/resources/netball-nz-leading-change/

#### 24. Case Study: Netball New Zealand - Balance is Better, accessed on February 13,

#### 2026, https://balanceisbetter.org.nz/case-study-netball-new-zealand/

#### 25. Year 7 & 8 – 7 v 7 - futureFERNS, accessed on February 13, 2026,

#### https://www.futureferns.co.nz/component/nnzlibrary/download/fe5b5ac6c14c89f

#### 3e07870e604a5eb45.html

#### 26. Consensus on a netball video analysis framework of descriptors and definitions

#### by the netball video analysis consensus group | British Journal of Sports Medicine,

#### accessed on February 13, 2026, https://bjsm.bmj.com/content/57/8/

#### 27. Consensus on a netball video analysis framework of descriptors and definitions

#### by the netball video analysis consensus group - British Journal of Sports

#### Medicine, accessed on February 13, 2026,

#### https://bjsm.bmj.com/content/bjsports/57/8/441.full.pdf

#### 28. Monitoring Training Workloads and Performance in an Elite Netball Team: Practical

#### Implications - UQ eSpace - The University of Queensland, accessed on February

#### 13, 2026,

#### https://espace.library.uq.edu.au/view/UQ:2c1cd6c/s4264283_phd_thesis.pdf

#### 29. Mid-season stats wrap - Melbourne Vixens, accessed on February 13, 2026,

#### https://melbournevixens.com.au/news/feature-articles/mid-season-stats-wrap

#### 30. Multi-Tenant SaaS Architecture: Scaling for Growth - Telliant – Intelligent Software

#### Delivered, accessed on February 13, 2026,

#### https://www.telliant.com/multi-tenant-saas-architecture-scaling-for-growth/

#### 31. Multi-Tenant Architecture for SaaS Application: All You Need to Know - JetBase,


#### accessed on February 13, 2026,

#### https://jetbase.io/blog/multi-tenant-architecture-for-saa-s-application-all-you-ne

#### ed-to-know

#### 32. How to Develop a Football Team Management App: Expert Guide - devabit,

#### accessed on February 13, 2026,

#### https://devabit.com/blog/how-to-develop-a-football-team-management-app/

#### 33. Building a real-time Livescore app with a Football API: Best practices -

#### Sportmonks, accessed on February 13, 2026,

#### https://www.sportmonks.com/blogs/building-a-real-time-livescore-app-with-a-f

#### ootball-api-best-practices/

#### 34. How to Improve Your Sports Gear App's User Interface for Enhanced Real-Time

#### Interaction and Engagement During Live Events - Zigpoll, accessed on February

#### 13, 2026,

#### https://www.zigpoll.com/content/how-can-i-improve-the-user-interface-of-my-s

#### ports-gear-app-to-enhance-realtime-interaction-and-make-it-more-engaging-f

#### or-customers-during-live-events

#### 35. NetScore Netball Scoring - App Store - Apple, accessed on February 13, 2026,

#### https://apps.apple.com/nz/app/netscore-netball-scoring/id

#### 36. Year 3-8 player rotation templates - Netball Wellington Centre, accessed on

#### February 13, 2026,

#### https://www.netballwellington.co.nz/coaches-concealed-pages/year-38-player-r

#### otation-templates

#### 37. [SOLVED] Creating a template for my junior netball team. - Excel Help Forum,

#### accessed on February 13, 2026,

#### https://www.excelforum.com/excel-general/1268317-creating-a-template-for-my

#### -junior-netball-team.html


