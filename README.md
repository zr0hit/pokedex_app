# Pokédex Flutter App

A beautifully polished Flutter application that implements a Pokédex UI using the PokéAPI, featuring real-time favorites syncing, dynamic particle animations, and habitat-based backgrounds.

## How to Run

1. Clone this repository.
2. Ensure you have Flutter installed on your system.
3. In your terminal, navigate to the project directory: cd pokedex_assignment
4. Run lutter pub get to fetch all dependencies.
5. Run lutter run -d chrome (for web) or lutter run for your preferred emulator/device.

## Technical Choices

### State Management: Provider
I chose Provider (ChangeNotifierProvider) for state management. For an application of this scale (tracking paginated lists, fetching API details, and maintaining a real-time list of favorite IDs), Provider is the perfect tool. It maintains a clean separation of business logic from UI code without the massive boilerplate overhead of Bloc/Riverpod. It inherently allows real-time UI updates across the entire widget tree simultaneously whenever 
otifyListeners() is called, making the "real-time sync" requirement across all screens seamless.

### Local Storage: SharedPreferences
I utilized SharedPreferences to persist the favorite Pokémon. The only data that needs to be stored locally is a simple list of IDs (Strings) representing the favorited Pokémon. Since the requirement explicitly states "offline caching of full Pokémon data... is out of scope", a heavy database like Hive or SQLite would be over-engineering. SharedPreferences is lightweight, fast, requires zero setup, and perfectly handles saving/loading a simple list of strings.

### Networking: http
Used for REST API requests. It's the most idiomatic Dart networking package for basic GET requests.

## Known Limitations & Future Improvements
1. **API Limitations (Type Filtering)**: The PokeAPI /pokemon list endpoint does not return type information. To achieve perfect type filtering, the app currently fetches all Pokémon belonging to a specific type via the /type/{id} endpoint and paginates through them. With more time, a local SQLite caching layer could be built to store all minimal Pokémon data upfront for instant offline sorting/filtering.
2. **Animation Performance**: The custom particle system uses Flutter's built-in AnimatedBuilder. While highly optimized and beautiful, a dedicated package like Lottie or Rive could provide even more complex, GPU-accelerated animations with less manual paint calculation.
3. **Caching Network Images**: Standard Image.network is used to ensure stability across Web and Desktop targets. For a purely mobile-first release, I would implement cached_network_image coupled with a custom CacheManager to persist sprites locally and save bandwidth on subsequent launches.
