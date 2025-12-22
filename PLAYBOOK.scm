;;; PLAYBOOK.scm — macrauchenia-ssg Strategic Playbook
;; SPDX-License-Identifier: AGPL-3.0-or-later
;; SPDX-FileCopyrightText: 2025 Jonathan D.A. Jewell

(define-module (macrauchenia-ssg playbook)
  #:export (mission objectives strategies tactics plays))

;; ==========================================================================
;; MISSION
;; ==========================================================================

(define mission
  '((statement . "Provide secure, unified MCP adapters for 28+ static site generators,
                  enabling polyglot SSG orchestration through the hyperpolymath ecosystem")
    (scope . "Deno-based adapter implementations wrapping SSG CLIs via MCP protocol")
    (success-criteria
     . ((adapters-complete . 28)
        (security-hardened . #t)
        (test-coverage . 70)
        (documentation-complete . #t)
        (mcp-integration-verified . #t)))))

;; ==========================================================================
;; OBJECTIVES
;; ==========================================================================

(define objectives
  '((primary
     ((id . "O1")
      (name . "Complete Adapter Coverage")
      (description . "Implement and harden all 28 SSG adapters")
      (key-results
       . ((kr1 . "28 adapters with full tool implementations")
          (kr2 . "100% input validation coverage")
          (kr3 . "Zero critical security vulnerabilities"))))

     ((id . "O2")
      (name . "Quality Assurance")
      (description . "Establish comprehensive testing and CI/CD")
      (key-results
       . ((kr1 . "70% code coverage minimum")
          (kr2 . "E2E tests for all adapter operations")
          (kr3 . "Automated security scanning in CI"))))

     ((id . "O3")
      (name . "Integration Excellence")
      (description . "Seamless integration with poly-ssg-mcp hub")
      (key-results
       . ((kr1 . "Verified MCP protocol compliance")
          (kr2 . "Cross-adapter consistency validated")
          (kr3 . "Performance benchmarks established")))))

    (secondary
     ((id . "O4")
      (name . "Developer Experience")
      (description . "Excellent tooling and documentation")
      (key-results
       . ((kr1 . "Complete cookbook with examples")
          (kr2 . "TypeScript declarations for all adapters")
          (kr3 . "LSP integration for development"))))

     ((id . "O5")
      (name . "Community Readiness")
      (description . "Prepare for open-source community engagement")
      (key-results
       . ((kr1 . "Contributing guide complete")
          (kr2 . "Issue templates operational")
          (kr3 . "Security policy active")))))))

;; ==========================================================================
;; STRATEGIES
;; ==========================================================================

(define strategies
  '((security-first
     ((principle . "All inputs are untrusted until validated")
      (implementation
       . ((validate-all-inputs . "Before any command execution")
          (use-array-args . "Never string interpolation in commands")
          (fail-securely . "Return error, don't leak internals")
          (audit-regularly . "CodeQL + manual review")))))

    (modular-architecture
     ((principle . "Each adapter is independent and self-contained")
      (implementation
       . ((single-file-adapters . "One .js file per SSG")
          (consistent-exports . "name, language, description, tools")
          (standard-patterns . "Reusable validation helpers")
          (no-shared-state . "Stateless execution")))))

    (test-driven-quality
     ((principle . "If it's not tested, it's broken")
      (implementation
       . ((unit-tests . "Each tool function tested")
          (integration-tests . "Adapter lifecycle verified")
          (security-tests . "Input validation verified")
          (e2e-tests . "Full SSG workflows tested")))))

    (progressive-enhancement
     ((principle . "Core functionality first, enhancements later")
      (implementation
       . ((phase-1 . "Basic build/serve tools")
          (phase-2 . "Advanced features per SSG")
          (phase-3 . "Performance optimization")
          (phase-4 . "Extended integrations")))))))

;; ==========================================================================
;; TACTICS
;; ==========================================================================

(define tactics
  '((code-review
     ((frequency . "Every PR")
      (checklist
       . ("SPDX headers present"
          "Input validation complete"
          "No eval/Function usage"
          "Error handling appropriate"
          "Tests added/updated"))))

    (security-scanning
     ((tools . ("CodeQL" "deno lint" "manual audit"))
      (frequency . "Daily (CodeQL), PR (lint), Weekly (manual)")
      (response-sla . "Critical: 24h, High: 72h, Medium: 1 week")))

    (release-process
     ((versioning . "SemVer 2.0.0")
      (steps
       . ("1. Update STATE.scm version"
          "2. Update CHANGELOG.md"
          "3. Run full CI pipeline"
          "4. Create signed tag"
          "5. GitHub release with notes"))))

    (documentation-maintenance
     ((living-docs . ("cookbook.adoc" "README.adoc"))
      (versioned-docs . ("API reference" "CHANGELOG"))
      (update-triggers . ("New feature" "API change" "Security fix"))))))

;; ==========================================================================
;; PLAYS
;; ==========================================================================

(define plays
  '((play-001
     ((name . "New Adapter Implementation")
      (trigger . "Request for new SSG support")
      (steps
       . ("1. Research SSG CLI interface"
          "2. Create adapter from template"
          "3. Implement core tools (init, build, serve)"
          "4. Add input validation"
          "5. Write unit tests"
          "6. Document in cookbook"
          "7. Submit PR for review"))))

    (play-002
     ((name . "Security Vulnerability Response")
      (trigger . "Security report received")
      (steps
       . ("1. Acknowledge within 48h"
          "2. Triage and assess severity"
          "3. Develop fix privately"
          "4. Add regression test"
          "5. Coordinate disclosure"
          "6. Release patch"
          "7. Update SECURITY.md"))))

    (play-003
     ((name . "Major Release Preparation")
      (trigger . "Milestone completion")
      (steps
       . ("1. Feature freeze"
          "2. Full test suite pass"
          "3. Security audit"
          "4. Documentation review"
          "5. CHANGELOG update"
          "6. Version bump in all files"
          "7. Tag and release"
          "8. Announce"))))

    (play-004
     ((name . "Performance Investigation")
      (trigger . "Performance degradation reported")
      (steps
       . ("1. Reproduce with benchmarks"
          "2. Profile execution"
          "3. Identify bottlenecks"
          "4. Implement fix"
          "5. Verify improvement"
          "6. Add performance test"))))))
