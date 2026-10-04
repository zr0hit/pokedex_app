# Flutter Pokédex Application

A premium, highly interactive Pokédex application built with Flutter. This project was developed as an assignment demonstrating modern Flutter UI/UX, advanced state management, and seamless REST API integration with PokeAPI.

## 🌟 Premium Features

- **Global Autocomplete Search:** A floating search bar that instantly searches across all ~1,300 known Pokémon natively and navigates directly to their details.
- **Cinematic Elemental Animations:** Tapping a Pokémon triggers highly advanced, contextual animations based on their elemental types:
  - **Electric:** Triggers erratic strobe flashes and massive jagged lightning strikes.
  - **Fire:** Unleashes a massive fiery eruption from the bottom of the screen.
  - **Water:** Creates a massive central splash with rapidly rising bubbles.
  - **Grass:** Triggers a furious diagonal Razor Leaf cyclone.
- **Legendary & Mythical Engine:** A custom-built internal roster engine intercepts type filters to allow seamless sorting of Legendary and Mythical Pokémon.
  - **Legendary Clicks:** Trigger blinding, screen-expanding sunburst auras matching their elemental colors.
  - **Mythical Clicks:** Trigger deep, mystical galaxy swirls containing their elemental icons.
- **Holographic Glassmorphism Cards:** The detail screens feature premium Glassmorphism stat cards with dark, swirling radial gradients that pulse with the exact colors of the Pokémon's dual types (mimicking a TCG Holographic effect).
- **Advanced Dynamic Typography:** Text styles and font animations natively adapt to the element using google_fonts:
  - Legendaries use pulsing glowing Cinzel Decorative.
  - Mythicals use mystical glowing Macondo.
  - Normal elements use crisp Anime-style Poppins with outline strokes.
- **Responsive Layout:** The grid intelligently calculates columns based on screen width, and the Detail Screen seamlessly transforms into a massive side-by-side layout on Desktop/Web.
- **Persistent Favorites:** Favorites are permanently cached using SharedPreferences and are loaded directly into memory for instantaneous cross-category filtering on the Favorites Screen.

## 🏗 Architecture & Technical Choices

1. **State Management (Provider)**
   - The entire app is powered by a central PokemonProvider. It elegantly manages pagination (offset and limit), background loading, type filtering, error handling, and memory caching of favorite PokemonDetails.
2. **Local Persistence (SharedPreferences)**
   - User favorites are persistently saved to device storage and immediately hydrated on startup.
3. **API Layer**
   - A dedicated ApiService encapsulates all HTTP logic with the PokeAPI, including resolving nested type endpoints and parallelizing detail fetches using Future.wait.
4. **Performance Optimizations**
   - GridView implementations utilize aggressive cacheExtent values to pre-render and hold complex images in memory, resulting in completely stutter-free scrolling even with hundreds of loaded cards.

## 🚀 How to Run

1. Ensure you have the Flutter SDK installed.
2. Clone this repository.
3. Run lutter pub get to install all dependencies (including provider, http, shared_preferences, and google_fonts).
4. Run the app on your preferred device (Mobile, Web, or Desktop):
   `ash
   flutter run
   `
   *(For Chrome/Web testing: lutter run -d chrome)*

## 🎨 Dependencies
- provider: State Management
- http: API Network Requests
- shared_preferences: Local Favorites Storage
- google_fonts: Advanced Dynamic Typography
