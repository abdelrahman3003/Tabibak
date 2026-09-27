# Force update configuration

The app fetches Firebase Remote Config on startup. Android uses Firebase project `evens-2f983`; iOS uses `delivery-638db` from its existing iOS Firebase configuration. Create and publish the same platform-specific parameters in both projects because they are separate Firebase projects:

| Parameter | Example | Purpose |
| --- | --- | --- |
| `tabibak_clinic_android_minimum_build` | `18` | Minimum allowed Android build number. The current app build is `17`; set this higher than the installed build to force an update. |
| `tabibak_clinic_ios_minimum_build` | `18` | Minimum allowed iOS build number. |
| `tabibak_clinic_android_store_url` | `https://play.google.com/store/apps/details?id=app.temsah.tabibak` | Android update destination. |
| `tabibak_clinic_ios_store_url` | `https://apps.apple.com/app/idYOUR_APP_ID` | iOS update destination; replace with the real App Store URL. |

The app also accepts the unprefixed `tabibak_android_minimum_build`, `tabibak_ios_minimum_build`, matching `tabibak_*_store_url` keys, and the original `minimum_supported_version`, `android_store_url`, and `ios_store_url` keys. The legacy minimum is compared with the app version (the part before `+` in `pubspec.yaml`), for example `1.0.1`. Clinic-prefixed minimum build values take precedence, so they also work with already-installed builds.

Production fetches are cached for one hour; debug builds fetch on each launch. If a fetch fails, the app checks the last activated Remote Config values.

To force the current build (`1.0.0+17`) to update, publish minimum build `18` for the platform being tested. Check the startup log for `Force update check:` to see the active Firebase project, platform, installed build, fetched minimum, and final `required` result. If that line reports `clinicMinimum=0 minimum=0 legacyMinimum=`, the Firebase parameter is missing, unpublished, or was changed in a different Firebase project. Release builds may need up to one hour to fetch newly published values.
