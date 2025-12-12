# Open House Explorer

Sample Flutter app for the real‑estate listings assignment.

The app implements:

- **Listings Page**
  - Loads listings from a local JSON asset
  - Search by address with live filtering
  - Responsive UI that follows the provided Figma as closely as possible
- **Detail Page**
  - Large image gallery with pagination and MLS pill
  - Full property details + “Listing Agent” tab
  - “View on website”, “View on map” and Share actions

---

## Tech Stack

- **Flutter** (3.x)
- **Dart**
- **State management**: `provider` (`ChangeNotifier`)
- **Networking / assets**
  - Local JSON via `rootBundle`
  - `cached_network_image` for images (with local placeholder)
  - `share_plus` for sharing
  - `url_launcher` for opening website & map URLs

---

## Project Structure

```text
lib/
  main.dart

  domain/
    listing.dart              # Domain model (DOL)

  data/
    listings_local_data_source.dart
    listings_remote_data_source.dart   # HTTP stub, ready for backend
    listings_repository.dart           # Repository + in‑memory cache

  presentation/
    providers/
      listings_provider.dart           # ChangeNotifier for list/search state
    pages/
      listings_page.dart               # List + search UI
      listing_detail_page.dart         # Detail screen + actions
    widgets/
      listing_card.dart                # Card used in list view
      image_gallery.dart               # Gallery with dots + share button