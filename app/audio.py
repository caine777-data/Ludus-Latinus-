"""
Module audio pour Ludus Latinus.

Gère les effets sonores (SFX) et la prononciation vocale en latin.
Utilise uniquement la bibliothèque standard (winsound sur Windows)
et la synthèse vocale Windows via subprocess/thread asynchrone.
Zéro dépendance externe requise !
"""

import io
import math
import struct
import subprocess
import sys
import threading

_SOUND_ENABLED = True

try:
    import winsound
    _HAS_WINSOUND = True
except ImportError:
    winsound = None
    _HAS_WINSOUND = False


def set_sound_enabled(enabled: bool):
    global _SOUND_ENABLED
    _SOUND_ENABLED = bool(enabled)


def is_sound_enabled() -> bool:
    return _SOUND_ENABLED


def _generer_wav_tones(notes, sample_rate=22050, volume=0.5):
    """Génère un buffer WAV en mémoire à partir d'une liste de (freq_hz, duree_sec)."""
    total_samples = []
    for freq, duration in notes:
        n_samples = int(sample_rate * duration)
        for i in range(n_samples):
            t = float(i) / sample_rate
            env = 1.0
            attack = int(sample_rate * 0.01)
            decay = int(sample_rate * 0.05)
            if i < attack:
                env = i / max(1, attack)
            elif i > n_samples - decay:
                env = max(0.0, (n_samples - i) / max(1, decay))

            if freq > 0:
                val = math.sin(2.0 * math.pi * freq * t) * env * volume
            else:
                val = 0.0
            total_samples.append(int(val * 32767))

    buf = io.BytesIO()
    n = len(total_samples)
    data_size = n * 2
    buf.write(b'RIFF')
    buf.write(struct.pack('<I', 36 + data_size))
    buf.write(b'WAVE')
    buf.write(b'fmt ')
    buf.write(struct.pack('<I', 16))
    buf.write(struct.pack('<H', 1))
    buf.write(struct.pack('<H', 1))
    buf.write(struct.pack('<I', sample_rate))
    buf.write(struct.pack('<I', sample_rate * 2))
    buf.write(struct.pack('<H', 2))
    buf.write(struct.pack('<H', 16))
    buf.write(b'data')
    buf.write(struct.pack('<I', data_size))
    for s in total_samples:
        buf.write(struct.pack('<h', max(-32768, min(32767, s))))
    return buf.getvalue()


_CACHED_SOUNDS = {}

def _init_cache():
    if not _HAS_WINSOUND or _CACHED_SOUNDS:
        return
    try:
        # Son Succès : Arpège joyeux (Do5 - Mi5 - Sol5 - Do6)
        _CACHED_SOUNDS["correct"] = _generer_wav_tones([
            (523, 0.08), (659, 0.08), (784, 0.08), (1046, 0.22)
        ], volume=0.45)

        # Son Erreur : Deux notes douces boisées
        _CACHED_SOUNDS["wrong"] = _generer_wav_tones([
            (330, 0.12), (261, 0.22)
        ], volume=0.35)

        # Son Sesterce : Tintement cristallin
        _CACHED_SOUNDS["coin"] = _generer_wav_tones([
            (987, 0.06), (1318, 0.25)
        ], volume=0.40)

        # Son Victoire : Fanfare
        _CACHED_SOUNDS["victory"] = _generer_wav_tones([
            (523, 0.10), (523, 0.10), (523, 0.10), (659, 0.25),
            (587, 0.10), (659, 0.10), (784, 0.40)
        ], volume=0.50)

        # Son Montée de Niveau : Triomphe
        _CACHED_SOUNDS["level_up"] = _generer_wav_tones([
            (440, 0.10), (554, 0.10), (659, 0.15), (880, 0.35),
            (784, 0.10), (880, 0.45)
        ], volume=0.55)

        # Son Coup d'Épée / Slash : Tranchant vif
        _CACHED_SOUNDS["sword_slash"] = _generer_wav_tones([
            (1200, 0.03), (950, 0.04), (650, 0.05), (380, 0.07)
        ], volume=0.55)

        # Son Fanfare Tuba Romaine : Cuivres triomphants
        _CACHED_SOUNDS["tuba_fanfare"] = _generer_wav_tones([
            (392, 0.12), (523, 0.12), (659, 0.15), (784, 0.35),
            (659, 0.12), (784, 0.45)
        ], volume=0.55)

        # Son Cascade de Sesterces : Pluie de pièces
        _CACHED_SOUNDS["coin_cascade"] = _generer_wav_tones([
            (987, 0.04), (1174, 0.04), (1318, 0.05), (1568, 0.05),
            (1760, 0.06), (2093, 0.18)
        ], volume=0.45)

        # Son Claquement de Fouet / Char : Course
        _CACHED_SOUNDS["chariot_whip"] = _generer_wav_tones([
            (1800, 0.02), (450, 0.05), (220, 0.08)
        ], volume=0.50)
    except Exception:
        pass


