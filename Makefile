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
	# 1. Pull the latest state of the 'update' branch
	git pull origin update
	# 2. Switch to the 'update' branch (where the model is located)
	git switch update
	# 3. Install Hugging Face CLI
	pip install -U "huggingface_hub[cli]"
	# 4. Log in using the token passed from the workflow
	huggingface-cli login --token $(HF) --add-to-git-credential

push-hub:
	# Upload App folder (Python, README, requirements.txt)
	huggingface-cli upload Alan012/Drug-classification ./App --repo-type=space --commit-message="Sync App files"
	# Upload Model folder (pipeline.skops)
	huggingface-cli upload Alan012/Drug-classification ./Model /Model --repo-type=space --commit-message="Sync Model"
	# Upload Results folder (metrics, plot)
	huggingface-cli upload Alan012/Drug-classification ./Results /Metrics --repo-type=space --commit-message="Sync Model"

deploy: hf-login push-hub

all: install format train eval update-branch deploy