# KAYAN HTML Screen Designs

Source archive: `kayan app screen design.zip` (109 screens)

Extracted files live in `design/html/`.

## Section prefixes

| Prefix | Section | Flutter module |
|--------|---------|----------------|
| `07-dashboard` | Super-app hub | `lib/features/dashboard/` |
| `hs-` | Home services | `lib/features/services/` |
| `sh-` | Shopping | `lib/features/ecommerce/` |
| `or-` | طلبات / delivery | `lib/features/delivery/` |
| `cl-` | Classifieds | `lib/features/classifieds/` |

## Entry flow (01–22)

| HTML file | Flutter screen |
|-----------|----------------|
| `01-splash.html` | `SplashScreen` |
| `02-language-region.html` | `LanguageRegionScreen` |
| `03–05-onboarding-*.html` | `OnboardingScreen` |
| `08-login-1.html` | `LoginScreen` |
| `09-signup.html` | `SignupScreen` |
| `10-otp.html` | `OtpVerificationScreen` (partial) |

Entry widgets: `lib/shared/widgets/design/kayan_entry_widgets.dart`

## Delivery flow (or-*)

| HTML file | Flutter screen |
|-----------|----------------|
| `92-or-dashboard.html` | `DeliveryHomeScreen` |
| `93-or-restaurant-list.html` | `DeliveryVendorListScreen` |
| `94-or-restaurant-details.html` | `DeliveryVendorDetailScreen` |
| `94b-or-item-details.html` | `DeliveryItemDetailScreen` |
| `95-or-cart.html` | `DeliveryCartScreen` |
| `96-or-address.html` | `DeliveryAddressScreen` |
| `97-or-payment.html` | `DeliveryPaymentScreen` |
| `98-or-success.html` | `DeliverySuccessScreen` |
| `99-or-tracking.html` | `DeliveryTrackingScreen` |

Shared widgets: `lib/shared/widgets/design/kayan_design_widgets.dart`  
Design tokens: `lib/core/theme/kayan_design_tokens.dart`
