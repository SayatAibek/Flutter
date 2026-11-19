# Practice 11: A Real Server — NOTES

## Level 1: Postman / curl Observations

- **GET `/users` & `/users/1`**:
  - **Status**: `200 OK`
  - **Content-Type**: `application/json; charset=utf-8`
  - **Total users**: `10`
  - **Nested objects**: `address`, `company`
  - **Nested twice**: `address.geo`[cite: 6]
  - **Potentially absent / nullable fields**: `website` (`String?`), while `address.geo.lat` and `address.geo.lng` arrive as JSON strings (`"-37.3159"`) and are parsed to `double`[cite: 6].

- **GET `/users/999`**:
  - **Status**: `404 Not Found`[cite: 6]
  - **Body**: `{}` (empty JSON object)[cite: 6]

- **POST `/users`** (with JSON body and `Content-Type: application/json`):
  - **Status**: `201 Created`[cite: 6]
  - **Server additions**: Echoes back the sent JSON fields and adds `"id": 11`[cite: 6].

- **GET `/users?id=3`**:
  - **Status**: `200 OK`
  - **Shape**: Returns a JSON array containing 1 user object (`[ { ... } ]`), not a standalone object[cite: 6].

---

### Field Tables

#### User (Top-Level)[cite: 6]
| field | JSON type | Dart type | nullable? |
| :--- | :--- | :--- | :--- |
| `id` | number | `int` | no |
| `name` | string | `String` | no |
| `username` | string | `String` | no |
| `email` | string | `String` | no |
| `address` | object | `Address` | no |
| `phone` | string | `String` | no |
| `website` | string | `String?` | yes |
| `company` | object | `({String name, String catchPhrase})` | no |

#### Address (`user.address`)[cite: 6]
| field | JSON type | Dart type | nullable? |
| :--- | :--- | :--- | :--- |
| `street` | string | `String` | no |
| `suite` | string | `String` | no |
| `city` | string | `String` | no |
| `zipcode` | string | `String` | no |
| `geo` | object | `Geo` | no |

#### Geo (`user.address.geo`)
| field | JSON type | Dart type | nullable? |
| :--- | :--- | :--- | :--- |
| `lat` | string | `double` (`double.parse`) | no |
| `lng` | string | `double` (`double.parse`) | no |

#### Company (`user.company`)[cite: 6]
| field | JSON type | Dart type | nullable? |
| :--- | :--- | :--- | :--- |
| `name` | string | `String` | no |
| `catchPhrase` | string | `String` | no |
| `bs` | string | *(ignored in model)* | — |

---

## Level 5: Two Kinds of "No Network" Timings[cite: 6]

- **Airplane mode**: `< 1s` (immediate `SocketException` → `NoConnectionException` → Offline view with Retry)[cite: 6]
- **Dead Wi-Fi (no internet route)**: `~10.0s` (`TimeoutException` after 10 seconds → `NoConnectionException` → Offline view with Retry)[cite: 6]