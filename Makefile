SETUP_FOLDER := setup/
SOURCES := main.go
INSTALL_BINARY := install

.PHONY : build run install clean

build:
	cd $(SETUP_FOLDER) && go build -o ../$(INSTALL_BINARY) $(SOURCES)

run:
	./$(INSTALL_BINARY)

install: build run

clean:
	rm -rf $(INSTALL_BINARY)