# Mobile-First Design Rule

This application is strictly **Mobile-First and Tablet-Optimized**.

Whenever you are building user interfaces, designing layouts, or creating interaction patterns, you MUST:
1. Prioritize touch-friendly sizing (minimum 48x48 logical pixels for hit targets).
2. Ensure the layout works flawlessly on compact vertical screens (phones) before scaling it horizontally for tablets.
3. Use bottom navigation, tactile gestures, and mobile-native paradigms (like bottom sheets or specialized mobile keyboards) rather than desktop paradigms (like dense tables and hover states).
4. Always test widget constraints with the assumption that horizontal space constraint is the default state.
