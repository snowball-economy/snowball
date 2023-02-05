
install:
	docker run -ti --rm --name=snowball -v $(PWD):/root --workdir=/root node:16-alpine sh -c 'apk add --no-cache git; yarn install'

dev:
	docker network inspect dev >/dev/null 2>&1 || \
		docker network create dev
	docker container inspect mongo >/dev/null 2>&1 || \
		docker run -d --rm --name=mongo --net=dev -p 27017:27017 docker.io/mongo:4.4.18
	docker container inspect mongo-express >/dev/null 2>&1 || \
		docker run -d  --rm --name=mongo-express --net=dev -p 8081:8081 -e ME_CONFIG_MONGODB_SERVER=mongo docker.io/mongo-express

run-dev: dev
	docker run -ti --rm --name=snowball --net=dev -p 3000:3000 -v $(PWD):/root --workdir=/root docker.io/node:16-alpine yarn run dev


# Cleanup
devclean:
	docker rm -ivf mongo mongo-express
	docker network rm -f dev

clean: devclean
	docker run -ti --rm -v $(PWD):/root --workdir=/root node:16-alpine yarn cache clean
	rm -rf node_modules/
	rm -rf .next/
