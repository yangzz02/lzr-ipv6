ifeq ($(OS),Windows_NT)
  EXECUTABLE_EXTENSION := .exe
else
  EXECUTABLE_EXTENSION :=
endif

GO_FILES = $(shell find . -type f -name '*.go')

all: lzr
	@echo "Set iptables rule before using lzr:"
	@echo "sudo ip6tables -A OUTPUT -p tcp --tcp-flags RST RST -s device-source-ip -j DROP"

lzr: $(GO_FILES)
	cd cmd/lzr && go build && cd ../..
	rm -f lzr
	ln -s cmd/lzr/lzr$(EXECUTABLE_EXTENSION) lzr

lzr_race: $(GO_FILES)
	cd cmd/lzr && go build -race && cd ../..
	rm -f lzr
	ln -s cmd/lzr/lzr$(EXECUTABLE_EXTENSION) lzr

clean:
	cd cmd/lzr && go clean
	rm -f lzr
	@echo "Don't forget to delete iptables rule using:"
	@echo "sudo ip6tables -L --line-numbers && sudo ip6tables -D OUTPUT \TK"
