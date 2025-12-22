;; SPDX-License-Identifier: AGPL-3.0-or-later
;; SPDX-FileCopyrightText: 2025 Jonathan D.A. Jewell
;;; META.scm — macrauchenia-ssg

(define-module (macrauchenia-ssg meta)
  #:export (architecture-decisions development-practices design-rationale))

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
     (consequences . ("Consistent API" "Runtime security" "Cross-platform support")))))

(define development-practices
  '((code-style (languages . ("javascript" "typescript")) (formatter . "deno fmt") (linter . "deno lint"))
    (security (sast . "CodeQL") (credentials . "env vars only") (command-injection . "validated"))
    (testing (coverage-minimum . 70))
    (versioning (scheme . "SemVer 2.0.0"))))

(define design-rationale
  '((why-rsr "RSR ensures consistency, security, and maintainability.")
    (why-deno "Deno provides secure runtime with permissions model for CLI wrapping.")
    (why-mcp "MCP enables unified interface across diverse SSG tools.")))
