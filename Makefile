.POSIX:
EMACS = emacs

SRC = prometheus-mode.el prometheus-data-mode.el
ELC = prometheus-mode.elc prometheus-data-mode.elc

compile: $(ELC)

prometheus-mode.elc: $(SRC)

clean:
	@rm -f $(ELC)

.SUFFIXES: .el .elc
.el.elc:
	@$(EMACS) -batch -Q -L . -f batch-byte-compile $<
