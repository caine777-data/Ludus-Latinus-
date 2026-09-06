"""
Palettes de couleurs de l'interface, et petits calculs sur les teintes.

Trois thèmes sont proposés : sombre, clair et contraste élevé — ce
dernier existe pour les personnes qui distinguent mal les nuances, et
ne doit donc jamais être traité comme une simple variante décorative.

Chaque thème donne une couleur à un ROLE (fond, texte, accent, erreur…)
et non à un élément précis : c'est ce qui permet d'en ajouter un
quatrième sans toucher au reste de l'application.
"""

THEMES = {
    "rome": {
        "label": "rome impériale", "label_en": "imperial rome",
        "bg": "#faf6ee", "panel": "#efe6d5", "editor": "#ffffff",
        "console": "#f5ede0", "fg": "#2c2621", "accent": "#a82020",
        "ok": "#2d8a4e", "err": "#c93b2b", "muted": "#7a7062",
        "heading": "#8c1d1d", "code": "#b87314", "code_bg": "#f3ecde",
        "sel_fg": "#ffffff", "curline": "#f2ebdc",
        "kw": "#9c27b0", "builtin": "#a82020", "num": "#b87314",
        "deff": "#2d8a4e", "str": "#2e7d32", "com": "#8d8577",
    },
    "colisee": {
        "label": "nuit au colisée", "label_en": "colosseum night",
        "bg": "#181922", "panel": "#222430", "editor": "#14151c",
        "console": "#0f1016", "fg": "#eae8f2", "accent": "#e5a93c",
        "ok": "#4ecc7a", "err": "#f45858", "muted": "#9193a8",
        "heading": "#f3c267", "code": "#ffd700", "code_bg": "#14151c",
        "sel_fg": "#14151c", "curline": "#282a3a",
        "kw": "#ba68c8", "builtin": "#e5a93c", "num": "#ffb74d",
        "deff": "#4ecc7a", "str": "#81c784", "com": "#6f7287",
    },
    "mediterranee": {
        "label": "méditerranée & pompéi", "label_en": "mediterranean",
        "bg": "#f7f5f0", "panel": "#e8eef0", "editor": "#ffffff",
        "console": "#eef4f5", "fg": "#223035", "accent": "#1b7d87",
        "ok": "#2e8540", "err": "#d64527", "muted": "#687a82",
        "heading": "#bd4b2b", "code": "#d65a31", "code_bg": "#edf3f4",
        "sel_fg": "#ffffff", "curline": "#e2ecef",
        "kw": "#8e44ad", "builtin": "#1b7d87", "num": "#d65a31",
        "deff": "#27ae60", "str": "#16a085", "com": "#7f8c8d",
    },
    "dark": {
        "label": "sombre", "label_en": "dark",
        "bg": "#1e1f26", "panel": "#272935", "editor": "#15161c",
        "console": "#0e0f14", "fg": "#e6e6e6", "accent": "#4d8bf0",
        "ok": "#52c97a", "err": "#f0635c", "muted": "#9aa0b4",
        "heading": "#7fb0ff", "code": "#ffd479", "code_bg": "#15161c",
        "sel_fg": "#ffffff", "curline": "#23252f",
        "kw": "#c792ea", "builtin": "#82aaff", "num": "#f78c6c",
        "deff": "#ffcb6b", "str": "#c3e88d", "com": "#637777",
    },
    "light": {
        "label": "clair", "label_en": "light",
        "bg": "#f4f5f7", "panel": "#e7e9ee", "editor": "#ffffff",
        "console": "#eef0f4", "fg": "#1c1d22", "accent": "#2f6fe0",
        "ok": "#1f9d57", "err": "#d23b34", "muted": "#5a6172",
        "heading": "#1e4fa3", "code": "#9a6b00", "code_bg": "#eceef2",
        "sel_fg": "#ffffff", "curline": "#eaf0fb",
        "kw": "#8a2fb8", "builtin": "#2f6fe0", "num": "#b5530a",
        "deff": "#9a6b00", "str": "#2e8b3d", "com": "#8a93a3",
    },
    "contrast": {
        "label": "contraste élevé", "label_en": "high contrast",
        "bg": "#000000", "panel": "#0c0c0c", "editor": "#000000",
        "console": "#000000", "fg": "#ffffff", "accent": "#ffd400",
        "ok": "#42ff7a", "err": "#ff5b5b", "muted": "#cccccc",
        "heading": "#ffd400", "code": "#ffd400", "code_bg": "#0c0c0c",
        "sel_fg": "#000000", "curline": "#181818",
        "kw": "#ff9cf0", "builtin": "#7fd4ff", "num": "#ffb86b",
        "deff": "#ffd400", "str": "#8dff8d", "com": "#bbbbbb",
    },
    "dracula": {
        "label": "dracula", "label_en": "dracula",
        "bg": "#282a36", "panel": "#21222c", "editor": "#1e1f29",
        "console": "#191a21", "fg": "#f8f8f2", "accent": "#bd93f9",
        "ok": "#50fa7b", "err": "#ff5555", "muted": "#6272a4",
        "heading": "#ff79c6", "code": "#f1fa8c", "code_bg": "#1e1f29",
        "sel_fg": "#ffffff", "curline": "#343746",
        "kw": "#ff79c6", "builtin": "#8be9fd", "num": "#bd93f9",
        "deff": "#50fa7b", "str": "#f1fa8c", "com": "#6272a4",
    },
    "nord": {
        "label": "nord", "label_en": "nord",
        "bg": "#2e3440", "panel": "#3b4252", "editor": "#242933",
        "console": "#1e222b", "fg": "#eceff4", "accent": "#88c0d0",
        "ok": "#a3be8c", "err": "#bf616a", "muted": "#81a1c1",
        "heading": "#81a1c1", "code": "#ebcb8b", "code_bg": "#242933",
        "sel_fg": "#ffffff", "curline": "#3b4252",
        "kw": "#81a1c1", "builtin": "#88c0d0", "num": "#b48ead",
        "deff": "#8fbcbb", "str": "#a3be8c", "com": "#616e88",
    },
    "tokyo_night": {
        "label": "tokyo night", "label_en": "tokyo night",
        "bg": "#1a1b26", "panel": "#1f2335", "editor": "#16161e",
        "console": "#13141c", "fg": "#c0caf5", "accent": "#7aa2f7",
        "ok": "#9ece6a", "err": "#f7768e", "muted": "#565f89",
        "heading": "#bb9af7", "code": "#e0af68", "code_bg": "#16161e",
        "sel_fg": "#ffffff", "curline": "#292e42",
        "kw": "#bb9af7", "builtin": "#7dcfff", "num": "#ff9e64",
        "deff": "#7aa2f7", "str": "#9ece6a", "com": "#565f89",
    },
    "catppuccin": {
        "label": "catppuccin", "label_en": "catppuccin",
        "bg": "#24273a", "panel": "#1e2030", "editor": "#181926",
        "console": "#141520", "fg": "#cad3f5", "accent": "#c6a0f6",
        "ok": "#a6da95", "err": "#ed8796", "muted": "#8087a2",
        "heading": "#f5bde6", "code": "#eed49f", "code_bg": "#181926",
        "sel_fg": "#ffffff", "curline": "#363a4f",
        "kw": "#c6a0f6", "builtin": "#8aadf4", "num": "#f5a97f",
        "deff": "#8bd5ca", "str": "#a6da95", "com": "#6e738d",
    },
    "github_dark": {
        "label": "github dark", "label_en": "github dark",
        "bg": "#0d1117", "panel": "#161b22", "editor": "#090d13",
        "console": "#05080c", "fg": "#c9d1d9", "accent": "#58a6ff",
        "ok": "#3fb950", "err": "#f85149", "muted": "#8b949e",
        "heading": "#79c0ff", "code": "#d29922", "code_bg": "#090d13",
        "sel_fg": "#ffffff", "curline": "#1f242c",
        "kw": "#ff7b72", "builtin": "#ffa657", "num": "#79c0ff",
        "deff": "#d2a8ff", "str": "#a5d6ff", "com": "#8b949e",
    },
}
THEME_ORDER = ["rome", "colisee", "mediterranee", "light", "dark", "contrast", "tokyo_night", "catppuccin", "github_dark", "dracula", "nord"]


def melange(hex1, hex2, t):
    """Mélange deux couleurs #rrggbb (t=0 -> hex1, t=1 -> hex2)."""
    def comp(h):
        h = h.lstrip("#")
        return [int(h[i:i + 2], 16) for i in (0, 2, 4)]
    a, b = comp(hex1), comp(hex2)
    m = [round(a[i] + (b[i] - a[i]) * t) for i in range(3)]
    return "#{:02x}{:02x}{:02x}".format(*(max(0, min(255, v)) for v in m))


def eclaircir(hexc, t=0.12):
    return melange(hexc, "#ffffff", t)


def assombrir(hexc, t=0.15):
    return melange(hexc, "#000000", t)
