# Design System Document: The Ethereal Mentor

## 1. Overview & Creative North Star

### Creative North Star: The Ethereal Mentor
This design system moves away from the rigid, utility-first grids of standard career apps toward a "High-End Editorial" experience. It treats a student’s vocational journey not as a checklist, but as a curated exploration. We achieve this through **The Ethereal Mentor** aesthetic: a philosophy of airy layouts, soft organic light, and intentional layering that prioritizes clarity over clutter.

To break the "template" look, we utilize **intentional asymmetry**. Hero sections should feature overlapping glass containers that break the traditional container bounds. Typography is treated as a core design element—using extreme scale shifts to create a hierarchy that feels authoritative yet sophisticated. This system is designed to feel like a premium digital concierge, guiding students through the fog of career choices into a clear, emerald-tinted future.

---

## 2. Colors & Surface Philosophy

The palette leverages a foundation of `surface` (clean white/off-white) punctuated by the depth of **Royal Purple** (`primary`) and the growth-centric energy of **Emerald Green** (`secondary`).

### The "No-Line" Rule
**Explicit Instruction:** Designers are prohibited from using 1px solid borders for sectioning or containment. Boundaries must be defined solely through:
1.  **Background Color Shifts:** Placing a `surface-container-low` card on a `surface` background.
2.  **Tonal Transitions:** Using soft gradient shifts to indicate a change in content context.
3.  **Whitespace:** Leveraging the spacing scale to create "invisible" gutters.

### Surface Hierarchy & Nesting
Treat the UI as a physical stack of semi-transparent materials. Use the `surface-container` tiers to define "altitude":
*   **Base Layer:** `surface` (#f7f9fb) – The canvas.
*   **Sectional Layer:** `surface-container-low` (#f2f4f6) – For large grouping areas.
*   **Component Layer:** `surface-container-lowest` (#ffffff) – For cards or inputs to provide a "pop" against the canvas.
*   **Floating Layer:** Glassmorphic elements using `surface_tint` at 5-10% opacity with a 20px-40px backdrop blur.

### The "Glass & Gradient" Rule
Standard flat colors lack the "soul" required for a premium experience. 
*   **Organic Gradients:** Use a linear gradient from `primary` (#4800b2) to `primary_container` (#6200ee) at a 135-degree angle for main CTAs.
*   **The Glass Effect:** For navigation bars or floating action cards, use a background of `surface` at 70% opacity combined with a `backdrop-filter: blur(20px)`. This allows the "soft organic blue gradients" of the background to bleed through, creating a sense of depth and integration.

---

## 3. Typography

The system uses **Manrope** for its modern, geometric-yet-warm character. It bridges the gap between Apple’s functionalism and Material Design’s scalability.

*   **Display (lg/md):** Used for "Big Truths"—career matches or inspirational headers. These should be set with tight tracking (-2%) to feel editorial.
*   **Headlines:** The primary "hook." Use `headline-lg` for section headers with generous top margins to provide "air."
*   **Body:** `body-lg` is our workhorse. Ensure a line height of at least 1.6 to maintain the "premium" feel.
*   **Labels:** Use `label-md` sparingly for metadata (e.g., "3 min read" or "High Match"). These should always be in uppercase with +5% letter spacing to distinguish them from functional text.

**Editorial Tip:** Don't be afraid of the "Empty Space." A `display-lg` title should often sit alone on its own horizontal plane to command the user's focus.

---

## 4. Elevation & Depth

We convey hierarchy through **Tonal Layering** rather than shadows.

*   **The Layering Principle:** Depth is achieved by "stacking." Place a `surface-container-lowest` card on a `surface-container-low` section to create a soft, natural lift.
*   **Ambient Shadows:** If a "floating" effect is required (e.g., a bottom navigation bar or a primary modal), use an ultra-diffused shadow: `0px 20px 40px rgba(73, 68, 86, 0.08)`. Note the use of a tinted shadow (on-surface-variant) instead of pure black to keep the UI feeling organic.
*   **The "Ghost Border" Fallback:** If a border is required for accessibility, use the `outline-variant` token at **15% opacity**. A 100% opaque border is a failure of the design language.
*   **Glassmorphism Depth:** When using glass containers, ensure they have a 1px "inner glow" or "highlight" on the top edge using `white` at 20% opacity. This mimics how light hits the edge of real glass.

---

## 5. Components

### Buttons
*   **Primary:** Royal Purple (`primary`) to `primary_container` gradient. 48px height. `full` roundedness. No shadow; use a subtle `primary_fixed` inner glow on hover.
*   **Secondary:** Emerald Green (`secondary`) text on `secondary_container` background. High contrast for "success" or "action" states.
*   **Tertiary:** `on_surface` text with no background. Use for low-priority actions like "Skip" or "Back."

### Cards & Lists
*   **Strict Rule:** No divider lines. Separate items using 16px or 24px of vertical whitespace.
*   **Interaction:** On hover/tap, cards should transition from `surface-container-low` to `surface-container-lowest` and scale by 1.02x.
*   **Lists:** For vocational paths, use `surface-container-high` as a subtle background for the entire list block, letting the individual list items remain transparent.

### Input Fields
*   **Style:** Minimalist. No bottom line. Use a `surface-container-highest` background with `xl` (1.5rem) corner radius.
*   **Focus State:** The background stays consistent, but the "Ghost Border" (outline-variant) increases to 40% opacity, and the label (Royal Purple) floats elegantly above.

### Signature Components (App Specific)
*   **The "Path Finder" Glass Card:** A large, central glassmorphic card that sits over an organic blue gradient blob. It uses `backdrop-filter: blur(40px)` to obscure the background into a soft glow.
*   **The Match Chip:** Using `secondary_fixed` (Emerald) for career compatibility scores. It should feel like a jewel—small, high-contrast, and rounded.

---

## 6. Do’s and Don’ts

### Do
*   **Do** use overlapping elements. Let a glass card sit 20% over a header image.
*   **Do** use "Organic Blobs." Place soft, blurred circles of Royal Purple and soft blue in the background to break the white void.
*   **Do** use Manrope’s variable weights. Use Bold for headlines and Medium for body text to ensure a sleek, modern feel.

### Don’t
*   **Don’t** use pure black (#000000). Use `on_surface` (#191c1e) for text to keep the "Airy" feel.
*   **Don’t** use 1px dividers between list items. It creates visual "noise" that contradicts the premium aesthetic.
*   **Don’t** use tight spacing. If in doubt, add 8px more padding. The goal is to feel uncrowded.
*   **Don’t** use standard Material Design drop shadows. They are too heavy for this system. Stick to Tonal Layering and Ambient Shadows.