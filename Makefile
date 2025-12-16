install:
	pip install --upgrade pip &&\
		pip install -r requirements.txt

format:	
	black *.py 

train:
	@echo "Creating Model and Results directories..."
	mkdir -p Model
	mkdir -p Results
	
	@echo "Starting training script..."
	python train.py
eval:
	echo "## Model Metrics" > report.md
	cat ./Results/metrics.txt >> report.md
	
	echo '\n## Confusion Matrix Plot' >> report.md
	echo '![Confusion Matrix](./Results/model_results.png)' >> report.md
	
	cml comment create report.md
		
update-branch:
	git config --global user.name $(USER_NAME)
	git config --global user.email $(USER_EMAIL)
	git commit -am "Update with new results"
	git push --force origin HEAD:update

hf-login: 
	# No es necesario instalar [cli] extra en versiones nuevas, pero no hace daño.
	pip install -U huggingface_hub
	git pull origin update
	git switch update
	# CAMBIO: Usar 'hf login' en lugar de 'huggingface-cli login' o 'python -m ...'
	hf login --token $(HF) --add-to-git-credential

push-hub:
	# CAMBIO: Usa el ID exacto que aparece en tu navegador: Alan012/Drug-classification
	hf upload Alan012/Drug-classification ./App --repo-type=space --commit-message="Sync App files"
	hf upload Alan012/Drug-classification ./Model /Model --repo-type=space --commit-message="Sync Model"
	hf upload Alan012/Drug-classification ./Results /Metrics --repo-type=space --commit-message="Sync Model"
	
deploy: hf-login push-hub

all: install format train eval update-branch deploy