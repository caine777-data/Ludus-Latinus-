"""
Gestionnaire et fenêtre de mise à jour automatique pour Ludus Latinus.
Vérifie les releases sur l'API GitHub et permet de télécharger directement le .exe.
"""

import json
import os
import re
import threading
import tkinter as tk
import urllib.error
import urllib.request
import webbrowser
from pathlib import Path
from tkinter import messagebox, simpledialog, ttk

from app.version import DEPOT, __version__


def _parse_version(v_str):
    """Extrait un tuple d'entiers (major, minor, patch) depuis une chaîne."""
    m = re.search(r"(\d+)\.(\d+)\.(\d+)", str(v_str))
    if m:
        return tuple(map(int, m.groups()))
    return (0, 0, 0)


def extraire_depot_info(url_ou_slug):
    """Renvoie (owner, repo) depuis une URL GitHub ou un slug owner/repo."""
    propre = str(url_ou_slug).strip().rstrip("/")
    if "github.com/" in propre:
        propre = propre.split("github.com/")[-1]
    parties = [p for p in propre.split("/") if p]
    if len(parties) >= 2:
        return parties[0], parties[1]
    return "caine777-data", "ludus-latinus"


class MiseAJourDialog(tk.Toplevel):
    """Fenêtre de vérification et téléchargement de mise à jour."""

    def __init__(self, master, app):
        super().__init__(master)
        self.app = app
        self.C = app.C
        self.title("🔄 Télécharger la Mise à Jour — Ludus Latinus")
        self.configure(bg=self.C["panel"])
        self.resizable(False, False)

        w, h = 620, 520
        sw = self.winfo_screenwidth()
        sh = self.winfo_screenheight()
        self.geometry(f"{w}x{h}+{(sw - w) // 2}+{(sh - h) // 2}")

        # Liseré d'or supérieur
        tk.Frame(self, bg=self.C["accent"], height=5).pack(fill=tk.X, side=tk.TOP)

        # En-tête
        hdr = tk.Frame(self, bg=self.C["panel"], padx=20, pady=12)
        hdr.pack(fill=tk.X)
        tk.Label(hdr, text="🔄 Mises à Jour de Rome",
                 font=(app.title_font.cget("family"), 18, "bold"),
                 bg=self.C["panel"], fg=self.C["accent"]).pack(anchor="w")
        tk.Label(hdr, text="Vérifie et télécharge la dernière version officielle de Ludus Latinus :",
                 font=(app.body.cget("family"), 10),
                 bg=self.C["panel"], fg=self.C["muted"]).pack(anchor="w")

        # Cadre central
        body = tk.Frame(self, bg=self.C["bg"], padx=18, pady=14)
        body.pack(fill=tk.BOTH, expand=True, padx=14, pady=(0, 10))

        # Carte Version Actuelle vs Disponible
        card = tk.Frame(body, bg=self.C["panel"], padx=14, pady=10, relief="groove", bd=1)
        card.pack(fill=tk.X, pady=(0, 10))

        v_box = tk.Frame(card, bg=self.C["panel"])
        v_box.pack(fill=tk.X)

        tk.Label(v_box, text=f"Version installée : v{__version__}",
                 font=(app.body.cget("family"), 11, "bold"),
                 bg=self.C["panel"], fg=self.C["fg"]).pack(side=tk.LEFT)

        self.lbl_distante = tk.Label(v_box, text="Dernière version : Recherche en cours...",
                                     font=(app.body.cget("family"), 11, "bold"),
                                     bg=self.C["panel"], fg=self.C["accent"])
        self.lbl_distante.pack(side=tk.RIGHT)

        # Statut textuel
        self.lbl_statut = tk.Label(card, text="⏳ Connexion aux serveurs GitHub...",
                                   font=(app.body.cget("family"), 10, "italic"),
                                   bg=self.C["panel"], fg=self.C["muted"])
        self.lbl_statut.pack(anchor="w", pady=(6, 0))

        # Zone Notes de Version / Changelog
        tk.Label(body, text="📜 Nouveautés & Notes de publication :",
                 font=(app.body.cget("family"), 10, "bold"),
                 bg=self.C["bg"], fg=self.C["fg"]).pack(anchor="w", pady=(0, 4))

        txt_frame = tk.Frame(body, bg=self.C["editor"])
        txt_frame.pack(fill=tk.BOTH, expand=True, pady=(0, 10))

        self.notes_txt = tk.Text(txt_frame, bg=self.C["editor"], fg=self.C["fg"],
                                 font=(app.code_font.cget("family"), 9),
                                 wrap="word", relief="flat", padx=8, pady=8, height=8)
        sb = ttk.Scrollbar(txt_frame, orient="vertical", command=self.notes_txt.yview)
        self.notes_txt.configure(yscrollcommand=sb.set)
        self.notes_txt.pack(side=tk.LEFT, fill=tk.BOTH, expand=True)
        sb.pack(side=tk.RIGHT, fill=tk.Y)
        self.notes_txt.insert("1.0", "Recherche des dernières annonces de mise à jour...")
        self.notes_txt.configure(state="disabled")

        # Barre de progression pour le téléchargement
        self.prog_frame = tk.Frame(body, bg=self.C["bg"])
        self.prog_bar = ttk.Progressbar(self.prog_frame, orient="horizontal", mode="determinate")
        self.prog_bar.pack(fill=tk.X, side=tk.TOP, pady=2)
        self.prog_lbl = tk.Label(self.prog_frame, text="", font=(app.body.cget("family"), 9),
                                 bg=self.C["bg"], fg=self.C["muted"])
        self.prog_lbl.pack(anchor="w")

        # Barre de boutons
        barre = tk.Frame(self, bg=self.C["panel"], padx=16, pady=10)
        barre.pack(fill=tk.X, side=tk.BOTTOM)

        self.btn_download = tk.Button(
            barre, text="⬇️ Télécharger l'Exécutable (.exe)",
            font=(app.body.cget("family"), 10, "bold"),
            bg="#27ae60", fg="#ffffff", activebackground="#219150",
            relief="flat", padx=12, pady=6, cursor="hand2",
            state="disabled", command=self._telecharger_exe
        )
        self.btn_download.pack(side=tk.LEFT, padx=4)

        self.btn_github = tk.Button(
            barre, text="🌐 Voir sur GitHub",
            font=(app.body.cget("family"), 10),
            bg=self.C["panel"], fg=self.C["fg"],
            relief="flat", padx=10, pady=6, cursor="hand2",
            command=self._ouvrir_page_github
        )
        self.btn_github.pack(side=tk.LEFT, padx=4)

        tk.Button(
            barre, text="⚙️ Dépôt",
            font=(app.body.cget("family"), 9),
            bg=self.C["panel"], fg=self.C["muted"],
            relief="flat", padx=8, pady=6, cursor="hand2",
            command=self._configurer_depot
        ).pack(side=tk.LEFT, padx=4)

        tk.Button(
            barre, text="Fermer",
            font=(app.body.cget("family"), 10),
            bg=self.C["panel"], fg=self.C["fg"],
            relief="flat", padx=10, pady=6, cursor="hand2",
            command=self.destroy
        ).pack(side=tk.RIGHT, padx=4)

        self.release_data = None
        self.exe_asset = None
        self.download_url = None

        # Lancer la vérification en tâche de fond (thread)
        threading.Thread(target=self._verifier_mise_a_jour_thread, daemon=True).start()

    def _get_repo_slug(self):
        saved = self.app.data.get("github_repo")
        if saved:
            return extraire_depot_info(saved)
        return extraire_depot_info(DEPOT)

    def _verifier_mise_a_jour_thread(self):
        owner, repo = self._get_repo_slug()
        api_url = f"https://api.github.com/repos/{owner}/{repo}/releases/latest"

        req = urllib.request.Request(
            api_url,
            headers={
                "User-Agent": "LudusLatinus-App",
                "Accept": "application/vnd.github.v3+json"
            }
        )

        try:
            with urllib.request.urlopen(req, timeout=8) as resp:
                data = json.loads(resp.read().decode("utf-8"))
                self.after(0, lambda: self._afficher_resultat(data, owner, repo))
        except urllib.error.HTTPError as exc:
            if exc.code == 404:
                msg = (f"Dépôt '{owner}/{repo}' non trouvé ou aucune Release publiée pour l'instant.\n\n"
                       "Lancez une publication via le bouton 'Run workflow' sur GitHub Actions !")
            elif exc.code == 403:
                msg = "Limite de requêtes GitHub atteinte temporairement. Réessayez dans quelques minutes."
            else:
                msg = f"Erreur GitHub HTTP {exc.code} : {exc.reason}"
            self.after(0, lambda: self._afficher_erreur(msg, owner, repo))
        except Exception as exc:
            err_msg = f"Erreur de connexion : {exc}"
            self.after(0, lambda m=err_msg: self._afficher_erreur(m, owner, repo))

    def _afficher_resultat(self, data, owner, repo):
        self.release_data = data
        tag = data.get("tag_name", "").lstrip("v")
        nom = data.get("name") or f"Version {tag}"
        body = data.get("body", "Aucune note de version fournie.")

        v_dist = _parse_version(tag)
        v_loc = _parse_version(__version__)

        self.lbl_distante.configure(text=f"Dernière version : v{tag}")

        # Recherche de l'asset .exe
        assets = data.get("assets", [])
        self.exe_asset = None
        for a in assets:
            if a.get("name", "").lower().endswith(".exe"):
                self.exe_asset = a
                break

        if self.exe_asset:
            self.download_url = self.exe_asset.get("browser_download_url")

        # Affichage notes
        self.notes_txt.configure(state="normal")
        self.notes_txt.delete("1.0", tk.END)
        self.notes_txt.insert("1.0", f"=== {nom} ===\n\n{body}")
        self.notes_txt.configure(state="disabled")

        if v_dist > v_loc:
            self.lbl_statut.configure(
                text="🎉 Une nouvelle version est disponible !",
                fg="#27ae60"
            )
            if self.download_url:
                self.btn_download.configure(state="normal")
            else:
                self.lbl_statut.configure(
                    text="🎉 Nouvelle version disponible (téléchargement manuel sur GitHub).",
                    fg="#e67e22"
                )
        else:
            self.lbl_statut.configure(
                text="✅ Vous disposez déjà de la version la plus récente de Ludus Latinus !",
                fg="#2980b9"
            )

    def _afficher_erreur(self, msg, owner, repo):
        self.lbl_distante.configure(text="Dernière version : Inconnue")
        self.lbl_statut.configure(text=f"⚠️ {msg}", fg="#e74c3c")
        self.notes_txt.configure(state="normal")
        self.notes_txt.delete("1.0", tk.END)
        self.notes_txt.insert(
            "1.0",
            f"Dépôt interrogé : https://github.com/{owner}/{repo}\n\n"
            f"Détails :\n{msg}\n\n"
            "Conseil : Si vous avez forké le projet sous votre propre compte GitHub, "
            "cliquez sur '⚙️ Dépôt' ci-dessous pour renseigner votre nom d'utilisateur."
        )
        self.notes_txt.configure(state="disabled")

    def _telecharger_exe(self):
        if not self.download_url:
            return

        self.btn_download.configure(state="disabled", text="Téléchargement en cours...")
        self.prog_frame.pack(fill=tk.X, pady=6)
        self.prog_bar["value"] = 0

        dest_dossier = Path.home() / "Downloads"
        if not dest_dossier.exists():
            dest_dossier = Path.home()
        dest_fichier = dest_dossier / (self.exe_asset.get("name") or "LudusLatinus.exe")

        threading.Thread(target=self._telechargement_thread, args=(self.download_url, dest_fichier), daemon=True).start()

    def _telechargement_thread(self, url, dest_fichier):
        try:
            req = urllib.request.Request(url, headers={"User-Agent": "LudusLatinus-App"})
            with urllib.request.urlopen(req, timeout=30) as resp:
                total_taille = resp.headers.get("Content-Length")
                total_taille = int(total_taille) if total_taille else 0
                taille_lue = 0
                bloc = 64 * 1024

                with open(dest_fichier, "wb") as f_out:
                    while True:
                        buffer = resp.read(bloc)
                        if not buffer:
                            break
                        f_out.write(buffer)
                        taille_lue += len(buffer)
                        if total_taille > 0:
                            pct = int(100 * taille_lue / total_taille)
                            msg = f"Téléchargement : {taille_lue // (1024*1024)} Mo / {total_taille // (1024*1024)} Mo ({pct}%)"
                        else:
                            pct = 50
                            msg = f"Téléchargement : {taille_lue // 1024} Ko..."
                        self.after(0, lambda p=pct, m=msg: self._maj_progression(p, m))

            self.after(0, lambda: self._telechargement_termine(dest_fichier))
        except Exception as exc:
            err_msg = str(exc)
            self.after(0, lambda m=err_msg: self._telechargement_echoue(m))

    def _maj_progression(self, pct, msg):
        self.prog_bar["value"] = pct
        self.prog_lbl.configure(text=msg)

    def _telechargement_termine(self, dest_fichier):
        self.prog_bar["value"] = 100
        self.prog_lbl.configure(text="✅ Téléchargement terminé avec succès !")
        self.btn_download.configure(state="normal", text="✅ Exécutable téléchargé !")
        reponse = messagebox.askyesno(
            "Mise à jour téléchargée !",
            f"La nouvelle version a été téléchargée dans :\n{dest_fichier}\n\n"
            "Voulez-vous ouvrir le dossier de téléchargement maintenant ?"
        )
        if reponse:
            try:
                os.startfile(dest_fichier.parent)
            except Exception:
                webbrowser.open(str(dest_fichier.parent.as_uri()))

    def _telechargement_echoue(self, err):
        self.prog_lbl.configure(text=f"❌ Échec : {err}")
        self.btn_download.configure(state="normal", text="⬇️ Réessayer le téléchargement")
        messagebox.showerror("Erreur de téléchargement", f"Impossible de télécharger le fichier :\n{err}")

    def _ouvrir_page_github(self):
        url = (self.release_data and self.release_data.get("html_url")) or DEPOT
        webbrowser.open(url)

    def _configurer_depot(self):
        owner, repo = self._get_repo_slug()
        nouveau = simpledialog.askstring(
            "Configurer le dépôt GitHub",
            "Entrez l'URL ou le chemin GitHub du projet (ex: mon-nom/latin-learn) :",
            initialvalue=f"{owner}/{repo}",
            parent=self
        )
        if nouveau and nouveau.strip():
            self.app.data["github_repo"] = nouveau.strip()
            self.lbl_statut.configure(text="⏳ Vérification du nouveau dépôt...", fg=self.C["muted"])
            threading.Thread(target=self._verifier_mise_a_jour_thread, daemon=True).start()
