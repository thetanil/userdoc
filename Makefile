SHELL := /bin/sh
.SHELLFLAGS := -ec

ifneq (,$(wildcard ./.env))
	include .env
	export
endif

GITHUB_TOKEN := $(shell gh auth token)
ACT := ./bin/act
ACTCMD := $(ACT) -s GITHUB_TOKEN=$(GITHUB_TOKEN)
ACT_URL := https://raw.githubusercontent.com/nektos/act/master/install.sh
ACT_ARTIFACTS := /tmp/act_artifacts/1

all: localdev

.PHONY: localdev all clean list-artifacts ci run-upina-make unpack

$(ACT):
	if [ ! -f $(ACT) ]; then curl -sSfL $(ACT_URL) | sh; fi

$(ACT_ARTIFACTS):
	mkdir -p $(ACT_ARTIFACTS)

list-artifacts:
	@ls -l $(ACT_ARTIFACTS)

ci: $(ACT)
	$(ACT)

$(UPINE_BUILDER): $(ACT_ARTIFACTS) $(ACT)
	$(ACT) -s GITHUB_TOKEN=$(GITHUB_TOKEN) -b upine_builder

localdev: $(ACT)
	# don't echo token, filter out debug messages
	echo localdev
	$(ACT) | grep --color=always -v '::'

run-upina-make: localdev
	sh -e -c upina/launch.sh

run-upina-sh: localdev
	sh -e -c upina/sh/launch.sh

.PHONY: unpack
unpack: localdev
	@echo "Unpacking upina"
	./scripts/unpack.sh

clean:
	if [ -d "$(UPINEVM_CACHEPATH)" ]; then sudo rm -rf "$(UPINEVM_CACHEPATH)"; fi
	if [ -d "$(HOME)/.cache/act" ]; then sudo rm -rf "$(HOME)/.cache/act"; fi
	# rm -rf $(ACT)
	if [ -d "$(UPINEVM_OUTPUTPATH)" ]; then rm -rf "$(UPINEVM_OUTPUTPATH)"; fi
	rm -rf $(ACT_ARTIFACTS)