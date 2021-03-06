.DEFAULT_GOAL := usage

.PHONY: usage
usage:
	@echo "Usage:"
	@echo "=========="
	@echo "make usage - display Makefile target info"
	@echo "make buildlocal - builds the binary locally"
	@echo "make runlocal - runs the binary locally"
	@echo "make builddocker - builds the binary and Docker container"
	@echo "make rundocker - creates and runs a new Docker container"
	@echo "make startdocker - resumes a stopped Docker container"
	@echo "make stopdocker - stops the Docker container"
	@echo "make removedocker - removes the Docker container"
	@echo "make memusage - displays the memory usage of the currently running Docker container"
	@echo "make logs - displays logs"

.PHONY: buildlocal
buildlocal:
	CGO_ENABLED=0 go build -o bin/bot ./...

.PHONY: runlocal
runlocal: buildlocal
	./bin/bot -token=$(PURDOOBAH_DISCORD_BOT_TOKEN)

.PHONY: builddocker
builddocker:
	docker build --tag purdoobah-discord-bot --file build/Dockerfile .

.PHONY: rundocker
rundocker: builddocker
	docker run \
	--name "purdoobah_discord_bot" \
	-d --restart unless-stopped \
	-e PURDOOBAH_DISCORD_BOT_TOKEN \
	purdoobah-discord-bot

.PHONY: startdocker
startdocker:
	docker start purdoobah_discord_bot

.PHONY: stopdocker
stopdocker:
	docker stop purdoobah_discord_bot

.PHONY: removedocker
removedocker:
	docker rm purdoobah_discord_bot

.PHONY: memusage
memusage:
	docker stats purdoobah_discord_bot --no-stream --format "{{.Container}}: {{.MemUsage}}"

.PHONY: logs
logs:
	docker logs purdoobah_discord_bot
