
install:
	docker run -ti --rm -v $(PWD):/root --workdir=/root node:16-alpine sh -c 'apk add --no-cache git; yarn install'

deps:
	docker network inspect dev >/dev/null 2>&1 || docker network create dev
	docker inspect mongo >/dev/null 2>&1 || docker run -d --rm --net=dev --name=mongo -p 27017:27017 docker.io/mongo:4.4.18

run-dev: deps
	docker run -ti --rm --net=dev -v $(PWD):/root --workdir=/root -p 3000:3000 docker.io/node:16-alpine yarn run dev

clean:
	docker run -ti --rm -v $(PWD):/root --workdir=/root node:16-alpine yarn cache clean
	rm -rf node_modules/
	rm -rf .next/
	docker rm -ivf mongo
	docker network rm -f dev
