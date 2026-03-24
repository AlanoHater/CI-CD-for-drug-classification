# CI/CD for Drug Classification

Proyecto de ejemplo que muestra un flujo básico de CI/CD para un proyecto de Machine Learning (entrenamiento, evaluación y despliegue de una aplicación Gradio). El objetivo es enseñar la automatización de entrenamiento, evaluación y despliegue (por ejemplo a Hugging Face Spaces) usando GitHub Actions.

---

## Contenido principal

- `train.py` — Script de entrenamiento. Carga `Data/drug.csv`, entrena un pipeline de scikit-learn (OrdinalEncoder, imputación, StandardScaler + RandomForest) y guarda:
  - Modelo: `./Model/drug_pipeline.skops`
  - Métricas: `./Results/metrics.txt`
  - Gráfica de matriz de confusión: `./Results/model_results.png`
- `App/drug_app.py` — Interfaz Gradio que carga el pipeline guardado con `skops` (usa una lista `trusted_types` para seguridad) y expone una función `predict_drug(...)`.
- `Data/drug.csv` — Dataset de ejemplo con columnas: `Age, Sex, BP, Cholesterol, Na_to_K, Drug`.
- `.devcontainer/` — Definición básica de entorno de desarrollo (devcontainer.json).
- `.github/workflows/` — Carpeta preparada para agregar los workflows de GitHub Actions (vacía actualmente).
- `Makefile` — Presente en la raíz (revisar para tareas comunes).
- `requirements.txt` y `App/requirements.txt` — Dependencias del proyecto (instalar antes de ejecutar).

---

## Requisitos

- Python 3.8+ (recomendado)
- pip
- Recomendado: entorno virtual (venv, conda)
- Dependencias: instalar desde `requirements.txt` (y `App/requirements.txt` si ejecutas solo la app)

Ejemplo:
```bash
python -m venv .venv
source .venv/bin/activate   # Linux/Mac
# .venv\Scripts\activate    # Windows
pip install -r requirements.txt
