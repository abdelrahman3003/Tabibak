# Force update configuration

The app checks Firebase Remote Config during startup before entering the signed-in or onboarding flow.

Create these parameters in the Firebase project (`evens-2f983`) and publish them:

| Parameter | Example | Purpose |
| --- | --- | --- |
| `minimum_supported_version` | `1.0.17` | Minimum allowed app version. Versions below this see a blocking update screen. Set an empty string to disable forced updates. |
| `android_store_url` | `https://play.google.com/store/apps/details?id=app.temsah.tabibak` | Android store listing URL. |
| `ios_store_url` | `https://apps.apple.com/app/idYOUR_APP_ID` | iOS store listing URL. Replace with the app's actual App Store URL. |

The app's current version comes from `pubspec.yaml` (`version: 1.0.0+16`), and comparisons use the version before `+` (the build number). Remote Config has a one-hour production fetch interval; debug builds fetch on each launch. If Remote Config is unavailable, startup continues normally.
