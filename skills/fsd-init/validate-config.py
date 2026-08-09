#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Preflight validator untuk doc-fsd.config.yml.

Deterministik: memeriksa skema config SEBELUM /fsd-doc atau /fsd-convert
menulis artefak apa pun. Dipanggil oleh fsd-init (saat config ditulis) dan
opsional oleh fsd-doc/fsd-convert (defense-in-depth bila config diedit tangan
sesudahnya). Gagal (exit 1) mencetak SEMUA pelanggaran per field, bukan cuma
yang pertama, dan tidak pernah menulis/mengubah file apa pun.

Jalankan:
    py validate-config.py <path/doc-fsd.config.yml>
    py validate-config.py                # cari config otomatis (naik dari cwd)
Butuh: pip install pyyaml
"""
import os
import re
import sys

SLUG_RE = re.compile(r"^[a-z0-9]+(-[a-z0-9]+)*$")
HEX_RE = re.compile(r"^#[0-9A-Fa-f]{6}$")
VIEWPORT_RE = re.compile(r"^\d+x\d+$")
CREDENTIAL_ROOT = "docs/tasks/credentialRoles/"


def _find_config():
    d = os.getcwd()
    while True:
        for cand in (os.path.join(d, "docs", "tasks", "fsd", "doc-fsd.config.yml"),
                     os.path.join(d, "doc-fsd.config.yml")):
            if os.path.isfile(cand):
                return cand
        parent = os.path.dirname(d)
        if parent == d:
            return None
        d = parent


def _is_unsafe_relative_path(path):
    """True bila path absolut, drive letter Windows, atau memuat segmen '..'."""
    if not path:
        return True
    norm = path.replace("\\", "/")
    if norm.startswith("/") or re.match(r"^[a-zA-Z]:", norm):
        return True
    parts = norm.split("/")
    if ".." in parts:
        return True
    return False


def validate(data):
    """Kembalikan list string pelanggaran (kosong = valid)."""
    errors = []

    project = data.get("project")
    if not isinstance(project, dict) or not project.get("name"):
        errors.append("project.name: wajib diisi.")

    modules = data.get("modules")
    if not isinstance(modules, list) or not modules:
        errors.append("modules[]: wajib berisi minimal satu role/portal.")
        modules = []

    seen_slugs = {}
    for i, m in enumerate(modules):
        where = f"modules[{i}]"
        if not isinstance(m, dict):
            errors.append(f"{where}: harus berupa objek dengan slug/title/portal/guard.")
            continue

        slug = m.get("slug")
        if not slug or not isinstance(slug, str):
            errors.append(f"{where}.slug: wajib diisi.")
        elif not SLUG_RE.match(slug):
            errors.append(
                f"{where}.slug ('{slug}'): harus URL-slug-like huruf kecil/angka "
                "dipisah satu tanda hubung (mis. 'admin-ta'), tanpa '--', spasi, "
                "atau huruf besar."
            )
        else:
            key = slug.lower()
            if key in seen_slugs:
                errors.append(
                    f"{where}.slug ('{slug}'): duplikat dengan modules[{seen_slugs[key]}]."
                )
            else:
                seen_slugs[key] = i

        if m.get("portal") not in ("backend", "frontend"):
            errors.append(f"{where}.portal: harus 'backend' atau 'frontend'.")

        if not m.get("title"):
            errors.append(f"{where}.title: wajib diisi.")
        if not m.get("guard"):
            errors.append(f"{where}.guard: wajib diisi.")

        cred = m.get("credentials")
        if cred:
            norm = cred.replace("\\", "/")
            if _is_unsafe_relative_path(cred):
                errors.append(
                    f"{where}.credentials ('{cred}'): harus path relatif tanpa "
                    "'..' dan bukan path absolut/drive letter."
                )
            elif not norm.startswith(CREDENTIAL_ROOT):
                errors.append(
                    f"{where}.credentials ('{cred}'): harus berada di dalam root "
                    f"kredensial yang disetujui ('{CREDENTIAL_ROOT}')."
                )

    output = data.get("output") or {}
    for key in ("documents_dir", "diagrams_dir", "screenshots_dir", "docx_dir"):
        val = output.get(key)
        if not val:
            errors.append(f"output.{key}: wajib diisi.")
        elif _is_unsafe_relative_path(val):
            errors.append(
                f"output.{key} ('{val}'): harus path relatif tanpa '..' dan "
                "bukan path absolut/drive letter."
            )
    pattern = output.get("docx_name_pattern")
    if pattern and "{Modul}" not in pattern:
        errors.append(
            f"output.docx_name_pattern ('{pattern}'): wajib memuat placeholder "
            "'{Modul}'."
        )

    brand = data.get("brand") or {}
    for key in ("color_primary", "color_primary_dark", "color_accent"):
        val = brand.get(key)
        if val and not HEX_RE.match(str(val)):
            errors.append(
                f"brand.{key} ('{val}'): harus format warna heksadesimal 6 "
                "digit, mis. '#005BAA'."
            )
    logo = brand.get("logo")
    if logo and _is_unsafe_relative_path(logo):
        errors.append(
            f"brand.logo ('{logo}'): harus path relatif tanpa '..' dan bukan "
            "path absolut/drive letter."
        )

    docx = data.get("docx") or {}
    ref = docx.get("reference")
    if ref and _is_unsafe_relative_path(ref):
        errors.append(
            f"docx.reference ('{ref}'): harus path relatif tanpa '..' dan "
            "bukan path absolut/drive letter."
        )

    runtime = data.get("runtime") or {}
    viewport = runtime.get("viewport")
    if viewport and not VIEWPORT_RE.match(str(viewport)):
        errors.append(
            f"runtime.viewport ('{viewport}'): harus format '<lebar>x<tinggi>', "
            "mis. '1440x900'."
        )

    return errors


def main():
    path = sys.argv[1] if len(sys.argv) > 1 else _find_config()
    if not path or not os.path.isfile(path):
        print("[x] doc-fsd.config.yml tidak ditemukan.", file=sys.stderr)
        return 1

    try:
        import yaml
    except ImportError:
        print("[x] PyYAML belum terpasang (pip install pyyaml) — validasi dilewati.",
              file=sys.stderr)
        return 1

    try:
        with open(path, "r", encoding="utf-8") as f:
            data = yaml.safe_load(f) or {}
    except Exception as e:  # noqa: BLE001
        print(f"[x] Gagal membaca/parse {path}: {e}", file=sys.stderr)
        return 1

    errors = validate(data)
    if errors:
        print(f"[x] {len(errors)} pelanggaran skema di {path}:", file=sys.stderr)
        for e in errors:
            print(f"    - {e}", file=sys.stderr)
        return 1

    print(f"[ok] Config valid: {path}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
