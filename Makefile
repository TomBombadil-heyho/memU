.PHONY: install
install:
	@echo "🚀 Creating virtual environment using uv"
	@uv sync
	@uv run pre-commit install

.PHONY: check
check:
	@echo "🚀 Checking lock file consistency with 'pyproject.toml'"
	@uv lock --locked
	@echo "🚀 Linting code: Running pre-commit"
	@uv run pre-commit run -a
	@echo "🚀 Static type checking: Running mypy"
	@uv run mypy
	@echo "🚀 Checking for obsolete dependencies: Running deptry"
	@uv run deptry src


.PHONY: test
test:
	@echo "🚀 Testing code: Running pytest"
	@uv run python -m pytest --cov --cov-config=pyproject.toml --cov-report=xml

.PHONY: cleanup-branches
cleanup-branches:
	@echo "🧹 Cleaning up remote branches (except main)"
	@./scripts/cleanup-branches.sh

.PHONY: cleanup-branches-dry-run
cleanup-branches-dry-run:
	@echo "🧹 Dry run: Showing branches that would be deleted"
	@./scripts/cleanup-branches.sh --dry-run
