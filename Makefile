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

.PHONY: localdev all clean list-artifacts ci

$(ACT):
	curl -sSfL $(ACT_URL) | sh

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
	$(ACT) | grep --color=always -v '::'

all: $(ACT) localdev

clean:
	if [ -d "$(UPINEVM_OUTPUTPATH)" ]; then rm -rf "$(UPINEVM_OUTPUTPATH)"; fi
	if [ -d "$(UPINEVM_CACHEPATH)" ]; then rm -rf "$(UPINEVM_CACHEPATH)"; fi
	rm -rf $(ACT_ARTIFACTS)
	rm -rf $(ACT)