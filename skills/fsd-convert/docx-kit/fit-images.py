#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Rapikan UKURAN TAMPILAN & perataan GAMBAR pada .docx hasil Pandoc.

Masalah: diagram Mermaid dirender pada skala tinggi (mmdc -s 3) agar tajam saat
diperlebar. PNG-nya jadi besar (piksel), dan Pandoc meng-embed pada ukuran native
-> Word menampilkannya sebesar mungkin sehingga SATU gambar memenuhi SATU halaman
dan tingginya tidak proporsional.

Solusi: batasi hanya UKURAN TAMPILAN (kotak wp:extent) — bukan resolusi PNG-nya —
supaya lebar tak melebihi area cetak dan tinggi tak melebihi sebagian halaman.
Rasio aspek dipertahankan; gambar tak pernah diperbesar. Karena piksel PNG utuh,
gambar tetap TAJAM saat pembaca memperlebarnya kembali di Word/Google Docs.
Sekaligus memusatkan (center) paragraf yang memuat gambar.

Dipanggil otomatis oleh build-docx.ps1 SETELAH Pandoc. Mengubah file di tempat.

    py fit-images.py <file.docx> [--max-height-frac F] [--max-width-in W] [--max-height-in H]

--max-height-frac : batas tinggi = F x tinggi area cetak (baku 0.5 -> maksimal
                    setengah halaman, jadi tak pernah 1 gambar per halaman).
--max-width-in    : override batas lebar (inci). Baku = lebar area cetak halaman.
--max-height-in   : override batas tinggi (inci). Menang atas --max-height-frac.

Butuh: pip install python-docx   (bila belum ada -> skrip skip dengan pesan; .docx
       tetap valid, gambar hanya belum dirapikan ukurannya).
"""

import sys

DEFAULT_MAX_HEIGHT_FRAC = 0.5   # maksimal setengah tinggi area cetak


def _parse_args(argv):
    opts = {"docx": None, "frac": DEFAULT_MAX_HEIGHT_FRAC,
            "max_w_in": None, "max_h_in": None}
    i = 0
    while i < len(argv):
        a = argv[i]
        if a == "--max-height-frac":
            i += 1
            if i < len(argv):
                opts["frac"] = float(argv[i])
        elif a == "--max-width-in":
            i += 1
            if i < len(argv):
                opts["max_w_in"] = float(argv[i])
        elif a == "--max-height-in":
            i += 1
            if i < len(argv):
                opts["max_h_in"] = float(argv[i])
        elif opts["docx"] is None:
            opts["docx"] = a
        i += 1
    return opts


def fit(opts):
    try:
        from docx import Document
        from docx.shared import Emu, Inches
        from docx.enum.text import WD_ALIGN_PARAGRAPH
        from docx.enum.shape import WD_INLINE_SHAPE
        from docx.oxml.ns import qn
    except ImportError:
        print("[skip] python-docx belum terpasang (pip install python-docx) - "
              "ukuran gambar .docx tidak dirapikan (dokumen tetap valid).")
        return 0

    doc = Document(opts["docx"])

    sec = doc.sections[0]
    content_w = sec.page_width - sec.left_margin - sec.right_margin
    printable_h = sec.page_height - sec.top_margin - sec.bottom_margin

    # Aritmetika Length python-docx mengembalikan int EMU mentah; bungkus lagi ke
    # Emu agar punya .inches untuk ringkasan & pembanding yang konsisten.
    max_w = Inches(opts["max_w_in"]) if opts["max_w_in"] else Emu(int(content_w))
    if opts["max_h_in"]:
        max_h = Inches(opts["max_h_in"])
    else:
        max_h = Emu(int(printable_h * opts["frac"]))

    # Pusatkan tiap paragraf yang memuat gambar (jaga-jaga bila gaya "Figure"
    # tak diterapkan Pandoc pada paragraf tertentu).
    drawing = qn("w:drawing")
    n_centered = 0
    for para in doc.paragraphs:
        if para._p.findall(".//" + drawing):
            para.alignment = WD_ALIGN_PARAGRAPH.CENTER
            n_centered += 1

    n_fit = 0
    for shape in doc.inline_shapes:
        if shape.type not in (WD_INLINE_SHAPE.PICTURE,
                              WD_INLINE_SHAPE.LINKED_PICTURE):
            continue
        w = int(shape.width)
        h = int(shape.height)
        if w <= 0 or h <= 0:
            continue
        # skala <= 1 (hanya perkecil, jangan perbesar), jaga rasio aspek.
        scale = min(1.0, max_w / w, max_h / h)
        if scale < 1.0:
            shape.width = Emu(int(w * scale))
            shape.height = Emu(int(h * scale))
            n_fit += 1

    doc.save(opts["docx"])
    print(f"[ok] Gambar dirapikan: {n_fit} diperkecil agar proporsional, "
          f"{n_centered} paragraf gambar dipusatkan "
          f"(maks {max_w.inches:.2f}\" x {max_h.inches:.2f}\", rasio & resolusi utuh).")
    return 0


def main(argv):
    opts = _parse_args(argv)
    if not opts["docx"]:
        print("Pemakaian: py fit-images.py <file.docx> "
              "[--max-height-frac F] [--max-width-in W] [--max-height-in H]")
        return 2
    import os
    if not os.path.isfile(opts["docx"]):
        print(f"[x] File tidak ditemukan: {opts['docx']}")
        return 1
    return fit(opts)


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
