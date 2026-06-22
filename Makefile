.ONESHELL:
.PHONY: all add amend beautiful black clean commit commit-version echo isort jacobus pypi rebase reset toml_sorted works
SHELL := /bin/zsh

all: beautiful commit-version

add:
	git add -A;

amend: add
	git commit --amend --no-edit;

beautiful: isort black jacobus toml_sorted

black: works
	conda run -n works pip install 'black>=24.5,<26' >/dev/null;
	conda run -n works black --line-length=79 . ;

commit: add
	git commit --allow-empty $(PARAMS);

commit-version: add works
	conda run -n works pip install 'toml_get>=1.0,<2' >/dev/null;
	git commit --allow-empty "$$(conda run -n works python -m toml_get @make/toml_get.txt)";

clean:
	rm -fr 'dist/';

echo:
	echo $(PARAMS);

isort: works
	conda run -n works pip install 'isort>=6.0,<7' >/dev/null;
	conda run -n works isort . ;

jacobus: works
	conda run -n works pip install 'jacobus>=2.2,<3' >/dev/null;
	conda run -n works python -m jacobus @make/jacobus.txt;
	conda run -n works python -m jacobus @make/jacobus_empty.txt;
	conda run -n works python -m jacobus @make/jacobus_sort.txt;

rebase:
	git rebase --empty=drop --interactive $(PARAMS);

reset:
	git reset HEAD~1

toml_sorted: works
	conda run -n works pip install 'toml_sorted>=2.1,<3' >/dev/null;
	conda run -n works python -m toml_sorted @make/toml_sorted_pyproject.txt;

works:
	conda run -n base python make/env.py works --python=3.11;