def _play_bytes_async(data):
    if not _SOUND_ENABLED or not _HAS_WINSOUND or not data:
        return
    try:
        winsound.PlaySound(data, winsound.SND_MEMORY | winsound.SND_ASYNC)
    except Exception:
        pass


def play_correct():
    if not _SOUND_ENABLED:
        return
    _init_cache()
    _play_bytes_async(_CACHED_SOUNDS.get("correct"))


def play_wrong():
    if not _SOUND_ENABLED:
        return
    _init_cache()
    _play_bytes_async(_CACHED_SOUNDS.get("wrong"))


def play_coin():
    if not _SOUND_ENABLED:
        return
    _init_cache()
    _play_bytes_async(_CACHED_SOUNDS.get("coin"))


def play_victory():
    if not _SOUND_ENABLED:
        return
    _init_cache()
    _play_bytes_async(_CACHED_SOUNDS.get("victory"))


def play_level_up():
    if not _SOUND_ENABLED:
        return
    _init_cache()
    _play_bytes_async(_CACHED_SOUNDS.get("level_up"))


def play_sword_slash():
    """Bruit d'épée / coup d'arène."""
    if not _SOUND_ENABLED:
        return
    _init_cache()
    _play_bytes_async(_CACHED_SOUNDS.get("sword_slash"))


def play_tuba_fanfare():
    """Trompette romaine / triomphe."""
    if not _SOUND_ENABLED:
        return
    _init_cache()
    _play_bytes_async(_CACHED_SOUNDS.get("tuba_fanfare"))


def play_fanfare():
    """Alias pour triomphe d'arène."""
    play_tuba_fanfare()


def play_coin_cascade():
    """Cascade de sesterces lors d'une victoire."""
    if not _SOUND_ENABLED:
        return
    _init_cache()
    _play_bytes_async(_CACHED_SOUNDS.get("coin_cascade"))


def play_chariot_whip():
    """Claquement de fouet pour le char."""
    if not _SOUND_ENABLED:
        return
    _init_cache()
    _play_bytes_async(_CACHED_SOUNDS.get("chariot_whip"))


def speak_latin(text: str):
    """Prononce un mot ou une phrase en latin à voix haute en arrière-plan."""
    if not _SOUND_ENABLED or not text:
        return
    texte_clean = text.replace('"', ' ').replace("'", " ").strip()

    def _parler():
        try:
            if sys.platform == "win32":
                ps_script = (
                    f'$speak = New-Object -ComObject SAPI.SpVoice; '
                    f'$speak.Rate = -1; '
                    f'$speak.Speak("{texte_clean}")'
                )
                startupinfo = subprocess.STARTUPINFO()
                startupinfo.dwFlags |= subprocess.STARTF_USESHOWWINDOW
                subprocess.run(
                    ["powershell", "-NoProfile", "-Command", ps_script],
                    startupinfo=startupinfo,
                    creationflags=subprocess.CREATE_NO_WINDOW,
                    timeout=6
                )
        except Exception:
            pass

    threading.Thread(target=_parler, daemon=True).start()
