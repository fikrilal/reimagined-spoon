# Engineering Decisions

## Purpose

This document records decisions that meaningfully affect behavior,
maintainability, data integrity, or learning outcomes. Do not record trivial
formatting or naming choices.

## Status Values

- `Proposed`
- `Accepted`
- `Superseded`

## D-001: Build an Offline-Only Application

**Status:** Accepted  
**Date:** 2026-07-17

### Context

The project is limited to one week and focuses on Flutter, GetX, and SQLite
fundamentals. Networking, authentication, and synchronization would introduce
unrelated complexity.

### Options Considered

1. Offline-only local application
2. Local application with a mock API
3. Application connected to a real backend

### Decision

The application will operate offline and use SQLite as its persisted source of
truth.

### Consequences

- The project remains focused on the intended fundamentals.
- Data is available only on the device.
- There is no account recovery or multi-device synchronization.
- Synchronization conflicts are outside the project scope.

### Reconsider When

A future learning objective explicitly requires networking, authentication, or
synchronization.

## Decision Template

Copy this section for each new decision.

## D-XXX: Short Decision Title

**Status:** Proposed  
**Date:** YYYY-MM-DD

### Context

What problem or uncertainty requires a decision?

### Options Considered

1. Option one
2. Option two
3. Option three

### Decision

What was chosen?

### Rationale

Why was this option selected?

### Consequences

What becomes easier, harder, or constrained because of this decision?

### Reconsider When

What new information or requirement would justify revisiting the decision?
