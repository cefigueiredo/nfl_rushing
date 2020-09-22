MIX_ENV ?= prod

NAME=$(MIX_ENV)-nfl_rushing
IMG_NAME=$(NAME):latest

define HELP
Usage:
	make build-image
		Build the docker image and compile the the app

	make rebuild-image
		Rebuild the docker image

	make start
		Start the app on a new docker container and attach the STDOUT

	make start-daemon
		Start the app on a new daemon docker container.
		The container will restart on failure and when docker restarts, 
		unless it was explicitly stopped.

	make stop
		Stop the app container.

	make help
		Shows this help message

Obs.1: The app is expected to listen to port 4000/tcp
Obs.2: The app will run on `prod` environment unless a $$MIX_ENV is provided.
	Ex. MIX_ENV=dev make build
	This would build the image to run using `dev` environment.

endef

.PHONY: start
start: build-image
	docker run -p 4000:4000 --rm --name $(NAME) $(IMG_NAME)

.PHONY: build-image
build-image:
	MIX_ENV=$(MIX_ENV) docker build -t $(IMG_NAME) .

.PHONY: rebuild-image
rebuild-image:
	MIX_ENV=$(MIX_ENV) docker build -t $(IMG_NAME) --no-cache .

.PHONY: start-daemon
start-daemon:
	docker run -p 4000:4000 -d --restart unless-stopped --name $(NAME) $(IMG_NAME)

.PHONY: kill
kill:
	docker stop $(NAME)
	docker rm $(NAME)

.PHONY: logs
logs:
	docker logs $(NAME)

.PHONY: help
help:
	$(info $(HELP))
