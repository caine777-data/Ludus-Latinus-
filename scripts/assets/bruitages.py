"""Prépare les bruitages générés par Gemini pour l'application mobile.

Source : Téléchargements/LATIN_LEARN/gemini ludus/<nom>.wav
Sortie : ludus_latinus_mobile/assets/audio/<nom>.wav

Chaîne : silence de début retiré (un son en retard sur le geste paraît cassé),
silence de fin coupé avec un fondu court, crête ramenée à -3 dB, WAV mono
44,1 kHz — le même format que les autres bruitages de l'app.

Usage : python scripts/assets/bruitages.py [nom ...]   (sans argument : tous ceux de SONS)
Dépendance d'outillage : pip install imageio-ffmpeg
"""

import re
import subprocess
import sys
from pathlib import Path

import imageio_ffmpeg

FF = imageio_ffmpeg.get_ffmpeg_exe()
SOURCE = Path(r"C:\Users\caine\Downloads\LATIN_LEARN\gemini ludus")
DEST = Path(__file__).resolve().parents[2] / "ludus_latinus_mobile" / "assets" / "audio"

# Fichier source Gemini -> fichier de l'app.
SONS = {
    "achat.wav": "achat.wav",
    "carte_obtenue.wav": "carte_obtenue.wav",
    "monde_termine.wav": "monde_termine.wav",
    "page.wav": "page.wav",
    "coup_epee.wav": "sword_clash.wav",   # remplace l'ancien choc d'épées
    # « foule.wav » n'est pas repris : 0,48 s, trop bref face à l'acclamation actuelle.
}

DEBUT = "silenceremove=start_periods=1:start_threshold=-40dB:start_silence=0.02"


def mesurer(fichier, filtre):
    """Durée et crête (dB) après le filtre de début, pour régler la fin et le gain."""
    sortie = subprocess.run(
        [FF, "-hide_banner", "-i", str(fichier), "-af",
         f"{filtre},volumedetect,silencedetect=n=-45dB:d=0.15", "-f", "null", "-"],
        capture_output=True, text=True, encoding="utf-8", errors="replace").stderr
    temps = re.findall(r"time=(\d+):(\d+):([\d.]+)", sortie)
    h, m, s = temps[-1]
    duree = int(h) * 3600 + int(m) * 60 + float(s)
    crete = float(re.search(r"max_volume: (-?[\d.]+) dB", sortie)[1])
    silences = [float(x) for x in re.findall(r"silence_start: (-?[\d.]+)", sortie)]
    return duree, crete, silences


def convertir(source, cible):
    src = SOURCE / source
    if not src.exists():
        print(f"[MANQUE] {source}")
        return
    duree, crete, silences = mesurer(src, DEBUT)
    fin = min(duree, next((s for s in silences if s > 0.05), duree) + 0.12)
    gain = -3.0 - crete
    DEST.mkdir(parents=True, exist_ok=True)
    subprocess.run(
        [FF, "-hide_banner", "-loglevel", "error", "-y", "-i", str(src), "-af",
         f"{DEBUT},atrim=0:{fin},asetpts=PTS-STARTPTS,"
         f"afade=t=out:st={max(0, fin - 0.08)}:d=0.08,volume={gain}dB",
         "-ac", "1", "-ar", "44100", "-c:a", "pcm_s16le", str(DEST / cible)],
        check=True,
    )
    print(f"[OK] {cible:20s} {fin:4.2f} s  gain {gain:+.1f} dB  {(DEST / cible).stat().st_size // 1024} Ko")


if __name__ == "__main__":
    demandes = sys.argv[1:]
    for source, cible in SONS.items():
        if not demandes or Path(source).stem in demandes:
            convertir(source, cible)
