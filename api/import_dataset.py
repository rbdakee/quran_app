"""
Import dataset.csv into quran_tokens table.

Usage:
  cd quran-app
  python -m api.import_dataset
"""
from __future__ import annotations

import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent.parent))

from api.models.db import SessionLocal, engine, Base
from api.models.orm import QuranToken
from engine.generate_lesson import read_tokens


def main():
    # Ensure tables exist
    Base.metadata.create_all(bind=engine)

    db = SessionLocal()
    try:
        existing = db.query(QuranToken).count()
        if existing > 0:
            print(f"quran_tokens already has {existing} rows. Skipping import.")
            print("To re-import, truncate the table first: TRUNCATE quran_tokens CASCADE;")
            return

        dataset_path = Path(__file__).resolve().parent.parent / "dataset.csv"
        tokens = read_tokens(dataset_path)
        print(f"Loaded {len(tokens)} tokens from dataset.csv (after Muqatta'at filter)")

        batch_size = 5000
        total = 0

        for i in range(0, len(tokens), batch_size):
            batch = tokens[i:i + batch_size]
            rows = [
                QuranToken(
                    token_id=t.token_id,
                    surah=t.surah,
                    ayah=t.ayah,
                    word=t.word,
                    location=t.location,
                    audio_key=t.audio_key or None,
                    full_form_ar=t.full_form_ar,
                    lemma_ar=t.lemma_ar or None,
                    root_ar=t.root_ar or None,
                    pos=t.pos or None,
                    translation_en=t.translation_en or None,
                    concept_key=t.concept_key or None,
                    freq_global=t.freq_global,
                    concept_freq=t.concept_freq,
                )
                for t in batch
            ]
            db.bulk_save_objects(rows)
            db.commit()
            total += len(rows)
            print(f"  Imported {total}/{len(tokens)}...")

        print(f"Done. {total} tokens imported into quran_tokens.")

    finally:
        db.close()


if __name__ == "__main__":
    main()
