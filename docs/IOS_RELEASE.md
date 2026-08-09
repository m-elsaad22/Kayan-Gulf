# KAYAN — iOS release (later)

Android / Play Store is the Phase 6 priority. Use this note when you start Apple distribution.

## Prerequisites

| Item | Notes |
|------|--------|
| Apple Developer Program | Paid membership |
| Xcode on macOS | Latest stable matching Flutter |
| Bundle ID | Align with Android brand, e.g. `sa.kayan.app` (create in Apple Developer) |
| Signing | Automatic signing or distribution certificate + App Store provisioning profile |
| Privacy nutrition labels | App Store Connect |

## Suggested flow

1. Ensure `ios/` project builds: `flutter create . --platforms=ios` if scaffold is incomplete.
2. Set display name / bundle ID in Xcode → Runner.
3. Add `GoogleService-Info.plist` locally if Firebase is enabled (do not commit).
4. Build:

   ```bash
   flutter build ipa \
     --release \
     --dart-define=KAYAN_USE_MOCK_DATA=false \
     --dart-define=KAYAN_API_BASE_URL=https://api.your-domain.com/v1
   ```

5. Upload via **Transporter** or Xcode Organizer → TestFlight → external/internal testers → App Store review.

## Listing

Mirror Play Store AR/EN copy and screenshots (6.5" / 5.5" required sets). Privacy policy URL required. Declare Sign in with Apple only if you add that provider later (current app uses phone OTP / email).

## Not in Phase 6 MVP

- TestFlight automation CI
- App Store Connect API keys in GitHub Actions
- Push via APNs production (wire when Firebase/iOS push is enabled)
