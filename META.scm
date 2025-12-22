;; SPDX-License-Identifier: AGPL-3.0-or-later
;; SPDX-FileCopyrightText: 2025 Jonathan D.A. Jewell
;;; META.scm — macrauchenia-ssg

(define-module (macrauchenia-ssg meta)
  #:export (architecture-decisions development-practices design-rationale project-files))

(define architecture-decisions
  '((adr-001
     (title . "RSR Compliance")
     (status . "accepted")
     (date . "2025-12-15")
     (context . "Satellite SSG project in the hyperpolymath ecosystem")
     (decision . "Follow Rhodium Standard Repository guidelines")
     (consequences . ("RSR Gold target" "SHA-pinned actions" "SPDX headers" "Multi-platform CI")))
    (adr-002
     (title . "MCP Adapter Architecture")
     (status . "accepted")
     (date . "2025-12-17")
     (context . "Need to wrap 28+ SSG CLIs with unified interface")
     (decision . "Use Deno-based adapters with MCP protocol")
     (consequences . ("Consistent API" "Runtime security" "Cross-platform support")))
    (adr-003
     (title . "Just-based Build Automation")
     (status . "accepted")
     (date . "2025-12-22")
     (context . "Need standardized build, test, and CI commands")
     (decision . "Use justfile for all automation, Mustfile for invariants")
     (consequences . ("Consistent DX" "CI/CD integration" "Documented recipes")))
    (adr-004
     (title . "Strategic SCM Files")
     (status . "accepted")
     (date . "2025-12-22")
     (context . "Need project governance beyond code")
     (decision . "Add PLAYBOOK.scm, AGENTIC.scm, NEUROSYM.scm for strategic guidance")
     (consequences . ("Clear mission/objectives" "Agentic behavior specs" "Reasoning patterns")))))

(define development-practices
  '((code-style
     (languages . ("javascript" "typescript"))
     (formatter . "deno fmt")
     (linter . "deno lint")
     (line-width . 100))
    (security
     (sast . "CodeQL")
     (credentials . "env vars only")
     (command-injection . "validated")
     (input-validation . "required"))
    (testing
     (coverage-minimum . 70)
     (frameworks . ("deno test"))
     (types . ("unit" "e2e" "security")))
    (versioning
     (scheme . "SemVer 2.0.0"))
    (automation
     (build-tool . "just")
     (invariants . "Mustfile")
     (ci . "GitHub Actions"))))

(define design-rationale
  '((why-rsr "RSR ensures consistency, security, and maintainability.")
    (why-deno "Deno provides secure runtime with permissions model for CLI wrapping.")
    (why-mcp "MCP enables unified interface across diverse SSG tools.")
    (why-just "just provides cross-platform, polyglot-friendly task automation.")
    (why-scm "Scheme files enable machine-readable project metadata and governance.")))

(define project-files
  '((core
     . ("META.scm" "ECOSYSTEM.scm" "STATE.scm"))
    (strategic
     . ("PLAYBOOK.scm" "AGENTIC.scm" "NEUROSYM.scm"))
    (automation
     . ("justfile" "Mustfile" "deno.json"))
    (documentation
     . ("README.adoc" "cookbook.adoc" "SECURITY.md" "CONTRIBUTING.md"))
    (ci-cd
     . (".github/workflows/ci.yml" ".github/workflows/codeql.yml"))))
