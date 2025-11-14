# Minimal makefile for Sphinx documentation
#

# You can set these variables from the command line, and also
# from the environment for the first two.
SPHINXOPTS    ?=
SPHINXBUILD   ?= sphinx-build
SOURCEDIR     = .
BUILDDIR      = _build

.PHONY: multi-docs
multi-docs:
	@sphinx-multiversion "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS)
	@cp _redirect/index.html $(BUILDDIR)/index.html

.PHONY: current-docs
current-docs:
	@$(SPHINXBUILD) "$(SOURCEDIR)" "$(BUILDDIR)/current" $(SPHINXOPTS)

.PHONY: livehtml
livehtml:
	@sphinx-autobuild "$(SOURCEDIR)" "$(BUILDDIR)/current" $(SPHINXOPTS) --host 0.0.0.0 --port 8000 --open-browser
