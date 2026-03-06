// -----------------------------
// Netstatspro SaaS Module
// -----------------------------
Table users {
  id uuid [pk]
  email varchar [unique, not null]
  password_hash varchar
  first_name varchar
  last_name varchar
  profile_photo_url varchar
  mfa_enabled boolean
  created_at timestamptz
  updated_at timestamptz
  last_login_at timestamptz
}

Table organisations {
  id uuid [pk]
  name varchar
  logo_url varchar
  country varchar
  timezone varchar
  status varchar
  created_at timestamptz
  updated_at timestamptz
}

Table organisation_members {
  id uuid [pk]
  organisation_id uuid [ref: > organisations.id]
  user_id uuid [ref: > users.id]
  role varchar
  created_at timestamptz
}

Table subscription_plans {
  id uuid [pk]
  name varchar
  price_monthly numeric
  price_yearly numeric
  team_limit int
  player_limit int
  game_limit int
  features_json jsonb
  created_at timestamptz
}

Table organisation_subscriptions {
  id uuid [pk]
  organisation_id uuid [ref: > organisations.id]
  plan_id uuid [ref: > subscription_plans.id]
  status varchar
  current_period_start timestamptz
  current_period_end timestamptz
  cancel_at_period_end boolean
  created_at timestamptz
}

Table invoices {
  id uuid [pk]
  organisation_id uuid [ref: > organisations.id]
  amount numeric
  currency varchar
  invoice_date date
  paid boolean
  external_invoice_id varchar
  created_at timestamptz
}

// -----------------------------
// Netball Domain Module
// -----------------------------
Table players {
  id uuid [pk]
  organisation_id uuid [ref: > organisations.id]
  first_name varchar
  last_name varchar
  dob date
  height_cm int
  profile_photo_url varchar
  preferred_positions varchar[] 
  created_at timestamptz
  updated_at timestamptz
}

Table teams {
  id uuid [pk]
  organisation_id uuid [ref: > organisations.id]
  name varchar
  logo_url varchar
  colour_primary varchar
  colour_secondary varchar
  created_at timestamptz
  updated_at timestamptz
}

Table team_players {
  id uuid [pk]
  team_id uuid [ref: > teams.id]
  player_id uuid [ref: > players.id]
  joined_at timestamptz
  left_at timestamptz
}

Table competitions {
  id uuid [pk]
  organisation_id uuid [ref: > organisations.id]
  name varchar
  season_year int
  points_win int
  points_draw int
  points_loss int
  created_at timestamptz
  updated_at timestamptz
}

Table competition_teams {
  id uuid [pk]
  competition_id uuid [ref: > competitions.id]
  team_id uuid [ref: > teams.id]
}

Table venues {
  id uuid [pk]
  organisation_id uuid [ref: > organisations.id]
  name varchar
  address varchar
  indoor boolean
  created_at timestamptz
  updated_at timestamptz
}

Table court_layouts {
  id uuid [pk]
  venue_id uuid [ref: > venues.id]
  ruleset_version_id uuid
  layout_image_url varchar
  run_off_m numeric
  line_width_mm int
  created_at timestamptz
}

Table games {
  id uuid [pk]
  organisation_id uuid [ref: > organisations.id]
  competition_id uuid [ref: > competitions.id]
  venue_id uuid [ref: > venues.id]
  home_team_id uuid [ref: > teams.id]
  away_team_id uuid [ref: > teams.id]
  match_date timestamptz
  quarter_length_seconds int
  total_quarters int
  status varchar
  ruleset_version_id uuid [ref: > ruleset_versions.id]
  court_layout_id uuid [ref: > court_layouts.id]
  created_at timestamptz
  updated_at timestamptz
}

Table game_players {
  id uuid [pk]
  game_id uuid [ref: > games.id]
  team_id uuid [ref: > teams.id]
  player_id uuid [ref: > players.id]
  starting_position varchar
  is_starting boolean
}

Table game_events {
  id uuid [pk]
  game_id uuid [ref: > games.id]
  organisation_id uuid [ref: > organisations.id]
  team_id uuid [ref: > teams.id]
  player_id uuid [ref: > players.id]
  event_type varchar
  event_time_seconds int
  quarter_number int
  coordinates jsonb
  zone_id uuid [ref: > scoring_zones.id]
  points_awarded int
  metadata_json jsonb
  validated_by_rules_engine boolean
  created_at timestamptz
}

