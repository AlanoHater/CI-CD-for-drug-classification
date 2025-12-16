install:
	pip install --upgrade pip &&\
		pip install -r requirements.txt

format:	
	black *.py 

train:
<<<<<<< HEAD
	@echo "Creating Model and Results directories..."
	mkdir -p Model
	mkdir -p Results
	
	@echo "Starting training script..."
=======
>>>>>>> 4104069ed5c95ea921a9ba73d84f0277ee6f365c
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
	pip install -U "huggingface_hub[cli]"
	git pull origin update
	git switch update
	huggingface-cli login --token $(HF) --add-to-git-credential

push-hub: 
	huggingface-cli upload kingabzpro/Drug-Classification ./App --repo-type=space --commit-message="Sync App files"
	huggingface-cli upload kingabzpro/Drug-Classification ./Model /Model --repo-type=space --commit-message="Sync Model"
	huggingface-cli upload kingabzpro/Drug-Classification ./Results /Metrics --repo-type=space --commit-message="Sync Model"

deploy: hf-login push-hub

<<<<<<< HEAD
all: install format train eval update-branch deploy
=======
all: install format train eval update-branch deploy
>>>>>>> 4104069ed5c95ea921a9ba73d84f0277ee6f365c
