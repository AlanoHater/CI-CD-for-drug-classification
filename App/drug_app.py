import gradio as gr
import skops.io as sio

# Cargar el pipeline de scikit-learn guardado por train.py
# Asegúrate de que esta ruta sea correcta dentro de la estructura Docker/Space
pipe = sio.load("./Model/drug_pipeline.skops", trusted=True)

def predict_drug(age, sex, blood_pressure, cholesterol, na_to_k_ratio):
    """Predice el tipo de droga basado en las características del paciente.

    Args:
        age (int): Edad del paciente
        sex (str): Sexo del paciente 
        blood_pressure (str): Nivel de presión arterial
        cholesterol (str): Nivel de colesterol
        na_to_k_ratio (float): Proporción de sodio a potasio en la sangre

    Returns:
        str: Etiqueta de la droga predicha
    """
    # El modelo espera las características en una lista dentro de una lista (formato de entrada de scikit-learn)
    features = [age, sex, blood_pressure, cholesterol, na_to_k_ratio]
    predicted_drug = pipe.predict([features])[0]

    label = f"Predicted Drug: {predicted_drug}"
    return label


# --------------------------------------------------
# Configuración de la Interfaz Gradio
# --------------------------------------------------

# Definición de los componentes de entrada (Sliders y Radio Buttons)
inputs = [
    gr.Slider(15, 74, step=1, label="Age"),
    gr.Radio(["M", "F"], label="Sex"),
    gr.Radio(["HIGH", "LOW", "NORMAL"], label="Blood Pressure"),
    gr.Radio(["HIGH", "NORMAL"], label="Cholesterol"),
    gr.Slider(6.2, 38.2, step=0.1, label="Na_to_K"),
]
# Definición del componente de salida
outputs = [gr.Label(num_top_classes=5)]

# Ejemplos para facilitar la prueba de la aplicación
examples = [
    [30, "M", "HIGH", "NORMAL", 15.4],
    [35, "F", "LOW", "NORMAL", 8],
    [50, "M", "HIGH", "HIGH", 34],
]

# Metadatos de la aplicación
title = "Drug Classification"
description = "Enter the details to correctly identify Drug type?"
article = "This app is a part of the Beginner's Guide to CI/CD for Machine Learning. It teaches how to automate training, evaluation, and deployment of models to Hugging Face using GitHub Actions."


# Creación y lanzamiento de la interfaz
gr.Interface(
    fn=predict_drug,
    inputs=inputs,
    outputs=outputs,
    examples=examples,
    title=title,
    description=description,
    article=article,
    theme=gr.themes.Soft(), # Aplica el tema 'Soft' para un look moderno
).launch()