Table substitutions {
  id uuid [pk]
  game_id uuid [ref: > games.id]
  team_id uuid [ref: > teams.id]
  player_out_id uuid [ref: > players.id]
  player_in_id uuid [ref: > players.id]
  event_time_seconds int
  quarter_number int
  created_at timestamptz
}

// -----------------------------
// Rules & Formats Module
// -----------------------------
Table rulesets {
  id uuid [pk]
  organisation_id uuid [ref: > organisations.id] // nullable for global templates
  name varchar
  description text
  default boolean
  created_at timestamptz
}

Table ruleset_versions {
  id uuid [pk]
  ruleset_id uuid [ref: > rulesets.id]
  version_tag varchar
  source_reference varchar
  effective_from date
  config_json jsonb
  created_by uuid [ref: > users.id]
  created_at timestamptz
}

Table period_configs {
  id uuid [pk]
  ruleset_version_id uuid [ref: > ruleset_versions.id]
  period_count int
  period_length_seconds int
  interval_seconds int
  halftime_seconds int
  extra_time_policy_json jsonb
}

Table scoring_zones {
  id uuid [pk]
  ruleset_version_id uuid [ref: > ruleset_versions.id]
  name varchar
  polygon_geojson jsonb
  min_distance_m numeric
  max_distance_m numeric
  points int
  inclusive_line boolean
}

Table position_constraints {
  id uuid [pk]
  ruleset_version_id uuid [ref: > ruleset_versions.id]
  position_code varchar
  allowed_zone_geojson jsonb
  can_enter_goal_circle boolean
}

Table ruleset_features {
  id uuid [pk]
  ruleset_version_id uuid [ref: > ruleset_versions.id]
  feature_key varchar
  value_json jsonb
}

Table rotation_policies {
  id uuid [pk]
  ruleset_version_id uuid [ref: > ruleset_versions.id]
  policy_json jsonb
}

// -----------------------------
// Analytics Module
// -----------------------------
Table player_match_stats {
  id uuid [pk]
  game_id uuid [ref: > games.id]
  player_id uuid [ref: > players.id]
  team_id uuid [ref: > teams.id]
  goals int
  attempts int
  intercepts int
  turnovers int
  deflections int
  rebounds int
  minutes_played numeric
  centre_passes_won int
  centre_passes_lost int
  super_shot_attempts int
  super_shot_goals int
  power_play_points int
  net_interactions int
  created_at timestamptz
}

Table team_match_stats {
  id uuid [pk]
  game_id uuid [ref: > games.id]
  team_id uuid [ref: > teams.id]
  goals int
  attempts int
  intercepts int
  turnovers int
  deflections int
  rebounds int
  centre_passes_won int
  centre_passes_lost int
  created_at timestamptz
}

Table competition_standings {
  id uuid [pk]
  competition_id uuid [ref: > competitions.id]
  team_id uuid [ref: > teams.id]
  played int
  won int
  lost int
  drawn int
  points_for int
  points_against int
  points int
  updated_at timestamptz
}

// -----------------------------
// Operational Module
// -----------------------------
Table audit_logs {
  id uuid [pk]
  organisation_id uuid [ref: > organisations.id]
  user_id uuid [ref: > users.id]
  action varchar
  entity_type varchar
  entity_id uuid
  metadata_json jsonb
  created_at timestamptz
}

Table notifications {
  id uuid [pk]
  user_id uuid [ref: > users.id]
  organisation_id uuid [ref: > organisations.id]
  type varchar
  message text
  read boolean
  created_at timestamptz
}

Table files {
  id uuid [pk]
  organisation_id uuid [ref: > organisations.id]
  user_id uuid [ref: > users.id]
  file_url varchar
  file_type varchar
  created_at timestamptz
}

Table rules_engine_logs {
  id uuid [pk]
  game_event_id uuid [ref: > game_events.id]
  ruleset_version_id uuid [ref: > ruleset_versions.id]
  decision varchar
  reason text
  timestamp timestamptz
  user_override boolean
  override_by uuid [ref: > users.id]
}

Table rtrr_reviews {
  id uuid [pk]
  game_id uuid [ref: > games.id]
  reviewer_id uuid [ref: > users.id]
  review_notes text
  verdict varchar
  created_at timestamptz
}
