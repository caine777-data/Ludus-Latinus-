# -*- mode: python ; coding: utf-8 -*-
import os
import sys

try:
    from app.version import __version__
except Exception:
    __version__ = '1.0.1'

icon_file = None
if sys.platform == 'win32' and os.path.exists('assets/icon.ico'):
    icon_file = 'assets/icon.ico'
elif sys.platform == 'darwin' and os.path.exists('assets/icon.icns'):
    icon_file = 'assets/icon.icns'
elif os.path.exists('assets/icon.ico'):
    icon_file = 'assets/icon.ico'

a = Analysis(
    ['main.py'],
    pathex=[],
    binaries=[],
    datas=[
        ('assets', 'assets'),
    ],
    hiddenimports=[],
    hookspath=[],
    hooksconfig={},
    runtime_hooks=[],
    excludes=[],
    noarchive=False,
    optimize=0,
)
pyz = PYZ(a.pure)

exe = EXE(
    pyz,
    a.scripts,
    a.binaries,
    a.datas,
    [],
    name='LudusLatinus',
    debug=False,
    bootloader_ignore_signals=False,
    strip=False,
    upx=True,
    upx_exclude=[],
    runtime_tmpdir=None,
    console=False,
    disable_windowed_traceback=False,
    argv_emulation=False,
    target_arch=None,
    codesign_identity=None,
    entitlements_file=None,
    icon=icon_file,
)

if sys.platform == 'darwin':
    app = BUNDLE(
        exe,
        name='LudusLatinus.app',
        icon='assets/icon.icns' if os.path.exists('assets/icon.icns') else None,
        bundle_identifier='com.luduslatinus.app',
        info_plist={
            'CFBundleName': 'LudusLatinus',
            'CFBundleDisplayName': 'Ludus Latinus',
            'CFBundleIdentifier': 'com.luduslatinus.app',
            'CFBundlePackageType': 'APPL',
            'CFBundleShortVersionString': __version__,
            'NSHighResolutionCapable': 'True',
        },
    )
