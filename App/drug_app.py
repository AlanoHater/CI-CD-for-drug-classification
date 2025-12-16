import gradio as gr
import skops.io as sio

# --- INICIO DEL PARCHE DE SEGURIDAD PARA SKOPS ---
# Esta lista debe contener todas las clases usadas en tu pipeline (ver train.py)
trusted_types = [
    "sklearn.pipeline.Pipeline",
    "sklearn.compose.ColumnTransformer",
    "sklearn.preprocessing.OrdinalEncoder",
    "sklearn.impute.SimpleImputer",
    "sklearn.preprocessing.StandardScaler",
    "sklearn.ensemble.RandomForestClassifier",
    "sklearn.tree.DecisionTreeClassifier", # Necesaria porque RandomForest la usa internamente
    "numpy.dtype",
]
# Ahora la función load usa la lista en lugar del booleano 'True'
pipe = sio.load("./Model/drug_pipeline.skops", trusted=trusted_types)
# --- FIN DEL PARCHE DE SEGURIDAD ---

def predict_drug(age, sex, blood_pressure, cholesterol, na_to_k_ratio):
    """Predice el tipo de droga basado en las características del paciente."""
    
    features = [age, sex, blood_pressure, cholesterol, na_to_k_ratio]
    predicted_drug = pipe.predict([features])[0]

    label = f"Predicted Drug: {predicted_drug}"
    return label


# --------------------------------------------------
# Configuración de la Interfaz Gradio (Sin cambios)
# --------------------------------------------------

inputs = [
    gr.Slider(15, 74, step=1, label="Age"),
    gr.Radio(["M", "F"], label="Sex"),
    gr.Radio(["HIGH", "LOW", "NORMAL"], label="Blood Pressure"),
    gr.Radio(["HIGH", "NORMAL"], label="Cholesterol"),
    gr.Slider(6.2, 38.2, step=0.1, label="Na_to_K"),
]
outputs = [gr.Label(num_top_classes=5)]

examples = [
    [30, "M", "HIGH", "NORMAL", 15.4],
    [35, "F", "LOW", "NORMAL", 8],
    [50, "M", "HIGH", "HIGH", 34],
]

title = "Drug Classification"
description = "Enter the details to correctly identify Drug type?"
article = "This app is a part of the Beginner's Guide to CI/CD for Machine Learning. It teaches how to automate training, evaluation, and deployment of models to Hugging Face using GitHub Actions."


gr.Interface(
    fn=predict_drug,
    inputs=inputs,
    outputs=outputs,
    examples=examples,
    title=title,
    description=description,
    article=article,
    theme=gr.themes.Soft(), 
).launch()