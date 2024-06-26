
d_network=ladesa-net
d_container_app=ladesa-ro-auth

compose_options=--file .devops/development/docker-compose.yml -p ladesa-ro-auth

dev-setup:

	$(shell (cd .devops/development; find . -type f -name "*.example" -exec sh -c 'cp -n {} $$(basename {} .example)' \;))

	$(shell (bash -c "sudo docker network create $(d_network) &>/dev/null"))

dev-up:
	make dev-setup;
	sudo docker compose $(compose_options) up -d --remove-orphans;

dev-shell:
	make dev-setup;
	make dev-up;
	sudo docker compose $(compose_options) exec $(d_container_app) bash;

dev-shell-root:
	make dev-setup;
	make dev-up;
	sudo docker compose $(compose_options) exec -u root $(d_container_app) bash;

dev-down:
	make dev-setup;
	sudo docker compose $(compose_options) stop;

dev-logs:
	make dev-setup;
	sudo docker compose $(compose_options) logs -f


dev-start:
	make dev-setup;
	make dev-down;
	make dev-up;

	sudo docker compose $(compose_options) exec -u node --no-TTY -d $(d_container_app) bash -c "npm i && npm run migration:run && npm run start:dev" \&;

dev-cleanup:
	make dev-down;
	sudo docker compose $(compose_options) down -v;