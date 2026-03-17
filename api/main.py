"""
Quran Learning App — FastAPI entrypoint.

Run:
  cd quran-app
  uvicorn api.main:app --reload --port 8000
"""
from __future__ import annotations

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from api.config import settings
from api.models.db import engine, Base
from api.routers import lessons, progress

# Create tables on startup (dev mode; use Alembic for production)
Base.metadata.create_all(bind=engine)

app = FastAPI(
    title="Quran Learning API",
    description="Backend API for Quran word learning with implicit SRS",
    version="0.1.0",
)

# CORS — allow all in dev
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Routers
app.include_router(lessons.router)
app.include_router(progress.router)


@app.get("/")
def root():
    return {
        "app": "Quran Learning API",
        "version": "0.1.0",
        "algorithm": "v3-graduated-srs-dynamic-ratio",
        "docs": "/docs",
    }


@app.get("/health")
def health():
    return {"status": "ok"}
