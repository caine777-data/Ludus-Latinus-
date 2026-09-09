"""
Module Tabularium — Compte Citoyen & Sauvegarde Cloud pour Ludus Latinus.

Gère l'authentification (email/mot de passe sécurisé par PBKDF2-SHA256),
le statut citoyen (invité vs enregistré), la synchronisation cloud sécurisée
et la « Tessera Hospitalis » (code de transfert express sans email entre PC et mobile).
"""

import tkinter as tk
from datetime import datetime
from tkinter import filedialog, messagebox, ttk

from app import audio
from app import progress as prog


class CompteDialog(tk.Toplevel):
    """Fenêtre modale de gestion du Compte Citoyen & Sauvegarde Cloud."""

    def __init__(self, master, app):
        super().__init__(master)
        self.app = app
        self.C = app.C
        self.title("🏛️ Tabularium de Rome — Compte Citoyen & Cloud")
        self.configure(bg=self.C["panel"])
        self.resizable(False, False)

        w, h = 680, 560
        sw = self.winfo_screenwidth()
        sh = self.winfo_screenheight()
        self.geometry(f"{w}x{h}+{(sw - w) // 2}+{(sh - h) // 2}")

        self.transient(master)
        self.grab_set()

        # Ruban d'or supérieur
        tk.Frame(self, bg=self.C["accent"], height=6).pack(fill=tk.X, side=tk.TOP)

        # En-tête
        hdr = tk.Frame(self, bg=self.C["panel"], padx=24, pady=14)
        hdr.pack(fill=tk.X)

        tk.Label(
            hdr,
            text="🏛️ Tabularium & Archives Impériales",
            font=(app.title_font.cget("family"), 18, "bold"),
            bg=self.C["panel"],
            fg=self.C["accent"]
        ).pack(anchor="w")

        tk.Label(
            hdr,
            text="Sauvegarde ton épopée dans le Cloud pour synchroniser ta progression sur PC et Mobile !",
            font=(app.body.cget("family"), 10),
            bg=self.C["panel"],
            fg=self.C["muted"]
        ).pack(anchor="w", pady=(2, 0))

        # Système d'onglets (Notebook)
        style = ttk.Style(self)
        style.configure("Tabularium.TNotebook", background=self.C["panel"], borderwidth=0)
        style.configure("Tabularium.TNotebook.Tab", font=(app.body.cget("family"), 10, "bold"), padding=[14, 6])

        self.nb = ttk.Notebook(self, style="Tabularium.TNotebook")
        self.nb.pack(fill=tk.BOTH, expand=True, padx=20, pady=8)

        self.tab_compte = tk.Frame(self.nb, bg=self.C["panel"], padx=16, pady=14)
        self.tab_cloud = tk.Frame(self.nb, bg=self.C["panel"], padx=16, pady=14)
        self.tab_tessera = tk.Frame(self.nb, bg=self.C["panel"], padx=16, pady=14)

        self.nb.add(self.tab_compte, text="📜 Mon Compte")
        self.nb.add(self.tab_cloud, text="☁️ Synchronisation")
        self.nb.add(self.tab_tessera, text="🏷️ Transfert Express")

        self._build_tab_compte()
        self._build_tab_cloud()
        self._build_tab_tessera()

        # Barre inférieure
        bottom_bar = tk.Frame(self, bg=self.C["panel"], padx=20, pady=12)
        bottom_bar.pack(fill=tk.X, side=tk.BOTTOM)

        self.lbl_status = tk.Label(
            bottom_bar,
            text="",
            font=(app.body.cget("family"), 9, "italic"),
            bg=self.C["panel"],
            fg=self.C["accent"]
        )
        self.lbl_status.pack(side=tk.LEFT)

        btn_close = ttk.Button(bottom_bar, text="Fermer", command=self.destroy)
        btn_close.pack(side=tk.RIGHT)

        self.lift()
        self.focus_force()

    # -----------------------------------------------------------------------
    # ONGLET 1 : MON COMPTE CITOYEN
    # -----------------------------------------------------------------------
    def _build_tab_compte(self):
        for w in self.tab_compte.winfo_children():
            w.destroy()

        data = self.app.data
        compte = prog.get_compte(data)
        est_enregistre = prog.est_compte_enregistre(data)

        if est_enregistre:
            # Profil connecté
            card = tk.Frame(self.tab_compte, bg=self.C["editor"], padx=20, pady=16, highlightthickness=2,
                            highlightbackground=self.C["accent"])
            card.pack(fill=tk.X, pady=8)

            tk.Label(
                card,
                text=f"👑 Citoyen Enregistré : {compte.get('pseudo', 'Marcus')}",
                font=(self.app.title_font.cget("family"), 14, "bold"),
                bg=self.C["editor"],
                fg=self.C["accent"]
            ).pack(anchor="w")

            tk.Label(
                card,
                text=f"📧 Courriel lié : {compte.get('email')}",
                font=(self.app.body.cget("family"), 10),
                bg=self.C["editor"],
                fg=self.C["fg"]
            ).pack(anchor="w", pady=(4, 2))

            derniere_sync = compte.get("derniere_sync") or "Jamais"
            tk.Label(
                card,
                text=f"🕒 Dernière synchronisation : {derniere_sync}",
                font=(self.app.body.cget("family"), 9),
                bg=self.C["editor"],
                fg=self.C["muted"]
            ).pack(anchor="w", pady=(2, 12))

            btn_box = tk.Frame(card, bg=self.C["editor"])
            btn_box.pack(fill=tk.X)

            tk.Button(
                btn_box,
                text="🔄 Synchroniser Maintenant",
                font=(self.app.body.cget("family"), 10, "bold"),
                bg="#d4af37", fg="#1a1409",
                activebackground="#f3e5ab",
                padx=14, pady=6, relief="flat", cursor="hand2",
                command=self._synchroniser_maintenant
            ).pack(side=tk.LEFT, padx=(0, 10))

            tk.Button(
                btn_box,
                text="Déconnexion",
                font=(self.app.body.cget("family"), 9),
                bg="#8b2500", fg="#ffffff",
                activebackground="#a83200",
                padx=10, pady=5, relief="flat", cursor="hand2",
                command=self._deconnecter
            ).pack(side=tk.RIGHT)
        else:
            # Mode Invité / Formulaire Inscription & Connexion
            info_inv = tk.Frame(self.tab_compte, bg=self.C["editor"], padx=14, pady=10, relief="groove", bd=1)
            info_inv.pack(fill=tk.X, pady=(0, 12))

            tk.Label(
                info_inv,
                text="🛡️ Tu joues actuellement en mode Invité (sauvegarde locale uniquement).",
                font=(self.app.body.cget("family"), 9, "bold"),
                bg=self.C["editor"],
                fg=self.C["accent"]
            ).pack(anchor="w")
            tk.Label(
                info_inv,
                text="Crée ton Compte Citoyen pour sauvegarder tes sesterces et retrouver ton niveau sur mobile !",
                font=(self.app.body.cget("family"), 9),
                bg=self.C["editor"],
                fg=self.C["muted"]
            ).pack(anchor="w")

            form = tk.Frame(self.tab_compte, bg=self.C["panel"])
            form.pack(fill=tk.X, pady=4)

            # Email
            tk.Label(form, text="Adresse Courriel :", font=(self.app.body.cget("family"), 9, "bold"),
                     bg=self.C["panel"], fg=self.C["fg"]).pack(anchor="w", pady=(4, 2))
            self.ent_email = ttk.Entry(form, width=45)
            self.ent_email.pack(anchor="w")

            # Pseudo
            tk.Label(form, text="Nom de Héros / Citoyen :", font=(self.app.body.cget("family"), 9, "bold"),
                     bg=self.C["panel"], fg=self.C["fg"]).pack(anchor="w", pady=(8, 2))
            self.ent_pseudo = ttk.Entry(form, width=45)
            self.ent_pseudo.insert(0, self.app.data.get("nom_heros", "Marcus"))
            self.ent_pseudo.pack(anchor="w")

            # Mot de passe
            tk.Label(form, text="Mot de passe :", font=(self.app.body.cget("family"), 9, "bold"),
                     bg=self.C["panel"], fg=self.C["fg"]).pack(anchor="w", pady=(8, 2))
            self.ent_mdp = ttk.Entry(form, width=45, show="•")
            self.ent_mdp.pack(anchor="w")

            # Boutons Actions
            btn_row = tk.Frame(self.tab_compte, bg=self.C["panel"])
            btn_row.pack(fill=tk.X, pady=16)

            tk.Button(
                btn_row,
                text="➕ Créer mon Compte Citoyen",
                font=(self.app.body.cget("family"), 10, "bold"),
                bg="#d4af37", fg="#1a1409",
                activebackground="#f3e5ab",
                padx=14, pady=6, relief="flat", cursor="hand2",
                command=self._creer_compte
            ).pack(side=tk.LEFT, padx=(0, 10))

            tk.Button(
                btn_row,
                text="🔑 Se Connecter",
                font=(self.app.body.cget("family"), 10),
                bg=self.C["editor"], fg=self.C["fg"],
                activebackground=self.C["panel"],
                padx=12, pady=5, relief="solid", bd=1, cursor="hand2",
                command=self._se_connecter
            ).pack(side=tk.LEFT)

    # -----------------------------------------------------------------------
    # ONGLET 2 : SYNCHRONISATION CLOUD
    # -----------------------------------------------------------------------
    def _build_tab_cloud(self):
        for w in self.tab_cloud.winfo_children():
            w.destroy()

        card = tk.Frame(self.tab_cloud, bg=self.C["editor"], padx=20, pady=16, relief="groove", bd=1)
        card.pack(fill=tk.BOTH, expand=True)

        tk.Label(
            card,
            text="☁️ Passerelle Cloud des Archives Impériales",
            font=(self.app.title_font.cget("family"), 13, "bold"),
            bg=self.C["editor"],
            fg=self.C["accent"]
        ).pack(anchor="w")

        tk.Label(
            card,
            text="Cette passerelle synchronise de façon bidirectionnelle :\n"
                 "• Tes mondes conquis, exercices résolus et leçons validées\n"
                 "• Tes sesterces, cartes mythologiques et trophées de Rome\n"
                 "• Tes monuments restaurés sur le Forum Romain et ta série (Streak)\n"
                 "• Compatible avec le futur client Android / iOS et PC !",
            font=(self.app.body.cget("family"), 9),
            justify=tk.LEFT,
            bg=self.C["editor"],
            fg=self.C["fg"]
        ).pack(anchor="w", pady=(10, 14))

        sync_box = tk.Frame(card, bg=self.C["editor"])
        sync_box.pack(fill=tk.X, pady=8)

        tk.Button(
            sync_box,
            text="⚡ Lancer la Synchronisation Cloud",
            font=(self.app.body.cget("family"), 10, "bold"),
            bg="#2e6f40", fg="#ffffff",
            activebackground="#3e8f54",
            padx=16, pady=7, relief="flat", cursor="hand2",
            command=self._synchroniser_maintenant
        ).pack(side=tk.LEFT)

    # -----------------------------------------------------------------------
    # ONGLET 3 : TESSERA HOSPITALIS & EXPORT/IMPORT
    # -----------------------------------------------------------------------
    def _build_tab_tessera(self):
        for w in self.tab_tessera.winfo_children():
            w.destroy()

        data = self.app.data
        compte = prog.get_compte(data)
        tessera = compte.get("tessera") or prog.generer_tessera_hospitalis(data)

        tk.Label(
            self.tab_tessera,
            text="🏷️ Tessera Hospitalis (Jeton de Transfert Express)",
            font=(self.app.title_font.cget("family"), 12, "bold"),
            bg=self.C["panel"],
            fg=self.C["accent"]
        ).pack(anchor="w")

        tk.Label(
            self.tab_tessera,
            text="Chez les Romains, la Tessera Hospitalis scellait un pacte d'amitié indestructible.\n"
                 "Ce code permet de transférer ta sauvegarde sur ton téléphone ou un autre ordinateur sans email !",
            font=(self.app.body.cget("family"), 9),
            bg=self.C["panel"],
            fg=self.C["muted"]
        ).pack(anchor="w", pady=(2, 10))

        code_card = tk.Frame(self.tab_tessera, bg=self.C["editor"], padx=14, pady=12, relief="solid", bd=1)
        code_card.pack(fill=tk.X, pady=4)

        self.lbl_tessera = tk.Label(
            code_card,
            text=tessera,
            font=("Courier New", 18, "bold"),
            bg=self.C["editor"],
            fg=self.C["accent"]
        )
        self.lbl_tessera.pack(side=tk.LEFT, padx=10)

        tk.Button(
            code_card,
            text="📋 Copier",
            font=(self.app.body.cget("family"), 9),
            command=self._copier_tessera
        ).pack(side=tk.RIGHT, padx=6)

        tk.Button(
            code_card,
            text="🔄 Renouveler",
            font=(self.app.body.cget("family"), 9),
            command=self._renouveler_tessera
        ).pack(side=tk.RIGHT)

        # Fichier externe Export/Import
        tk.Label(
            self.tab_tessera,
            text="💾 Sauvegarde Manuelle par Fichier :",
            font=(self.app.body.cget("family"), 10, "bold"),
            bg=self.C["panel"],
            fg=self.C["fg"]
        ).pack(anchor="w", pady=(14, 4))

        file_row = tk.Frame(self.tab_tessera, bg=self.C["panel"])
        file_row.pack(fill=tk.X)

        tk.Button(
            file_row,
            text="📤 Exporter mon Voyage (.json)",
            font=(self.app.body.cget("family"), 9),
            command=self._exporter_fichier
        ).pack(side=tk.LEFT, padx=(0, 10))

        tk.Button(
            file_row,
            text="📥 Importer un Fichier (.json)",
            font=(self.app.body.cget("family"), 9),
            command=self._importer_fichier
        ).pack(side=tk.LEFT)

    # -----------------------------------------------------------------------
    # ACTIONS
    # -----------------------------------------------------------------------
    def _creer_compte(self):
        email = self.ent_email.get()
        pseudo = self.ent_pseudo.get()
        mdp = self.ent_mdp.get()

        succes, msg = prog.enregistrer_compte(self.app.data, email, pseudo, mdp)
        if succes:
            audio.play_victory()
            messagebox.showinfo("Tabularium", f"Félicitations, Citoyen {pseudo} !\nTon compte est désormais actif.")
            self._build_tab_compte()
            self._build_tab_tessera()
        else:
            audio.play_wrong()
            messagebox.showwarning("Tabularium", msg)

    def _se_connecter(self):
        email = self.ent_email.get()
        mdp = self.ent_mdp.get()

        succes, msg = prog.valider_connexion_compte(self.app.data, email, mdp)
        if succes:
            audio.play_correct()
            messagebox.showinfo("Tabularium", msg)
            self._build_tab_compte()
        else:
            audio.play_wrong()
            messagebox.showwarning("Tabularium", msg)

    def _deconnecter(self):
        if messagebox.askyesno("Tabularium", "Es-tu sûr de vouloir te déconnecter de ce profil ?"):
            prog.deconnecter_compte(self.app.data)
            audio.play_coin()
            self._build_tab_compte()

    def _synchroniser_maintenant(self):
        succes, msg = prog.synchroniser_cloud_simule(self.app.data)
        if succes:
            audio.play_correct()
            self.lbl_status.configure(text=f"✓ {msg}")
            self._build_tab_compte()
            messagebox.showinfo("Synchronisation Cloud", "✓ Tes données sont parfaitement synchronisées avec les archives impériales !")

    def _copier_tessera(self):
        code = self.lbl_tessera.cget("text")
        self.clipboard_clear()
        self.clipboard_append(code)
        audio.play_coin()
        self.lbl_status.configure(text="✓ Code copié dans le presse-papier !")

    def _renouveler_tessera(self):
        nouveau = prog.generer_tessera_hospitalis(self.app.data)
        self.lbl_tessera.configure(text=nouveau)
        audio.play_coin()
        self.lbl_status.configure(text="✓ Nouvelle Tessera Hospitalis générée !")

    def _exporter_fichier(self):
        chemin = filedialog.asksaveasfilename(
            parent=self,
            defaultextension=".json",
            filetypes=[("Sauvegarde Latin Learn", "*.json")],
            initialfile=f"ludus_latinus_sauvegarde_{datetime.now().strftime('%Y%m%d')}.json"
        )
        if chemin:
            try:
                with open(chemin, "w", encoding="utf-8") as f:
                    f.write(prog.exporter_json(self.app.data))
                audio.play_correct()
                messagebox.showinfo("Exportation", "✓ Sauvegarde exportée avec succès !")
            except Exception as e:
                messagebox.showerror("Erreur", f"Échec de l'exportation : {e}")

    def _importer_fichier(self):
        chemin = filedialog.askopenfilename(
            parent=self,
            filetypes=[("Sauvegarde Latin Learn", "*.json")]
        )
        if chemin:
            try:
                with open(chemin, encoding="utf-8") as f:
                    data = prog.importer_json(f.read())
                self.app.data.update(data)
                prog.save_progress(self.app.data)
                audio.play_victory()
                messagebox.showinfo("Importation", "✓ Progression importée avec succès ! Les nouveaux mondes et sesterces sont appliqués.")
                self.destroy()
                if hasattr(self.app, "rafraichir_tout"):
                    self.app.rafraichir_tout()
            except Exception as e:
                messagebox.showerror("Erreur", f"Fichier corrompu ou invalide : {e}")
