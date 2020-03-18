build-latest:
	docker build -f Dockerfile -t "jirikcz/micka:micka-latest" .

build-custom-and-push:
	mkdir -p micka-custom
	rm -rf micka-custom/*
	cp -r ../micka-fork/* micka-custom
	export MICKA_CUSTOM_VERSION=$$docker build -f Dockerfile -t "jirikcz/micka:micka-latest" --build-arg MICKA_VERSION=${MICKA_VERSION} .(git -C ../micka-fork rev-parse --short HEAD)
	docker build -f Dockerfile.custom -t "jirikcz/micka:micka-custom-$${MICKA_CUSTOM_VERSION}" .
	docker push "jirikcz/micka:micka-custom-$${MICKA_CUSTOM_VERSION}"

build-custom-latest:
	mkdir -p micka-custom
	rm -rf micka-custom/*
	cp -r ../micka-fork/* micka-custom
	docker build -f Dockerfile.custom -t "jirikcz/micka:micka-custom-latest" .

