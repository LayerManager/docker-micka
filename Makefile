build-and-push:
	mkdir -p micka-custom
	rm -rf micka-custom/*
	cp -r ../micka-custom/* micka-custom
	export MICKA_CUSTOM_VERSION=$(git -C ../micka-custom rev-parse --short HEAD)
	docker build -t "jirikcz/micka:micka-custom-${MICKA_CUSTOM_VERSION}" .
	docker push "jirikcz/micka:micka-custom-${MICKA_CUSTOM_VERSION}"

build-latest:
	mkdir -p micka-custom
	rm -rf micka-custom/*
	cp -r ../micka-custom/* micka-custom
	docker build -t "jirikcz/micka:micka-custom-latest" .
