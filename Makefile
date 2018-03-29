.PHONY: all
all:
	jbuilder build

.PHONY: test
test:
	jbuilder runtest

.PHONY: clean
clean:
	jbuilder clean
