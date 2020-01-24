build:
	mkdir -p micka-custom
	rm -rf micka-custom/*
	cp -r ../micka-custom/* micka-custom
	docker build -t micka-custom .
